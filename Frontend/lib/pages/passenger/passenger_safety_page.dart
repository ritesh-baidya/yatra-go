import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_verify_phone_page.dart';
import 'passenger_emergency_contact_page.dart';
import 'passenger_sos_page.dart';
import 'passenger_safety_tips_page.dart';

class PassengerSafetyPage extends StatelessWidget {
  const PassengerSafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
                        _buildSafetyGraphic(),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Manage your safety and get help\nwhen you need it.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildSafetyItem(
                                context: context,
                                iconWidget: _buildSOSIcon(),
                                title: 'SOS Panic Button',
                                subtitle: 'Get instant help in an emergency.',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PassengerSosPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildSafetyItem(
                                context: context,
                                iconWidget: _buildEmergencyContactIcon(),
                                title: 'Emergency Contacts',
                                subtitle: 'Add and manage people you trust in case of emergency.',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PassengerEmergencyContactPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildSafetyItem(
                                context: context,
                                iconWidget: _buildSafetyTipsIcon(),
                                title: 'Safety Tips',
                                subtitle: 'Learn useful tips to keep yourself safe.',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PassengerSafetyTipsPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildSafetyItem(
                                context: context,
                                iconWidget: _buildOtpIcon(),
                                title: 'OTP Verification',
                                subtitle: 'Verify your ride with OTP for added security.',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PassengerVerifyPhonePage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFFE52020),
                  size: 26,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Safety',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE52020),
                  letterSpacing: -0.3,
                ),
              ),
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
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE52020), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(width: 30, height: 1.5, color: const Color(0xFFE52020)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyGraphic() {
    return Center(
      child: Container(
        width: 110,
        height: 110,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF1F2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE4E6),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shield_rounded, color: Color(0xFFE52020), size: 50),
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.check, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyItem({
    required BuildContext context,
    required Widget iconWidget,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: iconWidget,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFE52020),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.phone_outlined, color: Color(0xFFE52020), size: 26),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFFE52020),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'SOS',
              style: GoogleFonts.inter(
                fontSize: 6,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactIcon() {
    return const Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.person_outline_rounded, color: Color(0xFFE52020), size: 28),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(Icons.shield_outlined, color: Color(0xFFE52020), size: 14),
        ),
      ],
    );
  }

  Widget _buildSafetyTipsIcon() {
    return const Icon(
      Icons.verified_user_outlined,
      color: Color(0xFFE52020),
      size: 28,
    );
  }

  Widget _buildOtpIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.shield_outlined, color: Color(0xFFE52020), size: 30),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            'OTP',
            style: GoogleFonts.inter(
              fontSize: 7.5,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFE52020),
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}
