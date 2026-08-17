/// Modelos de una release de GitHub (fuente del updater).
///
/// La versión de la app se lee del tag de la release (ej. `v1.2.0`) y los
/// binarios son los assets `app-windows.zip` y `app-android.apk`.
library;

/// Información de la última release publicada en GitHub.
class AppUpdateInfo {
  const AppUpdateInfo({
    required this.version,
    required this.assets,
    required this.releasedAt,
  });

  final String version;
  final List<UpdateAsset> assets;
  final DateTime? releasedAt;

  /// Asset del binario para la plataforma dada (`windows`/`android`).
  UpdateAsset? assetFor(String assetName) {
    for (final a in assets) {
      if (a.name == assetName) return a;
    }
    return null;
  }

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) {
    final tag = json['tag_name'] as String? ?? '';
    final rawAssets = json['assets'] as List<dynamic>? ?? const [];
    final assets = rawAssets
        .whereType<Map<String, dynamic>>()
        .map(UpdateAsset.fromJson)
        .toList();
    return AppUpdateInfo(
      version: _normalizeVersion(tag),
      assets: assets,
      releasedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
    );
  }

  /// `v1.2.0` → `1.2.0` (quita el prefijo `v`).
  static String _normalizeVersion(String tag) =>
      tag.replaceFirst(RegExp(r'^v'), '');
}

/// Asset de descarga de una release.
class UpdateAsset {
  const UpdateAsset({required this.name, required this.url, required this.size});

  final String name;
  final String url;
  final int size;

  factory UpdateAsset.fromJson(Map<String, dynamic> json) => UpdateAsset(
        name: json['name'] as String? ?? '',
        url: json['browser_download_url'] as String? ?? '',
        size: (json['size'] as num?)?.toInt() ?? 0,
      );
}