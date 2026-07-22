import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcome_page.dart';
import '../driver/rider_dashboard.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToPassengerDashboard() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToDriverDashboard() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RiderDashboard(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Background color set to white to match the top image background and eliminate gap
    const bgColor = Colors.white;

    Widget scaffold = Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ─── Bottom background image pinned at bottom ───
          Positioned(
            left: 0,
            right: 0,
            bottom: -50,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.6),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.15, 0.35],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/onboarding_buttom_bg.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // ─── Main content on top ───
          FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideUp,
              child: Column(
                children: [
                  // ─── Top: Onboarding Image + Yatri Branding ───
                  Expanded(
                    flex: 4,
                    child: _buildTopSection(),
                  ),

                  // ─── Bottom: Mode Selection Cards ───
                  Expanded(
                    flex: 4,
                    child: _buildBottomSection(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          _showExitToast(context);
          return;
        }
        SystemNavigator.pop();
      },
      child: scaffold,
    );
  }

  void _showExitToast(BuildContext context) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 40,
        right: 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.exit_to_app_rounded,
                    color: Color(0xFFE52020), size: 18),
                const SizedBox(width: 10),
                Text(
                  'Tap again to close app',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  // ════════════════════════════════════════════════════════════
  // TOP SECTION — Onboarding image + Yatri logo text + tagline
  // ════════════════════════════════════════════════════════════
  Widget _buildTopSection() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background image — onboarding_bg.png
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.white.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.65, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              'assets/images/onboarding_top_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),

        // Yatri branding overlay
        Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // "Yatri" logo text
              Text(
                'Yatri',
                style: GoogleFonts.poppins(
                  fontSize: 62,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE52020),
                  height: 1.0,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 2),
              // "Travel Together" subtitle
              Text(
                'Travel Together',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D2D2D),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              // "Share the Journey" tagline
              Text(
                'Share the Journey',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF777777),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              // Decorative red line with diamond
              _buildDecorativeDivider(),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // BOTTOM SECTION — "Choose your mode" + selection cards
  // ════════════════════════════════════════════════════════════
  Widget _buildBottomSection() {
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // "Choose your mode" heading and subtitle with diamond translated upwards
          Transform.translate(
            offset: const Offset(0, -38),
            child: Column(
              children: [
                Text(
                  'Choose your mode',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 6),
                // "You can switch anytime" subtitle with diamond
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You can switch anytime',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Small diamond icon centered
                    Transform.rotate(
                      angle: 0.785398, // 45 degrees
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE52020),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Passenger and Driver Mode cards translated upwards
          Transform.translate(
            offset: const Offset(0, -50),
            child: Column(
              children: [
                // ── Passenger Mode Card (Red gradient) ──
                _buildPassengerModeCard(),
                const SizedBox(height: 14),
                // ── Driver Mode Card (White with border) ──
                _buildDriverModeCard(),
              ],
            ),
          ),

          // Page indicators removed
        ],
      ),
    );
  }

  // ────────────────────────────────────
  // DECORATIVE DIVIDER — Red line + diamond
  // ────────────────────────────────────
  Widget _buildDecorativeDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 2.5,
          decoration: BoxDecoration(
            color: const Color(0xFFE52020),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        // Diamond shape
        Transform.rotate(
          angle: 0.785398,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFE52020),
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 2.5,
          decoration: BoxDecoration(
            color: const Color(0xFFE52020),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────
  // PASSENGER MODE CARD — Red gradient
  // ────────────────────────────────────
  Widget _buildPassengerModeCard() {
    return GestureDetector(
      onTap: _navigateToPassengerDashboard,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE52020), Color(0xFFCC1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE52020).withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Person icon in a rounded square
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passenger Mode',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Find rides & travel safe',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFE52020),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────
  // DRIVER MODE CARD — White with border
  // ────────────────────────────────────
  Widget _buildDriverModeCard() {
    return GestureDetector(
      onTap: _navigateToDriverDashboard,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFEEEEEE),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Car icon in a rounded square
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                color: Color(0xFFE52020),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver Mode',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Post rides & earn more',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE52020),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFE52020),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────
  // PAGE INDICATOR — Dots with step number
  // ────────────────────────────────────
}
