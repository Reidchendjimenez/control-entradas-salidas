package com.lycoris.control_entradas_salidas

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.content.pm.PackageInstaller
import android.util.Log
import io.flutter.Log

class PackageInstallerReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val status = intent.getIntExtra(
            PackageInstaller.EXTRA_STATUS,
            PackageInstaller.STATUS_FAILURE
        )
        Log.d(
            "LycorisUpdater",
            "Install status=$status action=${intent.action}"
        )
        if (status == PackageInstaller.STATUS_PENDING_USER_ACTION) {
            // Android pide confirmación del usuario (ACTION_CONFIRM_INSTALL).
            val confirm = intent.getParcelableExtra<Intent>(
                Intent.EXTRA_INTENT
            )
            if (confirm != null) {
                confirm.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(confirm)
            }
        }
    }
}