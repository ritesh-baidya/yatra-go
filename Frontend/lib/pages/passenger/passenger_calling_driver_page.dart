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

class PassengerCallingDriverPage extends StatefulWidget {
  final String driverName;
  final String avatarAsset;
  final bool isCallAccepted;

  const PassengerCallingDriverPage({
    super.key,
    this.driverName = 'Ritesh',
    this.avatarAsset = 'assets/images/ram_kumar_avatar.png',
    this.isCallAccepted = false,
  });

  @override
  State<PassengerCallingDriverPage> createState() =>
      _PassengerCallingDriverPageState();
}

class _PassengerCallingDriverPageState
    extends State<PassengerCallingDriverPage>
    with TickerProviderStateMixin {
  late bool _isCallConnected;
  int _secondsElapsed = 0;
  Timer? _callTimer;

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

  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _isCallConnected = widget.isCallAccepted;
    if (_isCallConnected) {
      _startCallTimer();
    }

    _loadDevices();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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

  void acceptCall() {
    if (!_isCallConnected) {
      setState(() {
        _isCallConnected = true;
        _secondsElapsed = 0;
      });
      _startCallTimer();
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Animated Audio Waveform / Equalizer icon
  Widget _buildAnimatedEqualizer() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Container(
          height: 14,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(4, (index) {
              final double baseHeight =
                  index == 2 ? 9.0 : (index % 2 == 0 ? 5.0 : 7.0);
              final offset = (index * 0.25);
              final value = (_waveController.value + offset) % 1.0;
              final height = baseHeight + (value * 4.0);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.2),
                width: 2.5,
                height: height,
                decoration: BoxDecoration(
                  color: const Color(0xFFE52020),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              );
            }),
          ),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 480;

    Widget bodyContent = Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with red back chevron and End-to-end encrypted lock
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFFE52020),
                        size: 32,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFFE52020),
                        size: 16,
                      ),
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
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Driver Avatar with Glowing Pink/Red Ring
            Center(
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFF0F2),
                    border: Border.all(
                      color: const Color(0xFFFFD1D6),
                      width: 10,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE52020).withValues(alpha: 0.08),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: Image.asset(
                        widget.avatarAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 80,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Driver Name
            Text(
              widget.driverName,
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 14),

            // Calling Status Pill (Shows Calling... ONLY until call is accepted)
            GestureDetector(
              onTap: acceptCall,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAnimatedEqualizer(),
                    const SizedBox(width: 8),
                    if (!_isCallConnected)
                      Text(
                        'Calling...',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0F172A),
                        ),
                      )
                    else
                      Text(
                        _formatDuration(_secondsElapsed),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bottom Action Control Buttons (Audio, Mute, End Call)
            Padding(
              padding: const EdgeInsets.only(bottom: 48, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Audio / Device Picker Button
                  _buildCallActionButton(
                    icon: _selectedDevice?.icon ?? Icons.speaker_phone_rounded,
                    label: _selectedDevice?.name.split(' ').first ?? 'Audio',
                    isRedBackground: false,
                    isSelected: _isNonDefaultAudio,
                    onTap: _showAudioPicker,
                  ),

                  // Mute Button
                  _buildCallActionButton(
                    icon: _isMuted
                        ? Icons.mic_off_rounded
                        : Icons.mic_none_rounded,
                    label: 'Mute',
                    isRedBackground: false,
                    isSelected: _isMuted,
                    onTap: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                    },
                  ),

                  // End Call Button
                  _buildCallActionButton(
                    icon: Icons.call_end_rounded,
                    label: 'End Call',
                    isRedBackground: true,
                    isSelected: false,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      final height = MediaQuery.of(context).size.height;
      final clampedHeight = height > 940 ? 900.0 : height - 40.0;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A0A0A),
                        Color(0xFF2D1515),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 380,
                height: clampedHeight,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(color: const Color(0xFF1A0A0A), width: 10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.65),
                      blurRadius: 36,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: bodyContent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return bodyContent;
  }

  Widget _buildCallActionButton({
    required IconData icon,
    required String label,
    required bool isRedBackground,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRedBackground
                  ? const Color(0xFFE52020)
                  : Colors.white,
              border: isRedBackground
                  ? null
                  : Border.all(
                      color: isSelected
                          ? const Color(0xFFE52020)
                          : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
              boxShadow: [
                BoxShadow(
                  color: isRedBackground
                      ? const Color(0xFFE52020).withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: isRedBackground ? Colors.white : const Color(0xFFE52020),
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
