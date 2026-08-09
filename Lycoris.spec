# -*- mode: python ; coding: utf-8 -*-
# Compila DOS ejecutables (Lycoris_Control.exe y Lycoris_POS.exe) en una sola
# carpeta compartida dist/Lycoris/ para compartir app_updates/ y lycoris_local.db.
#
# Uso:
#   pyinstaller --noconfirm Lycoris.spec
#
# Despues de compilar, copia manualmente la carpeta app_updates/ y el icono
# dentro de dist/Lycoris/ (junto a los .exe) para las actualizaciones en vivo.
#
# Flet 0.86+ changes:
# - lazy imports via __getattr__ -> collect_submodules('flet') para descubrir todo
# - dart_bridge FFI transport incluido via serious_python (no excluir)
# - certifi cacert.pem via collect_data_files
# - Python 3.12 pin (requires-python en pyproject.toml)

from PyInstaller.utils.hooks import collect_all, collect_submodules, collect_data_files

# Datos base: assets, .env, db_config.py (fallback credenciales)
datas = [
    ('assets', 'assets'),
    ('assets_pos', 'assets_pos'),
    ('.env', '.'),
    ('config/db_config.py', 'config'),
]
binaries = []
hiddenimports = [
    'sqlalchemy.dialects.postgresql',
    'pg8000',
    'config.db_config',
]

# Recolectar TODOS los submodulos de flet (0.86 usa lazy __getattr__)
hiddenimports += collect_submodules('flet')

# Recolectar dependencias de configuracion (pydantic_settings SI se usa en config)
for pkg in ('pydantic_settings', 'certifi'):
    d, b, h = collect_all(pkg)
    datas += d
    binaries += b
    hiddenimports += h

# Submodulos de sqlalchemy
hiddenimports += collect_submodules('sqlalchemy')

# Asegurar modulos de flet que se usan dinamicamente (charts, auth, etc.)
# collect_submodules ya los cubre, pero forzamos algunos criticos:
hiddenimports += [
    'flet.auth',
    'flet.components',
    'flet.cupertino',
    'flet.routing',
    'flet.matplotlib_chart',
    'flet.map',
    'flet.video',
    'flet.webview',
    'flet.security',
    'flet.pubsub',
    'flet.drag_drop',
    'flet.canvas',
    'flet.charts',
    'flet.fastapi',
]

# Librerias pesadas que NO se usan en la app: no empaquetarlas para que el
# .exe sea mas liviano y arranque mas rapido en Windows.
# IMPORTANTE: no excluir submodulos de la stdlib usados en cadena por flet/urllib
# (ej. email.message, http.cookiejar), porque rompen el arranque del cliente desktop.
# Tampoco excluir 'serious_python', 'dart_bridge', '_multiprocessing' (Flet 0.86 los usa).
_excludes = [
    'tkinter', 'matplotlib', 'numpy', 'pandas', 'scipy',
    'unittest', 'pydoc', 'test',
]

# --- 1) Analisis del modulo principal (Control de inventario) ---
control_a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=binaries,
    datas=list(datas),
    hiddenimports=list(hiddenimports),
    hookspath=[],
    runtime_hooks=['_frozen_runtime_hook.py'],
    excludes=list(_excludes),
    noarchive=False,
)

control_pyz = PYZ(control_a.pure)

control_exe = EXE(
    control_pyz,
    control_a.scripts,
    control_a.binaries,
    control_a.zipfiles,
    control_a.datas,
    [],
    name='Lycoris_Control',
    console=False,
    icon='assets/icono.ico',
)

# --- 2) Analisis del modulo POS (Ventas) ---
pos_a = Analysis(
    ['main_pos.py'],
    pathex=[],
    binaries=binaries,
    datas=list(datas),
    hiddenimports=list(hiddenimports),
    hookspath=[],
    runtime_hooks=['_frozen_runtime_hook.py'],
    excludes=list(_excludes),
    noarchive=False,
)

pos_pyz = PYZ(pos_a.pure)

pos_exe = EXE(
    pos_pyz,
    pos_a.scripts,
    pos_a.binaries,
    pos_a.zipfiles,
    pos_a.datas,
    [],
    name='Lycoris_POS',
    console=False,
    icon='assets/icono_azul.ico',
)

# --- Carpeta onedir compartida: ambos ejecutables viven en dist/Lycoris/ ---
coll = COLLECT(
    control_exe,
    control_a.binaries,
    control_a.datas,
    pos_exe,                       # segundo exe dentro de la misma carpeta
    name='Lycoris',
)