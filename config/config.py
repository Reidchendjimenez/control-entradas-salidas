import os
from typing import Optional
from pydantic_settings import BaseSettings
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()


class Settings(BaseSettings):
    # Tipo de base de datos: sqlite o postgresql
    DB_TYPE: str = os.getenv("DB_TYPE", "sqlite")
    
    # Configuración SQLite
    SQLITE_PATH: str = os.getenv("SQLITE_PATH", "./control_entradas_salidas.db")
    
    # Configuración PostgreSQL
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: int = int(os.getenv("DB_PORT", "5432"))
    DB_NAME: str = os.getenv("DB_NAME", "control_entradas_salidas")
    DB_USER: str = os.getenv("DB_USER", "postgres")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "")
    
    @property
    def DATABASE_URL(self) -> str:
        if self.DB_TYPE.lower() == "sqlite":
            return f"sqlite:///{self.SQLITE_PATH}"
        else:
            return f"postgresql://{self.DB_USER}:{self.DB_PASSWORD}@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
    
    # Configuración de la aplicación
    SECRET_KEY: str = os.getenv("SECRET_KEY", "tu-clave-secreta-por-defecto")
    DEBUG: bool = os.getenv("DEBUG", "True").lower() == "true"
    
    # Configuración de Flet
    FLET_APP_NAME: str = "Control Entradas y Salidas"
    FLET_APP_VERSION: str = "1.0.0"
    FLET_WEB_PORT: int = int(os.getenv("FLET_WEB_PORT", "8502"))
    FLET_WEB_HOST: str = os.getenv("FLET_WEB_HOST", "0.0.0.0")
    
    # Configuración de archivos
    UPLOAD_DIR: str = os.getenv("UPLOAD_DIR", "./uploads")
    MAX_FILE_SIZE: int = int(os.getenv("MAX_FILE_SIZE", "10485760"))  # 10MB por defecto
    
    class Config:
        env_file = ".env"
        case_sensitive = True


# Instancia global de configuración
_settings: Optional[Settings] = None


def get_settings() -> Settings:
    """Obtener instancia de configuración (singleton)"""
    global _settings
    if _settings is None:
        _settings = Settings()
    return _settings