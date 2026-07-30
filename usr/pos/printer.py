"""
Impresion para NT-5890K (ESC/POS).
Auto-detecta por USB o permite configurar dispositivo.
Soporta Windows, Linux y macOS.
"""
import logging
import os
import platform

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

# Config key en pos_settings
_PRINTER_CONFIG_KEY = "printer_device"


def _get_configured_device():
    """Obtiene el dispositivo de impresora configurado por el usuario."""
    try:
        from usr.database.local_replica import LocalReplica
        return LocalReplica.get_pos_setting(_PRINTER_CONFIG_KEY)
    except Exception:
        return None


def _set_configured_device(device_path: str):
    """Guarda el dispositivo de impresora configurado."""
    try:
        from usr.database.local_replica import LocalReplica
        LocalReplica.set_pos_setting(_PRINTER_CONFIG_KEY, device_path)
    except Exception as e:
        logger.error(f"Error guardando config de impresora: {e}")


def _find_usb_printers():
    """Busca impresoras USB conocidas usando pyusb."""
    printers = []
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
                manufacturer = ""
                product = ""
                try:
                    manufacturer = usb.util.get_string(dev, dev.iManufacturer) or ""
                except Exception:
                    pass
                try:
                    product = usb.util.get_string(dev, dev.iProduct) or ""
                except Exception:
                    pass
                printers.append({
                    'type': 'usb',
                    'device': dev,
                    'vid': hex(vid),
                    'pid': hex(pid),
                    'name': f"{manufacturer} {product}".strip() or f"USB {hex(vid)}:{hex(pid)}",
                    'path': f"usb:{vid:04x}:{pid:04x}",
                })
        except Exception:
            pass
    return printers


def _find_serial_printers():
    """Busca impresoras en puertos seriales disponibles."""
    printers = []
    system = platform.system()

    if system == "Windows":
        import serial.tools.list_ports
        for port in serial.tools.list_ports.comports():
            printers.append({
                'type': 'serial',
                'device': port.device,
                'name': port.description or port.device,
                'path': port.device,
            })
    elif system == "Linux":
        for path in _DEVICE_PATHS:
            if os.path.exists(path):
                printers.append({
                    'type': 'file',
                    'device': path,
                    'name': f"Impresora LP {path}",
                    'path': path,
                })
        # Also check serial ports
        import glob
        for dev in sorted(glob.glob("/dev/ttyUSB*") + glob.glob("/dev/ttyACM*")):
            printers.append({
                'type': 'serial',
                'device': dev,
                'name': f"Puerto serial {dev}",
                'path': dev,
            })
    elif system == "Darwin":
        import glob
        for dev in sorted(glob.glob("/dev/cu*")):
            printers.append({
                'type': 'serial',
                'device': dev,
                'name': f"Puerto serial {dev}",
                'path': dev,
            })

    return printers


def listar_impresoras():
    """Lista todas las impresoras disponibles (USB + serial)."""
    printers = _find_usb_printers()
    printers.extend(_find_serial_printers())
    return printers


def _find_printer_device():
    """Busca la impresora usando la configuracion o auto-deteccion."""
    configured = _get_configured_device()
    if configured:
        if configured.startswith("usb:"):
            parts = configured.split(":")
            if len(parts) == 3:
                vid = int(parts[1], 16)
                pid = int(parts[2], 16)
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
        else:
            try:
                open(configured, 'wb').close()
                return configured
            except Exception:
                pass

    return _find_printer_device_auto()


def _find_printer_device_auto():
    """Auto-detecta la impresora por USB o device path."""
    usb_printers = _find_usb_printers()
    if usb_printers:
        return usb_printers[0]['device']

    for path in _DEVICE_PATHS:
        try:
            open(path, 'wb').close()
            return path
        except Exception:
            pass

    system = platform.system()
    if system == "Windows":
        try:
            import serial.tools.list_ports
            ports = list(serial.tools.list_ports.comports())
            if ports:
                return ports[0].device
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
    """Imprime una comanda en la impresora configurada o auto-detectada.
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


def test_imprimir() -> bool:
    """Imprime una pagina de prueba para verificar la impresora."""
    data = _escpos_ticket(
        [{'cantidad': 1, 'nombre': 'PRUEBA', 'precio': 0, 'contornos': []}],
        total=0.0
    )

    printer = _find_printer_device()
    if printer is None:
        return False

    try:
        if isinstance(printer, str):
            with open(printer, 'wb') as f:
                f.write(data)
        else:
            printer.write(1, data, timeout=5000)
        return True
    except Exception as e:
        logger.error(f"Error en test de impresion: {e}")
        return False


def configurar_impresora(device_path: str) -> bool:
    """Configura el dispositivo de impresora a usar."""
    _set_configured_device(device_path)
    return True
