"""Runtime hook para apps frozen (PyInstaller) de Flet.

Flet/desktop, al no localizar el paquete cliente 'flet_desktop', dispara un
fallback que termina llamando a la builtin ``exit``. En un ejecutable frozen
``exit``/``quit`` NO están definidas (solo existen en modo interactivo), por
lo que ocurre ``NameError: name 'exit' is not defined`` y el .exe se cierra.

Aquí definimos versiones seguras de ``exit``/``quit`` en ``builtins`` para que,
si el fallback de Flet se ejecuta, no crashee el proceso. La detección normal de
``flet_desktop`` (cuando el paquete se incluye via hooks) no necesita este guardia.
"""
import builtins
import os
import sys

if getattr(sys, "frozen", False):
    def _frozen_exit(code=0):
        # En vez de crashear, termina limpiamente la app.
        try:
            sys.exit(int(code or 0))
        except Exception:
            os._exit(int(code or 0) if isinstance(code, (int, float)) else 0)

    if not hasattr(builtins, "exit") or builtins.exit is _frozen_exit:
        builtins.exit = _frozen_exit
    if not hasattr(builtins, "quit"):
        builtins.quit = _frozen_exit
