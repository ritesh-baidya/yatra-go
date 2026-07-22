import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';

enum SosState {
  main,
  countdown,
  sent,
  active,
  cancelled,
}

class PassengerSosPage extends StatefulWidget {
  const PassengerSosPage({super.key});

  @override
  State<PassengerSosPage> createState() => _PassengerSosPageState();
}

class _PassengerSosPageState extends State<PassengerSosPage> with TickerProviderStateMixin {
  SosState _currentState = SosState.main;
  int _countdownSeconds = 5;
  Timer? _countdownTimer;
  Timer? _sentStateTimer;
  Timer? _activeTimer;
  int _activeSeconds = 0;
  
  // Animation controller for pulsing SOS button
  late AnimationController _pulseController;
  // Animation controller for orbiting contacts
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _sentStateTimer?.cancel();
    _activeTimer?.cancel();
    _pulseController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _currentState = SosState.countdown;
      _countdownSeconds = 5;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        timer.cancel();
        _sendAlert();
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _sentStateTimer?.cancel();
    setState(() {
      _currentState = SosState.cancelled;
    });
  }

  void _sendAlert() {
    setState(() {
      _currentState = SosState.sent;
    });

    _sentStateTimer?.cancel();
    _sentStateTimer = Timer(const Duration(seconds: 3), () {
      if (_currentState == SosState.sent) {
        _startActiveSos();
      }
    });
  }

  void _cancelSentAlert() {
    _sentStateTimer?.cancel();
    setState(() {
      _currentState = SosState.cancelled;
    });
  }

  void _startActiveSos() {
    setState(() {
      _currentState = SosState.active;
      _activeSeconds = 0;
    });

    _activeTimer?.cancel();
    _activeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _activeSeconds++;
      });
    });
  }

  void _stopSharing() {
    _activeTimer?.cancel();
    setState(() {
      _currentState = SosState.cancelled;
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 90,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 28),
                        _buildContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom nav bar pinned
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PassengerBottomNavBar(
                selectedIndex: 2,
                onTap: (index) {
                  Navigator.pop(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ───
  Widget _buildHeader(BuildContext context) {
    String title = 'SOS Panic Button';
    if (_currentState == SosState.countdown) title = 'SOS Countdown';
    if (_currentState == SosState.sent) title = 'Alert Sent!';
    if (_currentState == SosState.active) title = 'SOS Active';
    if (_currentState == SosState.cancelled) title = 'SOS Cancelled';

    final showDiamond = _currentState == SosState.main || _currentState == SosState.active;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (_currentState == SosState.main || _currentState == SosState.cancelled) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _currentState = SosState.main;
                  });
                }
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFFE52020),
                  size: 22,
                ),
              ),
            ),
          ),
          // Title + diamond divider
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE52020),
                  letterSpacing: -0.3,
                ),
              ),
              if (showDiamond) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 30, height: 1.5, color: const Color(0xFFE52020)),
                    const SizedBox(width: 6),
                    Transform.rotate(
                      angle: 45 * 3.14159265 / 180,
                      child: Container(
                        width: 7,
                        height: 7,
                        color: const Color(0xFFE52020),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(width: 30, height: 1.5, color: const Color(0xFFE52020)),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ─── CONTENT SWITCHER ───
  Widget _buildContent() {
    switch (_currentState) {
      case SosState.main:
        return _buildMainContent();
      case SosState.countdown:
        return _buildCountdownContent();
      case SosState.sent:
        return _buildSentContent();
      case SosState.active:
        return _buildActiveContent();
      case SosState.cancelled:
        return _buildCancelledContent();
    }
  }

  // ─── 1. MAIN SOS CONTENT ───
  Widget _buildMainContent() {
    return Column(
      children: [
        // SOS Circle Graphic — fixed-size container so pulsing rings don't shift layout
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulse ring 2
                    Container(
                      width: 140 + (36 * _pulseController.value),
                      height: 140 + (36 * _pulseController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE52020).withValues(alpha: 0.05 * (1 - _pulseController.value)),
                      ),
                    ),
                    // Outer pulse ring 1
                    Container(
                      width: 110 + (24 * _pulseController.value),
                      height: 110 + (24 * _pulseController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE52020).withValues(alpha: 0.1 * (1 - _pulseController.value)),
                      ),
                    ),
                    // Light pink background circle
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1F2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // White circle with drop shadow
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    // Central solid red SOS button
                    GestureDetector(
                      onTap: _startCountdown,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE52020),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'SOS',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Get instant help in an emergency.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 36),
        // Features list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _buildFeatureItem(
                icon: Icons.person_outline_rounded,
                title: 'Instant Alert',
                desc: 'We will notify your emergency contacts immediately.',
              ),
              const SizedBox(height: 20),
              _buildFeatureItem(
                icon: Icons.my_location_rounded,
                title: 'Share Location',
                desc: 'Your live location will be shared with them.',
              ),
              const SizedBox(height: 20),
              _buildFeatureItem(
                icon: Icons.verified_user_outlined,
                title: 'Stay Safe',
                desc: 'Help is on the way.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        // Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _startCountdown,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52020),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Activate SOS',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: const Color(0xFFE52020), size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── 2. COUNTDOWN CONTENT ───
  Widget _buildCountdownContent() {
    return Column(
      children: [
        Text(
          'Help will be sent in',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 24),
        // Countdown circular indicator
        Center(
          child: SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: _countdownSeconds / 5,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE52020)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '0$_countdownSeconds',
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Seconds',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Your location and alert will be shared with your contacts.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 48),
        // Cancel Box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Cancel SOS?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'You can cancel if it was a mistake.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _cancelCountdown,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE52020), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel SOS',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE52020),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── 3. ALERT SENT CONTENT ───
  Widget _buildSentContent() {
    return Column(
      children: [
        // Red Shield check graphic — fixed size so pulsing rings don't shift layout
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                  // Outer pulse ring 2
                  Container(
                    width: 140 + (30 * _pulseController.value),
                    height: 140 + (30 * _pulseController.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE52020).withValues(alpha: 0.04 * (1 - _pulseController.value)),
                    ),
                  ),
                  // Outer pulse ring 1
                  Container(
                    width: 110 + (20 * _pulseController.value),
                    height: 110 + (20 * _pulseController.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE52020).withValues(alpha: 0.08 * (1 - _pulseController.value)),
                    ),
                  ),
                  // Light pink background circle
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF1F2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // White circle with drop shadow
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  // Red shield check
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE52020),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.white, size: 32),
                        Positioned(
                          top: 22,
                          child: Icon(Icons.check, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your SOS alert has been sent.',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your location is being shared with your\nemergency contacts.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 36),
        // Help on the way box
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  'Help is on the way',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We have notified your contacts.\nStay calm and stay safe.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        // Button to proceed to Active screen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _cancelSentAlert,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52020),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "I'm Safe Now",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── 4. ACTIVE SOS CONTENT ───
  Widget _buildActiveContent() {
    return Column(
      children: [
        // Pulsing / Orbiting Circle
        Center(
          child: SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Dashed orbit circles
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE52020).withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE52020).withValues(alpha: 0.08),
                      width: 1.5,
                    ),
                  ),
                ),
                // Center SOS Button with light pink ring
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE52020),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'SOS',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Orbiting contact avatar 1 (B)
                AnimatedBuilder(
                  animation: _orbitController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _orbitController.value * 2 * 3.14159,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Transform.rotate(
                          angle: -_orbitController.value * 2 * 3.14159,
                          child: _buildOrbitingAvatar('B'),
                        ),
                      ),
                    );
                  },
                ),
                // Orbiting contact avatar 2 (M)
                AnimatedBuilder(
                  animation: _orbitController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: (_orbitController.value * 2 * 3.14159) + 2.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.rotate(
                          angle: -((_orbitController.value * 2 * 3.14159) + 2.0),
                          child: _buildOrbitingAvatar('M'),
                        ),
                      ),
                    );
                  },
                ),
                // Orbiting contact avatar 3 (S)
                AnimatedBuilder(
                  animation: _orbitController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: (_orbitController.value * 2 * 3.14159) + 4.0,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Transform.rotate(
                          angle: -((_orbitController.value * 2 * 3.14159) + 4.0),
                          child: _buildOrbitingAvatar('S'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your location is shared with\n3 emergency contacts.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
        // Live location banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE4E6), width: 1),
            ),
            child: Row(
              children: [
                // Pulsing dot
                _buildPulsingDot(),
                const SizedBox(width: 10),
                Text(
                  'Sharing live location',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE52020),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimer(_activeSeconds),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE52020),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        // Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _stopSharing,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52020),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Stop Sharing',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrbitingAvatar(String letter) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE52020), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFE52020),
        ),
      ),
    );
  }

  Widget _buildPulsingDot() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE52020).withValues(alpha: 0.25 * (1 - _pulseController.value)),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFE52020),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  // ─── 5. CANCELLED CONTENT ───
  Widget _buildCancelledContent() {
    return Column(
      children: [
        // Green Shield check graphic — fixed size so pulsing rings don't shift layout
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                  // Green pulse ring 2
                  Container(
                    width: 140 + (30 * _pulseController.value),
                    height: 140 + (30 * _pulseController.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF22C55E).withValues(alpha: 0.04 * (1 - _pulseController.value)),
                    ),
                  ),
                  // Green pulse ring 1
                  Container(
                    width: 110 + (20 * _pulseController.value),
                    height: 110 + (20 * _pulseController.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF22C55E).withValues(alpha: 0.08 * (1 - _pulseController.value)),
                    ),
                  ),
                  // Light green background circle
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // White circle with drop shadow
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  // Green shield check
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.white, size: 32),
                        Positioned(
                          top: 22,
                          child: Icon(Icons.check, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'SOS alert has been cancelled.',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'No alert was sent to your\nemergency contacts.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 56),
        // Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentState = SosState.main;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52020),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Back to Safety',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
