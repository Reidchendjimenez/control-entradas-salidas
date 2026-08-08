# -*- mode: python ; coding: utf-8 -*-
# Compila DOS ejecutables (Lycoris_Control.exe y Lycoris_POS.exe) en una sola
# carpeta compartida dist/Lycoris/ para compartir app_updates/ y lycoris_local.db.
#
# Uso:
#   pyinstaller --noconfirm Lycoris.spec
#
# Despues de compilar, copia manualmente la carpeta app_updates/ y el icono
# dentro de dist/Lycoris/ (junto a los .exe) para las actualizaciones en vivo.

from PyInstaller.utils.hooks import collect_all, collect_submodules

datas = [('assets', 'assets'), ('assets_pos', 'assets_pos'), ('.env', '.')]
binaries = []
hiddenimports = ['sqlalchemy.dialects.postgresql', 'pg8000']

# Recolectar dependencias de configuracion (pydantic_settings SI se usa en config)
for pkg in ('pydantic_settings',):
    d, b, h = collect_all(pkg)
    datas += d
    binaries += b
    hiddenimports += h

# Submodulos de sqlalchemy
hiddenimports += collect_submodules('sqlalchemy')

# Librerias pesadas que NO se usan en la app: no empaquetarlas para que el
# .exe sea mas liviano y arranque mas rapido en Windows.
# IMPORTANTE: no excluir submodulos de la stdlib usados en cadena por flet/urllib
# (ej. email.message, http.cookiejar), porque rompen el arranque del cliente desktop.
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
