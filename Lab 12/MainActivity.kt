package com.example.lab12

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import android.content.Context
import android.provider.Settings

class MainActivity: FlutterActivity() {
    private val CHANNEL = "lab12.company.com/deviceinfo"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            if (call.method == "getDeviceInfo") {
                val deviceInfo = getDeviceInfo()
                result.success(deviceInfo)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceInfo(): String {
        return """
Device: ${Build.DEVICE}
Manufacturer: ${Build.MANUFACTURER}
Model: ${Build.MODEL}
Product: ${Build.PRODUCT}
Brand: ${Build.BRAND}
Board: ${Build.BOARD}
Hardware: ${Build.HARDWARE}
Version Release: ${Build.VERSION.RELEASE}
Version SDK: ${Build.VERSION.SDK_INT}
Fingerprint: ${Build.FINGERPRINT}
Display: ${Build.DISPLAY}
ID: ${Build.ID}
Bootloader: ${Build.BOOTLOADER}
"""
    }
}