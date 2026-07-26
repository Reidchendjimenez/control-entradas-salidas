#!/usr/bin/env python3
import sys, os
sys.path.insert(0, os.path.dirname(__file__))

from usr.init_db import reset_database

if __name__ == "__main__":
    confirmar = input("¿ESTÁS SEGURO? Se borrarán TODOS los datos en Supabase (s/n): ")
    if confirmar.lower() == 's':
        success = reset_database()
        exit(0 if success else 1)
    else:
        print("Operación cancelada.")
        exit(0)
