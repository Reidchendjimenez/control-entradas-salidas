"""
Impresion para NT-5890K (ESC/POS).
Auto-detecta por USB o permite configurar dispositivo.
"""
import logging

logger = logging.getLogger(__name__)

# Posibles VID:PID de la NT-5890K y termicas compatibles
_KNOWN_VID_PID = [
    (0x0416, 0x5011),  # Bixolon / NT-5890K
    (0x1a86, 0x7584),  # QinHeng CH340
    (0x0483, 0x5743),  # STM32
    (0x28e9, 0x0289),  # 58mm thermal
    (0x0fe6, 0x811e),  # 80mm thermal
]

_DEVICE_PATHS = [
    "/dev/usb/lp0", "/dev/usb/lp1",
    "/dev/lp0", "/dev/lp1",
]


def _find_printer_device():
    """Busca la impresora por USB o device path."""
    for vid, pid in _KNOWN_VID_PID:
        try:
            import usb.core
            dev = usb.core.find(idVendor=vid, idProduct=pid)
            if dev:
                try:
                    if dev.is_kernel_driver_active(0):
                        dev.detach_kernel_driver(0)
                except Exception:
                    pass
                try:
                    dev.set_configuration()
                except Exception:
                    pass
                return dev
        except Exception:
            pass

    for path in _DEVICE_PATHS:
        try:
            open(path, 'wb').close()
            return path
        except Exception:
            pass
    return None


def _escpos_ticket(lines: list, total: float = None) -> bytes:
    """Genera los bytes ESC/POS para un ticket de comanda."""
    from datetime import datetime
    cmd = b""

    # Inicializar
    cmd += b"\x1b\x40"

    # Centro: restaurante
    cmd += b"\x1b\x61\x01"
    cmd += b"CONTROL DE COMANDAS\n"
    cmd += b"\x1b\x61\x00"
    cmd += f"{datetime.now():%d/%m/%Y %H:%M}\n".encode()
    cmd += b"--------------------------------\n"
    cmd += b"\n"

    for item in lines:
        cant = item.get('cantidad', 1)
        nombre = item.get('nombre', '?')
        precio = item.get('precio', 0)
        contornos = item.get('contornos', [])

        # Negrita para cantidad + nombre
        cmd += b"\x1b\x45\x01"
        cmd += f"{cant}x ".encode()
        cmd += b"\x1b\x45\x00"
        cmd += f"{nombre}\n".encode()

        if contornos:
            for c in contornos:
                cmd += f"   + {c}\n".encode()

    cmd += b"--------------------------------\n"

    if total is not None:
        cmd += b"\x1b\x61\x01"
        cmd += b"\x1b\x45\x01"
        cmd += f"TOTAL: ${total:.2f}\n".encode()
        cmd += b"\x1b\x45\x00"
        cmd += b"\x1b\x61\x00"

    cmd += b"\n"
    cmd += b"\x1b\x64\x04"  # Avanzar 4 lineas
    cmd += b"\x1d\x56\x00"  # Corte parcial
    return cmd


def imprimir_comanda(items: list, total: float = None, comanda_id: int = None) -> bool:
    """Imprime una comanda en la NT-5890K.
    Retorna True si se imprimio, False si no hay impresora."""
    lines = []
    for item in items:
        entry = {
            'cantidad': item.get('cantidad', 1),
            'nombre': item.get('nombre', '?'),
            'precio': item.get('precio', 0),
            'contornos': item.get('contornos', []),
        }
        lines.append(entry)

    data = _escpos_ticket(lines, total)

    printer = _find_printer_device()
    if printer is None:
        logger.warning("No se encontro impresora termica")
        return False

    try:
        if isinstance(printer, str):
            with open(printer, 'wb') as f:
                f.write(data)
        else:
            printer.write(1, data, timeout=5000)
        logger.info(f"Comanda impresa (id={comanda_id})")
        return True
    except Exception as e:
        logger.error(f"Error imprimiendo: {e}")
        return False
