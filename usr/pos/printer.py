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

# Config keys en pos_settings
_PRINTER_CONFIG_KEY = "printer_device"
_COMANDA_HEADER_NOMBRE = "comanda_header_nombre"
_COMANDA_HEADER_RIF = "comanda_header_rif"
_COMANDA_HEADER_DIRECCION = "comanda_header_direccion"
_COMANDA_HEADER_TELEFONO = "comanda_header_telefono"
_COMANDA_CORRELATIVO = "comanda_correlativo"


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


def _get_comanda_header():
    """Obtiene la configuracion del membrete de comanda."""
    try:
        from usr.database.local_replica import LocalReplica
        return {
            'nombre': LocalReplica.get_pos_setting(_COMANDA_HEADER_NOMBRE, ''),
            'rif': LocalReplica.get_pos_setting(_COMANDA_HEADER_RIF, ''),
            'direccion': LocalReplica.get_pos_setting(_COMANDA_HEADER_DIRECCION, ''),
            'telefono': LocalReplica.get_pos_setting(_COMANDA_HEADER_TELEFONO, ''),
        }
    except Exception:
        return {'nombre': '', 'rif': '', 'direccion': '', 'telefono': ''}


def _get_next_correlativo() -> int:
    """Obtiene el siguiente numero de correlativo y lo incrementa."""
    try:
        from usr.database.local_replica import LocalReplica
        val = LocalReplica.get_pos_setting(_COMANDA_CORRELATIVO, '0')
        try:
            current = int(val)
        except ValueError:
            current = 0
        new_val = current + 1
        LocalReplica.set_pos_setting(_COMANDA_CORRELATIVO, str(new_val))
        return current
    except Exception:
        return 0


def set_comanda_header(nombre: str = '', rif: str = '', direccion: str = '', telefono: str = ''):
    """Guarda la configuracion del membrete."""
    try:
        from usr.database.local_replica import LocalReplica
        LocalReplica.set_pos_setting(_COMANDA_HEADER_NOMBRE, nombre)
        LocalReplica.set_pos_setting(_COMANDA_HEADER_RIF, rif)
        LocalReplica.set_pos_setting(_COMANDA_HEADER_DIRECCION, direccion)
        LocalReplica.set_pos_setting(_COMANDA_HEADER_TELEFONO, telefono)
    except Exception as e:
        logger.error(f"Error guardando membrete: {e}")


def set_correlativo_inicial(valor: int):
    """Establece el valor inicial del correlativo."""
    try:
        from usr.database.local_replica import LocalReplica
        LocalReplica.set_pos_setting(_COMANDA_CORRELATIVO, str(valor))
    except Exception as e:
        logger.error(f"Error guardando correlativo: {e}")


def get_correlativo_actual() -> int:
    """Lee el correlativo actual sin incrementarlo."""
    try:
        from usr.database.local_replica import LocalReplica
        val = LocalReplica.get_pos_setting(_COMANDA_CORRELATIVO, '0')
        try:
            return int(val)
        except ValueError:
            return 0
    except Exception:
        return 0


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
        try:
            import serial.tools.list_ports
            for port in serial.tools.list_ports.comports():
                printers.append({
                    'type': 'serial',
                    'device': port.device,
                    'name': port.description or port.device,
                    'path': port.device,
                })
        except ImportError:
            pass
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


def _find_windows_printers():
    """Busca impresoras instaladas en Windows usando win32print."""
    printers = []
    if platform.system() != "Windows":
        return printers
    try:
        import win32print
        for p in win32print.EnumPrinters(win32print.PRINTER_ENUM_LOCAL | win32print.PRINTER_ENUM_CONNECTIONS):
            name = p[2]
            printers.append({
                'type': 'windows',
                'device': name,
                'name': name,
                'path': f"windows:{name}",
            })
    except ImportError:
        pass
    except Exception:
        pass
    return printers


def listar_impresoras():
    """Lista todas las impresoras disponibles (USB + serial + Windows)."""
    printers = _find_usb_printers()
    printers.extend(_find_serial_printers())
    printers.extend(_find_windows_printers())
    return printers


def _find_printer_device():
    """Busca la impresora usando la configuracion o auto-deteccion.
    Retorna un dict con 'type' y 'device' (o string para compatibilidad)."""
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
                        return {'type': 'usb', 'device': dev}
                except Exception:
                    pass
        elif configured.startswith("windows:"):
            name = configured[len("windows:"):]
            return {'type': 'windows', 'device': name}
        else:
            try:
                open(configured, 'wb').close()
                return {'type': 'file', 'device': configured}
            except Exception:
                pass

    return _find_printer_device_auto()


def _find_printer_device_auto():
    """Auto-detecta la impresora por USB, device path, o Windows."""
    usb_printers = _find_usb_printers()
    if usb_printers:
        return {'type': 'usb', 'device': usb_printers[0]['device']}

    for path in _DEVICE_PATHS:
        try:
            open(path, 'wb').close()
            return {'type': 'file', 'device': path}
        except Exception:
            pass

    system = platform.system()
    if system == "Windows":
        # Try serial ports first
        try:
            import serial.tools.list_ports
            ports = list(serial.tools.list_ports.comports())
            if ports:
                return {'type': 'serial', 'device': ports[0].device}
        except Exception:
            pass
        # Then Windows printers
        win_printers = _find_windows_printers()
        if win_printers:
            return {'type': 'windows', 'device': win_printers[0]['device']}

    return None


def _escpos_ticket(lines: list, total: float = None, comanda_id: int = None) -> bytes:
    """Genera los bytes ESC/POS para un ticket de comanda."""
    from datetime import datetime
    cmd = b""

    # Inicializar
    cmd += b"\x1b\x40"

    # --- Membrete / Header ---
    header = _get_comanda_header()
    nombre_empresa = (header.get('nombre') or '').strip()
    rif = (header.get('rif') or '').strip()
    direccion = (header.get('direccion') or '').strip()
    telefono = (header.get('telefono') or '').strip()

    cmd += b"\x1b\x61\x01"  # centrar
    if nombre_empresa:
        cmd += b"\x1b\x21\x30"  # doble altura + doble ancho
        cmd += f"{nombre_empresa}\n".encode()
        cmd += b"\x1b\x21\x00"  # reset char size
    if rif:
        cmd += f"RIF: {rif}\n".encode()
    if direccion:
        cmd += f"{direccion}\n".encode()
    if telefono:
        cmd += f"Tel: {telefono}\n".encode()

    # Correlativo
    if comanda_id is not None:
        correlativo = _get_next_correlativo()
        cmd += b"\x1b\x45\x01"  # negrita
        cmd += f"Comanda Nro: {correlativo:05d}\n".encode()
        cmd += b"\x1b\x45\x00"  # negrita off

    cmd += b"\x1b\x61\x00"  # izquierda
    cmd += f"{datetime.now():%d/%m/%Y %H:%M}\n".encode()
    cmd += b"--------------------------------\n"
    cmd += b"\n"

    for item in lines:
        cant = item.get('cantidad', 1)
        nombre = item.get('nombre', '?')
        precio = float(item.get('precio', 0))
        contornos = item.get('contornos', [])

        # Negrita para cantidad + nombre
        cmd += b"\x1b\x45\x01"
        cmd += f"{cant}x ".encode()
        cmd += b"\x1b\x45\x00"
        cmd += f"{nombre}".encode()
        # Precio a la derecha
        cmd += b"\x1b\x61\x02"  # alinear derecha
        cmd += b"\x1b\x45\x01"
        cmd += f" ${precio:.2f}\n".encode()
        cmd += b"\x1b\x45\x00"
        cmd += b"\x1b\x61\x00"  # izquierda

        if contornos:
            for c in contornos:
                cmd += f"   + {c}\n".encode()

    cmd += b"--------------------------------\n"

    if total is not None:
        cmd += b"\x1b\x61\x02"  # derecha
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

    data = _escpos_ticket(lines, total, comanda_id)

    printer = _find_printer_device()
    if printer is None:
        logger.warning("No se encontro impresora termica")
        return False

    try:
        if printer['type'] == 'windows':
            import win32print
            handle = win32print.OpenPrinter(printer['device'])
            try:
                win32print.StartDocPrinter(handle, 1, ("Comanda", None, "RAW"))
                win32print.StartPagePrinter(handle)
                win32print.WritePrinter(handle, data)
                win32print.EndPagePrinter(handle)
            finally:
                win32print.EndDocPrinter(handle)
                win32print.ClosePrinter(handle)
        elif isinstance(printer['device'], str):
            with open(printer['device'], 'wb') as f:
                f.write(data)
        else:
            printer['device'].write(1, data, timeout=5000)
        logger.info(f"Comanda impresa (id={comanda_id})")
        return True
    except Exception as e:
        logger.error(f"Error imprimiendo: {e}")
        return False


def test_imprimir() -> bool:
    """Imprime una pagina de prueba para verificar la impresora."""
    data = _escpos_ticket(
        [{'cantidad': 2, 'nombre': 'PRUEBA DE IMPRESION', 'precio': 1.50, 'contornos': []}],
        total=3.0
    )

    printer = _find_printer_device()
    if printer is None:
        return False

    try:
        if printer['type'] == 'windows':
            import win32print
            handle = win32print.OpenPrinter(printer['device'])
            try:
                win32print.StartDocPrinter(handle, 1, ("Test", None, "RAW"))
                win32print.StartPagePrinter(handle)
                win32print.WritePrinter(handle, data)
                win32print.EndPagePrinter(handle)
            finally:
                win32print.EndDocPrinter(handle)
                win32print.ClosePrinter(handle)
        elif isinstance(printer['device'], str):
            with open(printer['device'], 'wb') as f:
                f.write(data)
        else:
            printer['device'].write(1, data, timeout=5000)
        return True
    except Exception as e:
        logger.error(f"Error en test de impresion: {e}")
        return False


def configurar_impresora(device_path: str) -> bool:
    """Configura el dispositivo de impresora a usar."""
    _set_configured_device(device_path)
    return True
