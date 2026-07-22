package com.yatri.yatri_driver_dashboard

import android.Manifest
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.yatri/audio_devices"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAudioOutputDevices" -> result.success(getAudioOutputDevices())
                    "requestBluetoothPermission" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                            if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT)
                                != PackageManager.PERMISSION_GRANTED) {
                                requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_CONNECT), 101)
                                result.success(false)
                            } else {
                                result.success(true)
                            }
                        } else {
                            result.success(true)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getAudioOutputDevices(): List<Map<String, String>> {
        val devices = mutableListOf<Map<String, String>>()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val outputDevices = audioManager.getDevices(AudioManager.GET_DEVICES_OUTPUTS)

            for (device in outputDevices) {
                // Determine the category; skip unrecognised device types
                val type: String = when (device.type) {
                    AudioDeviceInfo.TYPE_BUILTIN_EARPIECE -> "earpiece"
                    AudioDeviceInfo.TYPE_BUILTIN_SPEAKER  -> "speaker"
                    AudioDeviceInfo.TYPE_BLUETOOTH_A2DP,
                    AudioDeviceInfo.TYPE_BLUETOOTH_SCO    -> "bluetooth"
                    AudioDeviceInfo.TYPE_WIRED_HEADPHONES,
                    AudioDeviceInfo.TYPE_WIRED_HEADSET    -> "wired"
                    AudioDeviceInfo.TYPE_USB_HEADSET,
                    AudioDeviceInfo.TYPE_USB_DEVICE       -> "wired"
                    else -> null  // unknown — skip below
                } ?: continue   // <-- safe: null-check then continue in the for-loop

                // For internal devices (earpiece/speaker), always force clean names.
                // For external devices (bluetooth/wired), use their product name.
                val name = when (type) {
                    "earpiece" -> "Earpiece"
                    "speaker"  -> "Speaker"
                    else -> {
                        val rawName = device.productName?.toString()?.trim()
                        if (!rawName.isNullOrBlank() && rawName.lowercase() != "unknown") {
                            rawName
                        } else {
                            defaultLabel(type)
                        }
                    }
                }

                devices.add(mapOf("id" to device.id.toString(), "name" to name, "type" to type))
            }
        }

        // ── Ensure earpiece + speaker are in devices list before deduplication ──
        if (devices.none { it["type"] == "earpiece" }) {
            devices.add(0, mapOf("id" to "earpiece", "name" to "Earpiece", "type" to "earpiece"))
        }
        if (devices.none { it["type"] == "speaker" }) {
            devices.add(mapOf("id" to "speaker", "name" to "Speaker", "type" to "speaker"))
        }

        // ── Deduplicate the final list by type (for earpiece/speaker) and name (for bluetooth/wired) ──
        val uniqueDevices = mutableListOf<Map<String, String>>()
        val addedTypes = mutableSetOf<String>()
        val addedNames = mutableSetOf<String>()

        for (d in devices) {
            val type = d["type"] ?: continue
            val name = d["name"] ?: continue
            if (type == "bluetooth" || type == "wired") {
                if (!addedNames.contains(name)) {
                    uniqueDevices.add(d)
                    addedNames.add(name)
                }
            } else {
                if (!addedTypes.contains(type)) {
                    uniqueDevices.add(d)
                    addedTypes.add(type)
                }
            }
        }

        return uniqueDevices
    }

    private fun defaultLabel(type: String) = when (type) {
        "earpiece"  -> "Earpiece"
        "speaker"   -> "Speaker"
        "bluetooth" -> "Bluetooth Device"
        "wired"     -> "Wired Headphones"
        else        -> "Audio Device"
    }
}
