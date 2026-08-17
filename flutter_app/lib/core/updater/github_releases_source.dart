import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'update_models.dart';

/// Consulta la última release de GitHub (equivalente a `usr/updater.py`).
class GitHubReleasesSource {
  GitHubReleasesSource({String? repo, http.Client? client})
      : _repo = repo ?? 'reidchend/control-entradas-salidas',
        _client = client ?? http.Client();

  final String _repo;
  final http.Client _client;

  /// Endpoint público sin auth (60 req/h por IP): releases/latest.
  Uri get _latestUrl =>
      Uri.parse('https://api.github.com/repos/$_repo/releases/latest');

  /// Última release publicada. Lanza si no hay release o falla la red.
  Future<AppUpdateInfo> fetchLatest() async {
    final res = await _client
        .get(_latestUrl, headers: {'User-Agent': 'Lycoris-App'})
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) {
      throw Exception('GitHub respondió ${res.statusCode}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return AppUpdateInfo.fromJson(json);
  }

  /// Compara la versión local con la remota. `null` = sin actualización.
  Future<String?> checkForUpdate(String localVersion) async {
    final remote = await fetchLatest();
    if (localVersion == remote.version) return null;
    if (_compareVersions(remote.version, localVersion) <= 0) return null;
    return remote.version;
  }

  /// Comparación semver simple (`1.2.0` vs `1.2.3`). Devuelve negativo si
  /// a < b, 0 si iguales, positivo si a > b.
  int _compareVersions(String a, String b) {
    final pa = _parse(a);
    final pb = _parse(b);
    for (var i = 0; i < 3; i++) {
      if (pa[i] != pb[i]) return pa[i] - pb[i];
    }
    return 0;
  }

  List<int> _parse(String v) {
    final parts = v.split('.');
    return [
      int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0,
      int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0,
      int.tryParse(parts.length > 2 ? parts[2] : '') ?? 0,
    ];
  }
}

/// Fábrica con URL configurable (AppConfig.updateUrl) y valores por defecto.
GitHubReleasesSource createGitHubReleasesSource() =>
    GitHubReleasesSource(repo: AppConfig.updateRepo);