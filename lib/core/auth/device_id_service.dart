import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Identificador único por dispositivo. Se genera una vez y se persiste
/// en SharedPreferences. Se usa para filtrar la tabla `dispositivo_usuario`
/// y que cada dispositivo tenga su propio operador.
class DeviceIdService {
  DeviceIdService._();
  static final instance = DeviceIdService._();

  static const _key = 'lycoris_device_id';
  String? _id;

  /// UUID único de este dispositivo.
  Future<String> get id async {
    if (_id != null) return _id!;
    final prefs = await SharedPreferences.getInstance();
    var stored = prefs.getString(_key);
    if (stored == null) {
      stored = const Uuid().v4();
      await prefs.setString(_key, stored);
    }
    _id = stored;
    return stored;
  }
}
