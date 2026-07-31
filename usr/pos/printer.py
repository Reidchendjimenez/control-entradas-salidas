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
_COMANDA_PIE_PAGINA = "comanda_pie_pagina"
_COMANDA_HEADER_SIZE = "comanda_header_size"
_COMANDA_QR_PATH = "comanda_qr_path"


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


def _get_pie_pagina() -> str:
    """Obtiene el texto del pie de pagina del ticket."""
    try:
        from usr.database.local_replica import LocalReplica
        return LocalReplica.get_pos_setting(_COMANDA_PIE_PAGINA, '') or ''
    except Exception:
        return ''


def set_pie_pagina(texto: str):
    """Guarda el texto del pie de pagina del ticket."""
    try:
        from usr.database.local_replica import LocalReplica
        LocalReplica.set_pos_setting(_COMANDA_PIE_PAGINA, texto)
    except Exception as e:
        logger.error(f"Error guardando pie de pagina: {e}")


def _get_qr_path() -> str:
    """Obtiene la ruta de la imagen QR para el ticket."""
    try:
        from usr.database.local_replica import LocalReplica
        return LocalReplica.get_pos_setting(_COMANDA_QR_PATH, '') or ''
    except Exception:
        return ''


def set_qr_path(path: str):
    """Guarda la ruta de la imagen QR para el ticket."""
    try:
        from usr.database.local_replica import LocalReplica
        LocalReplica.set_pos_setting(_COMANDA_QR_PATH, path)
    except Exception as e:
        logger.error(f"Error guardando ruta QR: {e}")


def _get_header_size() -> str:
    """Obtiene el tamaño del membrete: 'small', 'normal', 'large'."""
    try:
        from usr.database.local_replica import LocalReplica
        val = LocalReplica.get_pos_setting(_COMANDA_HEADER_SIZE, 'large')
        return val if val in ('small', 'normal', 'large') else 'large'
    except Exception:
        return 'large'


def set_header_size(size: str):
    """Guarda el tamaño del membrete: 'small', 'normal', 'large'."""
    if size not in ('small', 'normal', 'large'):
        size = 'large'
    try:
        from usr.database.local_replica import LocalReplica
        LocalReplica.set_pos_setting(_COMANDA_HEADER_SIZE, size)
    except Exception as e:
        logger.error(f"Error guardando tamano del membrete: {e}")


def _append_image(cmd: bytes, image_path: str, max_width: int = 384) -> bytes:
    """Agrega comandos ESC/POS para imprimir una imagen.
    Retorna los bytes actualizados. Si falla, retorna cmd sin cambios."""
    try:
        from PIL import Image
        img = Image.open(image_path)
        if img.mode == 'RGBA':
            bg = Image.new('RGB', img.size, (255, 255, 255))
            bg.paste(img, mask=img.split()[3])
            img = bg
        if img.mode != '1':
            img = img.convert('1', dither=Image.NONE)
        w, h = img.size
        if w > max_width:
            ratio = max_width / w
            w = max_width
            h = int(h * ratio)
            img = img.resize((w, h), Image.LANCZOS)
        cmd = _append_raster(cmd, img)
    except Exception as e:
        logger.error(f"Error agregando imagen al ticket: {e}")
    return cmd


def _append_raster(cmd: bytes, img) -> bytes:
    """Agrega comandos ESC/POS raster (GS v 0) para una imagen PIL en modo '1'.
    Retorna cmd actualizado."""
    w, h = img.size
    row_bytes = (w + 7) // 8
    xL = row_bytes & 0xFF
    xH = (row_bytes >> 8) & 0xFF
    yL = h & 0xFF
    yH = (h >> 8) & 0xFF
    cmd += b"\x1d\x76\x30\x00"
    cmd += bytes([xL, xH, yL, yH])
    for y in range(h):
        row = b""
        for x in range(0, w, 8):
            byte_val = 0
            for bit in range(8):
                if x + bit < w:
                    pixel = img.getpixel((x + bit, y))
                    if pixel == 0:
                        byte_val |= (1 << (7 - bit))
            row += bytes([byte_val])
        cmd += row
    return cmd


def _load_footer_font(size: int):
    """Carga una fuente para el pie de pagina. Intenta varias fuentes de
    Windows y Linux; como ultimo recurso usa la fuente escalable de Pillow."""
    try:
        from PIL import ImageFont
        for name in ("DejaVuSansMono.ttf", "DejaVuSans.ttf",
                     "arial.ttf", "consola.ttf", "cour.ttf",
                     "segoeui.ttf", "tahoma.ttf"):
            try:
                return ImageFont.truetype(name, size)
            except Exception:
                continue
        try:
            return ImageFont.truetype("C:/Windows/Fonts/arial.ttf", size)
        except Exception:
            pass
        try:
            return ImageFont.load_default(size)
        except Exception:
            return ImageFont.load_default()
    except Exception:
        from PIL import ImageFont
        return ImageFont.load_default()


def _append_footer(cmd: bytes) -> bytes:
    """Renderiza texto del pie de pagina + QR lado a lado como una sola imagen raster.
    Si no hay QR asignado, dibuja un recuadro placeholder donde ira el QR.
    Si no hay ni texto ni QR, retorna cmd sin cambios."""
    pie = _get_pie_pagina()
    qr_path = _get_qr_path()
    if not pie and not qr_path:
        return cmd
    try:
        from PIL import Image, ImageDraw
        import os

        # Cargar QR
        qr_img = None
        qr_max = 160
        if qr_path and os.path.exists(qr_path):
            qr_img = Image.open(qr_path)
            if qr_img.mode == 'RGBA':
                bg = Image.new('RGB', qr_img.size, (255, 255, 255))
                bg.paste(qr_img, mask=qr_img.split()[3])
                qr_img = bg
            qr_img = qr_img.convert('1', dither=Image.NONE)
            if qr_img.width > qr_max:
                r = qr_max / qr_img.width
                qr_w = qr_max
                qr_h = int(qr_img.height * r)
                qr_img = qr_img.resize((qr_w, qr_h), Image.LANCZOS)
            else:
                qr_w, qr_h = qr_img.size
        else:
            # Recuadro placeholder donde ira el QR
            qr_w = qr_h = 140

        # Preparar texto: envolver lineas que no quepan al lado del QR
        lines = pie.split('\n') if pie else []
        font_size = 24
        font = _load_footer_font(font_size)
        margin = 8
        spacing = 16
        avail_w = 384 - spacing - qr_w - margin * 3
        if avail_w < 60:
            avail_w = 60
        wrapped = []
        for line in lines:
            if not line:
                wrapped.append(line)
                continue
            if font.getbbox(line)[2] - font.getbbox(line)[0] <= avail_w:
                wrapped.append(line)
            else:
                words = line.split(' ')
                cur = ''
                for wrd in words:
                    test = (cur + ' ' + wrd).strip()
                    if font.getbbox(test)[2] - font.getbbox(test)[0] <= avail_w:
                        cur = test
                    else:
                        if cur:
                            wrapped.append(cur)
                        cur = wrd
                if cur:
                    wrapped.append(cur)
        lines = wrapped

        line_h = int(font_size * 1.3)
        text_w = 0
        for line in lines:
            bbox = font.getbbox(line)
            text_w = max(text_w, bbox[2] - bbox[0])
        text_h = len(lines) * line_h + margin * 2

        # Dimensiones del composite
        total_w = text_w + spacing + qr_w + margin * 3
        composite_h = max(text_h, qr_h) + margin * 2

        # Limitar al ancho maximo de impresion
        max_w = 384
        if total_w > max_w:
            scale = max_w / total_w
            total_w = max_w
            text_w = int(text_w * scale)
            qr_w = int(qr_w * scale)
            qr_h = int(qr_h * scale)
            if qr_img:
                qr_img = qr_img.resize((qr_w, qr_h), Image.LANCZOS)
            font_size = max(10, int(font_size * scale))
            font = _load_footer_font(font_size)
            line_h = int(font_size * 1.3)
            text_h = len(lines) * line_h + margin * 2

        composite = Image.new('1', (total_w, composite_h), 255)
        draw = ImageDraw.Draw(composite)

        # Texto a la izquierda
        y = (composite_h - text_h) // 2
        for line in lines:
            draw.text((margin, y), line, font=font, fill=0)
            y += line_h

        # QR a la derecha (o recuadro placeholder)
        qr_x = total_w - qr_w - margin
        qr_y = (composite_h - qr_h) // 2
        if qr_img:
            composite.paste(qr_img, (qr_x, qr_y))
        else:
            draw.rectangle([qr_x, qr_y, qr_x + qr_w - 1, qr_y + qr_h - 1], outline=0, width=2)
            placeholder_font = _load_footer_font(max(12, int(qr_h * 0.18)))
            qr_label = "QR"
            bbox = draw.textbbox((0, 0), qr_label, font=placeholder_font)
            tw = bbox[2] - bbox[0]
            th = bbox[3] - bbox[1]
            draw.text((qr_x + (qr_w - tw) // 2 - bbox[0],
                       qr_y + (qr_h - th) // 2 - bbox[1]),
                      qr_label, font=placeholder_font, fill=0)

        cmd = _append_raster(cmd, composite)
    except Exception as e:
        logger.error(f"Error renderizando footer compuesto: {e}")
    return cmd


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


def _get_usb_out_endpoint(dev):
    """Obtiene el endpoint bulk OUT correcto del dispositivo USB."""
    try:
        import usb.util
        for cfg in dev:
            for intf in cfg:
                for ep in intf:
                    if (usb.util.endpoint_direction(ep.bEndpointAddress) == usb.util.ENDPOINT_OUT
                            and usb.util.endpoint_type(ep.bmAttributes) == usb.util.ENDPOINT_TYPE_BULK):
                        return ep.bEndpointAddress
    except Exception:
        pass
    return 0x01  # fallback al endpoint comun


def _write_data(printer: dict, data: bytes) -> bool:
    """Escribe los bytes de impresion al dispositivo con reintentos y reset previo.
    Retorna True si la impresion fue enviada."""
    ptype = printer['type']
    device = printer['device']

    for attempt in range(2):
        try:
            if ptype == 'windows':
                import win32print
                handle = win32print.OpenPrinter(device)
                try:
                    win32print.StartDocPrinter(handle, 1, ("Comanda", None, "RAW"))
                    win32print.StartPagePrinter(handle)
                    win32print.WritePrinter(handle, b"\x1b\x40" + data)
                    win32print.EndPagePrinter(handle)
                finally:
                    win32print.EndDocPrinter(handle)
                    win32print.ClosePrinter(handle)
                return True

            elif isinstance(device, str):
                # file / serial
                with open(device, 'wb') as f:
                    f.write(b"\x1b\x40" + data)
                    f.flush()
                return True

            else:
                # USB (pyusb)
                import usb.util
                out_ep = _get_usb_out_endpoint(device)
                try:
                    if device.is_kernel_driver_active(0):
                        device.detach_kernel_driver(0)
                except Exception:
                    pass
                try:
                    device.set_configuration()
                except Exception:
                    pass
                try:
                    device.write(out_ep, b"\x1b\x40" + data, timeout=10000)
                except Exception:
                    # intentar re-claim del interface
                    try:
                        usb.util.claim_interface(device, 0)
                        device.write(out_ep, b"\x1b\x40" + data, timeout=10000)
                    finally:
                        try:
                            usb.util.release_interface(device, 0)
                        except Exception:
                            pass
                return True
        except Exception as e:
            logger.error(f"Error escribiendo a impresora (intento {attempt+1}): {e}")
            if attempt == 0:
                try:
                    import time
                    time.sleep(0.5)
                except Exception:
                    pass

    # Ultimo recurso en Windows: si el USB falla, usar la cola de impresion
    if ptype != 'windows' and platform.system() == "Windows":
        try:
            win_printers = _find_windows_printers()
            if win_printers:
                logger.warning(f"USB fallo, reintentando via Windows: {win_printers[0]['device']}")
                return _write_data({'type': 'windows', 'device': win_printers[0]['device']}, data)
        except Exception as e:
            logger.error(f"Fallback Windows fallo: {e}")
    return False


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
    system = platform.system()

    # En Windows, preferir la cola de impresion (win32print):
    # la impresora instalada ya tiene el driver que reclama el USB,
    # asi que escribir por pyusb falla o produce salida corrupta.
    if system == "Windows":
        win_printers = _find_windows_printers()
        if win_printers:
            return {'type': 'windows', 'device': win_printers[0]['device']}

    usb_printers = _find_usb_printers()
    if usb_printers:
        return {'type': 'usb', 'device': usb_printers[0]['device']}

    for path in _DEVICE_PATHS:
        try:
            open(path, 'wb').close()
            return {'type': 'file', 'device': path}
        except Exception:
            pass

    if system == "Windows":
        # Try serial ports as last resort
        try:
            import serial.tools.list_ports
            ports = list(serial.tools.list_ports.comports())
            if ports:
                return {'type': 'serial', 'device': ports[0].device}
        except Exception:
            pass

    return None


def _escpos_ticket(lines: list, total: float = None, comanda_id: int = None, include_footer: bool = True,
                   correlativo: int = None, correccion_de: int = None, tasa: float = None) -> bytes:
    """Genera los bytes ESC/POS para un ticket de comanda.
    Si correlativo es None se asigna el siguiente automaticamente.
    correccion_de: correlativo de la venta anulada que este ticket corrige.
    tasa: tasa de cambio Bs por USD, para imprimir el total en bolivares."""
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
    header_size = _get_header_size()

    cmd += b"\x1b\x61\x01"  # centrar
    if header_size == 'small':
        cmd += b"\x1b\x21\x01"  # font B (condensado)
    elif header_size == 'normal':
        cmd += b"\x1b\x21\x00"  # normal
    if nombre_empresa:
        if header_size == 'large':
            cmd += b"\x1b\x21\x30"  # doble altura + doble ancho
        cmd += f"{nombre_empresa}\n".encode()
        cmd += b"\x1b\x21\x00"  # reset char size
    if header_size == 'small':
        cmd += b"\x1b\x21\x01"
    if rif:
        cmd += f"RIF: {rif}\n".encode()
    if direccion:
        cmd += f"{direccion}\n".encode()
    if telefono:
        cmd += f"Tel: {telefono}\n".encode()
    if header_size == 'small':
        cmd += b"\x1b\x21\x00"

    # Correlativo
    if comanda_id is not None:
        if correlativo is None:
            correlativo = _get_next_correlativo()
        cmd += b"\x1b\x45\x01"  # negrita
        cmd += f"Comanda Nro: {correlativo:05d}\n".encode()
        cmd += b"\x1b\x45\x00"  # negrita off
        if correccion_de is not None:
            cmd += b"\x1b\x45\x01"  # negrita
            cmd += f"* CORRECCION DE COMANDA {correccion_de:05d} *\n".encode()
            cmd += b"\x1b\x45\x00"  # negrita off

    cmd += b"\x1b\x61\x00"  # izquierda
    cmd += f"{datetime.now():%d/%m/%Y %H:%M}\n".encode()
    cmd += b"--------------------------------\n"
    cmd += b"\n"

    cols = 32
    for item in lines:
        cant = item.get('cantidad', 1)
        nombre = item.get('nombre', '?')
        precio = float(item.get('precio', 0))
        contornos = item.get('contornos', [])

        # Nombre alineado a la izquierda y precio a la derecha,
        # rellenando con espacios (ESC/POS no alinea partes de una linea)
        cant_str = f"{cant:g}x "
        precio_str = f"${precio:.2f}"
        nombre = nombre[:cols - len(precio_str) - 1 - len(cant_str)]
        izquierda = cant_str + nombre
        relleno = cols - len(izquierda) - len(precio_str)

        cmd += b"\x1b\x45\x01"
        cmd += cant_str.encode()
        cmd += b"\x1b\x45\x00"
        cmd += nombre.encode()
        cmd += b" " * relleno
        cmd += b"\x1b\x45\x01"
        cmd += precio_str.encode()
        cmd += b"\x1b\x45\x00\n"

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

    if total is not None and tasa:
        from usr.pos.tasa_cambio import convertir, formatear_bs, formatear_tasa
        cmd += b"\x1b\x61\x02"  # derecha
        cmd += f"Tasa: {formatear_tasa(tasa)} Bs/$\n".encode()
        cmd += b"\x1b\x45\x01"
        cmd += f"TOTAL Bs: {formatear_bs(convertir(total, tasa))}\n".encode()
        cmd += b"\x1b\x45\x00"
        cmd += b"\x1b\x61\x00"

    # --- Pie de pagina + QR (lado a lado como imagen raster) ---
    if include_footer:
        cmd = _append_footer(cmd)

    cmd += b"\n"
    cmd += b"\x1b\x64\x04"  # Avanzar 4 lineas
    cmd += b"\x1d\x56\x00"  # Corte parcial
    return cmd


def imprimir_comanda(items: list, total: float = None, comanda_id: int = None,
                     correlativo: int = None, correccion_de: int = None,
                     tasa: float = None) -> bool:
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

    data = _escpos_ticket(lines, total, comanda_id, correlativo=correlativo,
                          correccion_de=correccion_de, tasa=tasa)

    printer = _find_printer_device()
    if printer is None:
        logger.warning("No se encontro impresora termica")
        return False

    if _write_data(printer, data):
        logger.info(f"Comanda impresa (id={comanda_id})")
        return True
    return False


def test_imprimir(include_footer: bool = True) -> bool:
    """Imprime una pagina de prueba para verificar la impresora.
    Si include_footer es False, omite el pie de pagina + QR (raster)
    para aislar problemas de compatibilidad del modo raster."""
    data = _escpos_ticket(
        [{'cantidad': 2, 'nombre': 'PRUEBA DE IMPRESION', 'precio': 1.50, 'contornos': []}],
        total=3.0,
        include_footer=include_footer,
    )

    printer = _find_printer_device()
    if printer is None:
        return False

    if _write_data(printer, data):
        return True
    return False


def configurar_impresora(device_path: str) -> bool:
    """Configura el dispositivo de impresora a usar."""
    _set_configured_device(device_path)
    return True
