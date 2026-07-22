import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../driver/rider_dashboard.dart';
import 'passenger_profile_edit_page.dart';
import 'passenger_help_support_page.dart';
import 'passenger_dashboard.dart';
import 'passenger_settings_page.dart';
import 'passenger_safety_page.dart';
import 'passenger_ride_history_page.dart';

class PassengerProfilePage extends StatelessWidget {
  const PassengerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE), // Match background
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).padding.bottom + 100, // Extra spacing for bottom nav bar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              // ─── Profile Info Card ───
              _buildProfileCard(context),
              const SizedBox(height: 24),

              // ─── Menu Options Card ───
              _buildMenuCard(context),
              const SizedBox(height: 24),

              // ─── Switch to Driver Card ───
              _buildSwitchDriverCard(context),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PassengerProfileEditPage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Wave background graphic in the bottom right corner
              Positioned(
                right: 0,
                bottom: 0,
                width: 100,
                height: 60,
                child: CustomPaint(
                  painter: _ProfileCardWavePainter(),
                ),
              ),
              // Card contents
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    // Profile Avatar with Initials "SS"
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: const Color(0xFFFFF1F2),
                      child: Text(
                        'SS',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE52020),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name & Info Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sushma Shrestha',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.mail_outline_rounded,
                                color: Color(0xFF94A3B8),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'sushma@email.com',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                color: Color(0xFFE52020),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '+977 98xxxxxxxx',
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
                    const SizedBox(width: 8),
                    // Trailing arrow button
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2).withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFE52020),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: _buildProfileMenuItems(context),
        ),
      ),
    );
  }

  List<Widget> _buildProfileMenuItems(BuildContext context) {
    final menuData = [
      {'icon': Icons.history_rounded, 'title': 'Ride History'},
      {'icon': Icons.verified_user_outlined, 'title': 'Safety'},
      {'icon': Icons.help_outline_rounded, 'title': 'Help & Support'},
      {'icon': Icons.settings_outlined, 'title': 'Settings'},
    ];

    final widgets = <Widget>[];

    for (var i = 0; i < menuData.length; i++) {
      final item = menuData[i];
      widgets.add(
        _buildProfileMenuItem(
          context,
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          trailingText: item['trailing'] as String?,
        ),
      );

      if (i < menuData.length - 1) {
        widgets.add(
          const Divider(
            height: 1,
            color: Color(0xFFF1F5F9),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
  }) {
    return InkWell(
      onTap: () {
        if (title == 'Help & Support') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PassengerHelpSupportPage(),
            ),
          ).then((value) {
            if (value is int && context.mounted) {
              final dashboardState = context.findAncestorStateOfType<PassengerDashboardState>();
              if (dashboardState != null) {
                dashboardState.setTabIndex(value);
              }
            }
          });
        } else if (title == 'Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PassengerSettingsPage(),
            ),
          );
        } else if (title == 'Ride History') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PassengerRideHistoryPage(),
            ),
          );
        } else if (title == 'Safety') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PassengerSafetyPage(),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Soft red background with red icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2), // soft light red tint
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: const Color(0xFFE52020), // Red theme
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFE52020), // red chevron
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchDriverCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Car outline in red inside light red circle
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.directions_car_outlined,
                color: Color(0xFFE52020),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Switch to Driver Mode',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Start earning rides and more',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Solid Red Switch Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const RiderDashboard(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52020), // Vibrant Red
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Switch',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCardWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // ─── Layer 1 (Backmost Wave) ───
    final path1 = Path();
    path1.moveTo(0, height);
    path1.lineTo(0, height * 0.85);
    path1.cubicTo(
      width * 0.35,
      height * 0.75,
      width * 0.7,
      height * 0.65,
      width,
      height * 0.5,
    );
    path1.lineTo(width, height);
    path1.close();

    final paint1 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          const Color(0xFFFFF1F2).withValues(alpha: 0.15),
          const Color(0xFFFEE2E2).withValues(alpha: 0.55),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(path1, paint1);

    // ─── Layer 2 (Middle Wave) ───
    final path2 = Path();
    path2.moveTo(width * 0.1, height);
    path2.cubicTo(
      width * 0.45,
      height * 0.85,
      width * 0.75,
      height * 0.5,
      width,
      height * 0.25,
    );
    path2.lineTo(width, height);
    path2.close();

    final paint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          const Color(0xFFFEE2E2).withValues(alpha: 0.25),
          const Color(0xFFFECACA).withValues(alpha: 0.65),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(path2, paint2);

    // ─── Layer 3 (Frontmost Wave) ───
    final path3 = Path();
    path3.moveTo(width * 0.35, height);
    path3.cubicTo(
      width * 0.6,
      height * 0.9,
      width * 0.82,
      height * 0.4,
      width,
      height * 0.05,
    );
    path3.lineTo(width, height);
    path3.close();

    final paint3 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          const Color(0xFFFECACA).withValues(alpha: 0.2),
          const Color(0xFFFCA5A5).withValues(alpha: 0.85),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
