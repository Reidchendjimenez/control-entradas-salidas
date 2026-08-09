import os
import sys
from typing import Optional
from pathlib import Path
from pydantic_settings import BaseSettings
from dotenv import load_dotenv

# --- BÚSQUEDA DEL .env (compatible con PyInstaller y Flet 0.86+) ---
# En modo compilado (PyInstaller), los datos empaquetados con --add-data
# quedan en sys._MEIPASS. El .env se empaqueta en la raíz de _MEIPASS.
# En Flet 0.86+ (Android/desktop): los archivos de la app viajan desempaquetados
# y de solo lectura; el directorio de trabajo (cwd) es FLET_APP_STORAGE_DATA
# (directorio de datos privado y escribible de la app).
_MEIPASS = getattr(sys, '_MEIPASS', None)
basedir = Path(__file__).parent

def _candidate_env_paths():
    """Rutas candidatas para buscar .env en orden de prioridad."""
    cand = []

    # 1. Desarrollo: raíz del proyecto y config/
    cand.append(basedir.parent / ".env")   # Raíz del proyecto (../.env)
    cand.append(basedir / ".env")          # Dentro de config/

    # 2. Directorio de trabajo actual (Flet 0.86: FLET_APP_STORAGE_DATA)
    cwd = Path.cwd()
    cand.append(cwd / ".env")
    cand.append(cwd / "config" / ".env")

    # 3. PyInstaller (_MEIPASS = _internal/ en onedir COLLECT)
    if _MEIPASS:
        meipass = Path(_MEIPASS)
        cand.insert(0, meipass / ".env")                    # _internal/.env
        cand.insert(1, meipass.parent / ".env")             # dist/Lycoris/.env (junto al exe)
        cand.insert(2, meipass / "config" / ".env")         # _internal/config/.env

    # 4. Flet 0.86: variables de entorno de almacenamiento
    for var in ("FLET_APP_STORAGE_DATA", "FLET_APP_STORAGE_TEMP", "FLET_APP_STORAGE_CACHE"):
        p = os.getenv(var)
        if p:
            base = Path(p)
            cand.append(base / ".env")
            cand.append(base / "config" / ".env")

    # 5. Ejecutable (Windows onedir: dist/Lycoris/)
    if getattr(sys, 'frozen', False):
        exe_dir = Path(sys.executable).parent
        cand.append(exe_dir / ".env")
        cand.append(exe_dir / "config" / ".env")

    # 6. app_updates (actualizaciones en vivo)
    updates = basedir.parent / "app_updates"
    cand.append(updates / ".env")
    cand.append(updates / "config" / ".env")

    return cand

posibles_rutas = _candidate_env_paths()

env_path = None
for ruta in posibles_rutas:
    if ruta.exists():
        env_path = str(ruta)
        load_dotenv(env_path)
        break

# --- FALLBACK: credenciales empaquetadas (config/db_config.py) ---
# En los builds compilados (Windows exe / APK) el archivo .env puede no
# viajar dentro del bundle (archivo oculto/gitignored). db_config.py es un
# módulo Python normal que SIEMPRE se empaqueta; si no se cargó .env,
# inyectamos esas variables en el entorno para que Settings las lea.
if not os.getenv("DB_PASSWORD"):
    try:
        from config import db_config as _db_config
        for _key in ("DB_TYPE", "DB_HOST", "DB_PORT", "DB_NAME",
                     "DB_USER", "DB_PASSWORD", "SQLITE_PATH", "UPDATE_URL"):
            _val = getattr(_db_config, _key, None)
            if _val and not os.getenv(_key):
                os.environ[_key] = _val
    except Exception as _e:
        print(f"⚠️ No se pudo cargar config/db_config.py: {_e}")
# ---------------------------------------------

class Settings(BaseSettings):
    # --- TU CONFIGURACIÓN ORIGINAL (Mantenida intacta) ---
    DB_TYPE: str = os.getenv("DB_TYPE", "postgresql")
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: str = os.getenv("DB_PORT", "6543")
    DB_NAME: str = os.getenv("DB_NAME", "postgres")
    DB_USER: str = os.getenv("DB_USER", "postgres")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "")
    
    # --- CONFIGURACIÓN LOCAL (OFFLINE) ---
    LOCAL_DB_PATH: str = os.getenv("LOCAL_DB_PATH", "")
    DEVICE_ID: str = os.getenv("DEVICE_ID", "")
    
    @property
    def DATABASE_URL(self) -> str:
        """Construye la URL de conexión a la base de datos de forma segura."""
        if self.DB_TYPE.lower() == "sqlite":
            return f"sqlite:///{self.SQLITE_PATH}"
        
        port_str = str(self.DB_PORT).strip()
        final_port = port_str if port_str.isdigit() else "5432"
        
        # Validación mejorada con diagnóstico de rutas
        if not self.DB_PASSWORD:
            rutas_vistas = "\n".join([str(r) for r in posibles_rutas])
            raise ValueError(
                f"DB_PASSWORD no está configurada.\n"
                f"Se buscó el archivo .env en:\n{rutas_vistas}\n"
                f"Archivo cargado actualmente: {env_path}"
            )
        
        return f"postgresql+pg8000://{self.DB_USER}:{self.DB_PASSWORD}@{self.DB_HOST}:{final_port}/{self.DB_NAME}"
    
    @property
    def LOCAL_DATABASE_URL(self) -> str:
        from usr.database.conn import get_db_path
        try:
            return f"sqlite:///{get_db_path()}"
        except RuntimeError:
            return "sqlite:///lycoris_local.db"
    
    @property
    def DEVICE_IDENTIFIER(self) -> str:
        """Identificador único del dispositivo."""
        if self.DEVICE_ID:
            return self.DEVICE_ID
        
        import os
        import uuid
        device_file = os.path.join(os.path.dirname(__file__), '.device_id')
        
        if os.path.exists(device_file):
            with open(device_file, 'r') as f:
                return f.read().strip()
        
        new_id = f"device_{uuid.uuid4().hex[:8]}"
        with open(device_file, 'w') as f:
            f.write(new_id)
        
        return new_id
    
    # --- EL RESTO DE TUS VARIABLES ORIGINALES ---
    FLET_APP_NAME: str = os.getenv("FLET_APP_NAME", "Lycoris_Control")
    FLET_APP_ICON: str = os.getenv("FLET_APP_ICON", "favicon.png")
    FLET_APP_VERSION: str = os.getenv("FLET_APP_VERSION", "1.0.0")
    
    FLET_WEB_PORT: str = os.getenv("FLET_WEB_PORT", "8502")
    FLET_WEB_HOST: str = os.getenv("FLET_WEB_HOST", "0.0.0.0")
    SECRET_KEY: str = os.getenv("SECRET_KEY", "dev_key")
    DEBUG: str = os.getenv("DEBUG", "False")
    UPLOAD_DIR: str = os.getenv("UPLOAD_DIR", "./uploads")
    MAX_FILE_SIZE: str = os.getenv("MAX_FILE_SIZE", "10485760")
    SQLITE_PATH: str = os.getenv("SQLITE_PATH", "./control_entradas_salidas.db")

    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")

    class Config:
        # Usamos la ruta encontrada dinámicamente
        env_file = env_path if env_path else ".env"
        extra = "allow"

# --- TU PATRÓN SINGLETON ORIGINAL ---
_settings: Optional[Settings] = None

def get_settings() -> Settings:
    global _settings
    if _settings is None:
        try:
            _settings = Settings()
        except ValueError as e:
            # Esto permitirá que tu código "Detective" atrape el error
            print(f"❌ Error de configuración: {e}")
            raise
    return _settings