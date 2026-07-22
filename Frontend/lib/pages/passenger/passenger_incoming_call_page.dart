import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_active_call_page.dart';

class PassengerIncomingCallPage extends StatefulWidget {
  final String driverName;
  final String avatarAsset;

  const PassengerIncomingCallPage({
    super.key,
    this.driverName = 'Ritesh',
    this.avatarAsset = 'assets/images/bikash_tamang_avatar.png',
  });

  @override
  State<PassengerIncomingCallPage> createState() =>
      _PassengerIncomingCallPageState();
}

class _PassengerIncomingCallPageState extends State<PassengerIncomingCallPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ─── End-to-end encrypted badge ───
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, color: Color(0xFFE52020), size: 16),
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

            const Spacer(flex: 2),

            // ─── Avatar with concentric rings ───
            ScaleTransition(
              scale: _pulseAnimation,
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outermost ring
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFF1F2).withValues(alpha: 0.4),
                      ),
                    ),
                    // Middle ring
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFF1F2).withValues(alpha: 0.7),
                      ),
                    ),
                    // Inner ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFE4E6).withValues(alpha: 0.7),
                      ),
                    ),
                    // Avatar
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

            // ─── Calling... badge with wave animation ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated wave bars
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(4, (index) {
                          final double baseHeight = index == 2 ? 8.0 : (index % 2 == 0 ? 5.0 : 7.0);
                          final offset = (index * 0.2);
                          final value = (_waveController.value + offset) % 1.0;
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
                  // Vertical divider line
                  Container(
                    width: 1.0,
                    height: 10,
                    color: const Color(0xFFFDA4AF),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Calling...',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 3),

            // ─── Decline / Accept buttons ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Decline button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFF1F2),
                            border: Border.all(
                              color: const Color(0xFFFEE2E2),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE52020),
                            ),
                            child: const Icon(
                              Icons.call_end_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Decline',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 80),
                  // Accept button


                  // Accept button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PassengerActiveCallPage(
                                driverName: widget.driverName,
                                avatarAsset: widget.avatarAsset,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF0FDF4),
                            border: Border.all(
                              color: const Color(0xFFDCFCE7),
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF22C55E),
                            ),
                            child: const Icon(
                              Icons.call_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Accept',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
