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

datas = [('assets', 'assets'), ('.env', '.')]
binaries = []
hiddenimports = ['sqlalchemy.dialects.postgresql', 'pg8000']

# Recolectar dependencias de Supabase y configuracion
for pkg in ('supabase', 'pydantic_settings'):
    d, b, h = collect_all(pkg)
    datas += d
    binaries += b
    hiddenimports += h

# Submodulos de sqlalchemy
hiddenimports += collect_submodules('sqlalchemy')

# --- 1) Analisis del modulo principal (Control de inventario) ---
control_a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=binaries,
    datas=list(datas),
    hiddenimports=list(hiddenimports),
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
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
    runtime_hooks=[],
    excludes=[],
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
    console=False
    icon='assets/icono.ico',
)

# --- Carpeta onedir compartida: ambos ejecutables viven en dist/Lycoris/ ---
coll = COLLECT(
    control_exe,
    control_a.binaries,
    control_a.datas,
    pos_exe,                       # segundo exe dentro de la misma carpeta
    name='Lycoris',
)
