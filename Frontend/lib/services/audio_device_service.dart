import 'package:flutter/services.dart';

/// Represents a single audio output device reported by the OS.
class AudioDevice {
  final String id;
  final String name;
  final AudioDeviceType type;

  const AudioDevice({
    required this.id,
    required this.name,
    required this.type,
  });
}

enum AudioDeviceType { earpiece, speaker, bluetooth, wired }

/// Fetches real connected audio output devices via a native MethodChannel.
class AudioDeviceService {
  static const _channel = MethodChannel('com.yatri/audio_devices');

  /// Requests Bluetooth connection permissions on Android 12+.
  /// Returns true if permission is already granted or not needed, false if requested.
  static Future<bool> requestBluetoothPermission() async {
    try {
      final bool granted = await _channel.invokeMethod('requestBluetoothPermission');
      return granted;
    } catch (_) {
      return true;
    }
  }

  /// Returns the list of currently connected audio output devices.
  /// Falls back to [earpiece, speaker] on any error.
  static Future<List<AudioDevice>> getOutputDevices() async {
    try {
      final List<dynamic> raw =
          await _channel.invokeMethod('getAudioOutputDevices');

      final devices = raw.map((item) {
        final map = Map<String, String>.from(item as Map);
        final type = _parseType(map['type'] ?? '');
        return AudioDevice(
          id: map['id'] ?? map['type'] ?? 'unknown',
          name: map['name'] ?? 'Unknown Device',
          type: type,
        );
      }).toList();

      // Sort the final list:
      // 1. Earpiece first
      // 2. Speaker second
      // 3. Connected devices (Bluetooth/Wired) below the speaker
      final List<AudioDevice> sorted = [];

      final earpiece = devices.firstWhere(
        (d) => d.type == AudioDeviceType.earpiece,
        orElse: () => const AudioDevice(id: 'earpiece', name: 'Earpiece', type: AudioDeviceType.earpiece),
      );
      sorted.add(earpiece);

      final speaker = devices.firstWhere(
        (d) => d.type == AudioDeviceType.speaker,
        orElse: () => const AudioDevice(id: 'speaker', name: 'Speaker', type: AudioDeviceType.speaker),
      );
      sorted.add(speaker);

      for (final d in devices) {
        if (d.type != AudioDeviceType.earpiece && d.type != AudioDeviceType.speaker) {
          sorted.add(d);
        }
      }

      return sorted;
    } catch (_) {
      // Fallback if channel fails (e.g. on desktop/web)
      return const [
        AudioDevice(id: 'earpiece', name: 'Earpiece', type: AudioDeviceType.earpiece),
        AudioDevice(id: 'speaker',  name: 'Speaker',  type: AudioDeviceType.speaker),
      ];
    }
  }

  static AudioDeviceType _parseType(String raw) {
    switch (raw) {
      case 'speaker':
        return AudioDeviceType.speaker;
      case 'bluetooth':
        return AudioDeviceType.bluetooth;
      case 'wired':
        return AudioDeviceType.wired;
      case 'earpiece':
      default:
        return AudioDeviceType.earpiece;
    }
  }
}
