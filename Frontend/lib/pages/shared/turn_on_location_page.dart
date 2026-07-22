import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../passenger/passenger_dashboard.dart';

class TurnOnLocationPage extends StatefulWidget {
  const TurnOnLocationPage({super.key});

  @override
  State<TurnOnLocationPage> createState() => _TurnOnLocationPageState();
}

class _TurnOnLocationPageState extends State<TurnOnLocationPage> {
  DateTime? _lastBackPressTime;

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          _showExitToast(context);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 4),
              // Illustration Image
              Expanded(
                flex: 12,
                child: Center(
                  child: Image.asset(
                    'assets/images/turn_on_location_bg.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),
              // Title text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B), // Dark slate text
                    height: 1.2,
                  ),
                  children: [
                    const TextSpan(text: 'Turn your '),
                    TextSpan(
                      text: 'location',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFC20D0D), // Crimson red
                      ),
                    ),
                    const TextSpan(text: ' on'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle/Description text
              Text(
                'You’ll be able to find yourself on the map,\nand drivers will be able to find you at the pickup point.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF475569), // Slate gray/blue
                  height: 1.4,
                ),
              ),
              const Spacer(),
              // Button at the bottom
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const PassengerDashboard(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC20D0D), // Crimson red
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Enable location services',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

