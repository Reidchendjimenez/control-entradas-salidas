package com.lycoris.control_entradas_salidas

import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageInstaller
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class MainActivity : FlutterActivity() {
    private var updateChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        updateChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "lycoris/updater"
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "installApk" -> {
                        val path = call.argument<String>("path")
                        if (path == null) {
                            result.error("NO_PATH", "Ruta del APK vacía", null)
                        } else {
                            installApk(File(path), result)
                        }
                    }
                    "canRequestUnknownSources" -> result.success(
                        canRequestUnknownSources()
                    )
                    "openUnknownSourcesSettings" -> {
                        openUnknownSourcesSettings()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun canRequestUnknownSources(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            packageManager.canRequestPackageInstalls()
        } else {
            true
        }
    }

    private fun openUnknownSourcesSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(
                Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                Uri.parse("package:$packageName")
            )
            startActivity(intent)
        }
    }

    /**
     * Instala el APK con PackageInstaller (sin ACTION_VIEW). Requiere
     * REQUEST_INSTALL_PACKAGES y (Android 8+) el permiso "Instalar apps
     * desconocidas" para esta app.
     */
    private fun installApk(apkFile: File, result: MethodChannel.Result) {
        if (!apkFile.exists()) {
            result.error("APK_MISSING", "No se encontró el APK", null)
            return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            !packageManager.canRequestPackageInstalls()
        ) {
            result.error(
                "UNKNOWN_SOURCES",
                "Habilita 'Instalar apps desconocidas' en la configuración",
                null
            )
            return
        }
        try {
            val installer = packageManager.packageInstaller
            val params = PackageInstaller.SessionParams(
                PackageInstaller.SessionParams.MODE_FULL_INSTALL
            )
            val sessionId = installer.createSession(params)
            val session = installer.openSession(sessionId)

            FileInputStream(apkFile).use { input ->
                session.openWrite("package", 0, -1).use { output ->
                    input.copyTo(output)
                    session.fsync(output)
                }
            }

            val pendingIntent = PendingIntent.getBroadcast(
                this,
                sessionId,
                Intent(this, PackageInstallerReceiver::class.java),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            session.commit(pendingIntent.intentSender)
            session.close()
            result.success(true)
        } catch (e: Exception) {
            Log.e("LycorisUpdater", "Error instalando APK", e)
            result.error("INSTALL_FAILED", e.message ?: "Error instalando", null)
        }
    }
}