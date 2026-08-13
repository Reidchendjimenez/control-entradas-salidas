"""Valores de BD empaquetados para builds compilados (Windows exe / Android APK).

Es un módulo Python normal, así que SIEMPRE viaja dentro del bundle de
PyInstaller y del APK, incluso si el archivo `.env` (oculto / gitignored)
queda fuera del empaquetado.

Los valores por defecto coinciden con config/.env.example. El workflow de
Android sobreescribe este archivo desde GitHub Secrets en tiempo de build.
"""
import os

DB_TYPE = os.getenv("DB_TYPE", "postgresql")
DB_HOST = os.getenv("DB_HOST", "aws-1-us-east-2.pooler.supabase.com")
DB_PORT = os.getenv("DB_PORT", "6543")
DB_NAME = os.getenv("DB_NAME", "postgres")
DB_USER = os.getenv("DB_USER", "postgres.uyyyveojjvbxhuhbnype")
DB_PASSWORD = os.getenv("DB_PASSWORD", "Reidchendk.11")
SQLITE_PATH = os.getenv("SQLITE_PATH", "./control_entradas_salidas.db")
UPDATE_URL = os.getenv("UPDATE_URL", "https://raw.githubusercontent.com/reidchend/control-entradas-salidas/main/version.json")
