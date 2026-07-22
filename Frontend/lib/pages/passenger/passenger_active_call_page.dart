import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/audio_device_service.dart';

extension _AudioDeviceX on AudioDevice {
  IconData get icon {
    switch (type) {
      case AudioDeviceType.earpiece:
        return Icons.phone_in_talk_rounded;
      case AudioDeviceType.speaker:
        return Icons.speaker_phone_rounded;
      case AudioDeviceType.bluetooth:
        return Icons.headset_rounded;
      case AudioDeviceType.wired:
        return Icons.headphones_rounded;
    }
  }

  String get subtitle {
    switch (type) {
      case AudioDeviceType.earpiece:
        return 'Default · Phone earpiece';
      case AudioDeviceType.speaker:
        return 'Loudspeaker · Everyone can hear';
      case AudioDeviceType.bluetooth:
        return 'Bluetooth · Connected';
      case AudioDeviceType.wired:
        return 'Wired · Connected';
    }
  }
}

// ─── Page ─────────────────────────────────────────────────────────────────────
class PassengerActiveCallPage extends StatefulWidget {
  final String driverName;
  final String avatarAsset;

  const PassengerActiveCallPage({
    super.key,
    this.driverName = 'Ritesh',
    this.avatarAsset = 'assets/images/bikash_tamang_avatar.png',
  });

  @override
  State<PassengerActiveCallPage> createState() =>
      _PassengerActiveCallPageState();
}

class _PassengerActiveCallPageState extends State<PassengerActiveCallPage>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isMuted = false;

  // ─── Audio devices (loaded from native) ───
  List<AudioDevice> _audioDevices = const [];
  bool _devicesLoading = true;
  String? _selectedDeviceId;

  AudioDevice? get _selectedDevice =>
      _audioDevices.isEmpty
          ? null
          : _audioDevices.firstWhere(
              (d) => d.id == _selectedDeviceId,
              orElse: () => _audioDevices.first,
            );

  bool get _isNonDefaultAudio {
    final sel = _selectedDevice;
    return sel != null && sel.type != AudioDeviceType.earpiece;
  }

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    await AudioDeviceService.requestBluetoothPermission();
    final devices = await AudioDeviceService.getOutputDevices();
    if (mounted) {
      setState(() {
        _audioDevices = devices;
        // Default to earpiece if available, else first device
        _selectedDeviceId = devices
            .firstWhere(
              (d) => d.type == AudioDeviceType.earpiece,
              orElse: () => devices.first,
            )
            .id;
        _devicesLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString()}:${secs.toString().padLeft(2, '0')}';
  }

  // ─── Audio picker bottom sheet ─────────────────────────────────────────────
  void _showAudioPicker() {
    // Refresh device list each time the sheet opens so newly connected
    // Bluetooth devices appear without restarting the call.
    _loadDevices();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title row
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF1F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up_rounded,
                          color: Color(0xFFE52020),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Audio Output',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: Text(
                      'Choose where to play call audio',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 8),

                  // Loading state
                  if (_devicesLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE52020),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  else
                    ..._audioDevices.map((device) {
                      final isSelected = (_selectedDeviceId == device.id) ||
                          (_selectedDevice?.id == device.id);
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedDeviceId = device.id);
                          setSheetState(() {});
                          Navigator.pop(ctx);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFFF5F5)
                                : const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFE52020)
                                  : const Color(0xFFEEF2F7),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon badge
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFE4E6)
                                      : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  device.icon,
                                  color: isSelected
                                      ? const Color(0xFFE52020)
                                      : const Color(0xFF64748B),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Name + subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      device.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? const Color(0xFFE52020)
                                            : const Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      device.subtitle,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Selected check
                              AnimatedOpacity(
                                opacity: isSelected ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE52020),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final sel = _selectedDevice;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // ─── Top bar ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFFE52020),
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_rounded,
                            color: Color(0xFFE52020), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'End-to-end encrypted',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE52020),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // ─── Avatar with concentric rings ───
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFF1F2).withValues(alpha: 0.4),
                    ),
                  ),
                  Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFF1F2).withValues(alpha: 0.7),
                    ),
                  ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFE4E6).withValues(alpha: 0.7),
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        widget.avatarAsset,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ─── Driver name ───
            Text(
              widget.driverName,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your driver',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF94A3B8),
              ),
            ),

            const SizedBox(height: 2),

            // ─── Timer badge ───
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(4, (index) {
                          final double baseHeight =
                              index == 2 ? 8.0 : (index % 2 == 0 ? 5.0 : 7.0);
                          final offset = (index * 0.25);
                          final value =
                              (_waveController.value + offset) % 1.0;
                          final height = baseHeight + (value * 3.0);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.8),
                            width: 2.0,
                            height: height,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE52020),
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDuration(_elapsedSeconds),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Active device pill (shown when non-default) ───
            if (_isNonDefaultAudio && sel != null) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(30),
                  border:
                      Border.all(color: const Color(0xFFBFDBFE), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(sel.icon, color: const Color(0xFF2563EB), size: 13),
                    const SizedBox(width: 5),
                    Text(
                      sel.name,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(flex: 3),

            // ─── Bottom controls ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Audio button
                  _buildControlButton(
                    icon: sel?.icon ?? Icons.speaker_phone_rounded,
                    label: 'Audio',
                    isActive: _isNonDefaultAudio,
                    onTap: _showAudioPicker,
                  ),

                  // Mute button
                  _buildControlButton(
                    icon: _isMuted
                        ? Icons.mic_off_rounded
                        : Icons.mic_rounded,
                    label: _isMuted ? 'Unmute' : 'Mute',
                    isActive: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),

                  // End Call button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFDC2626),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x33DC2626),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.call_end_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'End Call',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFFFEE2E2) : Colors.white,
              border: Border.all(
                color: isActive
                    ? const Color(0xFFFECACA)
                    : const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFDC2626),
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
