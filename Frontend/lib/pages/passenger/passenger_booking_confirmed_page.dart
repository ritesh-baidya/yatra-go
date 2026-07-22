import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_dashboard.dart';
import 'passenger_chat_detail_page.dart';

class BookingConfirmedPage extends StatelessWidget {
  const BookingConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 480;

    Widget mainContent = const _BookingConfirmedBody();

    if (isDesktop) {
      final screenHeight = MediaQuery.of(context).size.height;
      final clampedHeight = screenHeight > 940 ? 900.0 : screenHeight - 40.0;
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
                      colors: [Color(0xFF1A0A0A), Color(0xFF2D1515)],
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
                  child: mainContent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return mainContent;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Main Body
// ─────────────────────────────────────────────────────────────────────────────
class _BookingConfirmedBody extends StatelessWidget {
  const _BookingConfirmedBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // ── Main content area — fills available space ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 4),

                    // Back chevron
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFFDC2626),
                          size: 30,
                        ),
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Green check + confetti
                    const _ConfettiCheckmark(),

                    const Spacer(flex: 1),

                    // Title
                    Text(
                      'Booking Confirmed!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 6),
                    const _Divider(),
                    const SizedBox(height: 8),

                    Text(
                      'Driver has accepted your request.\nYour booking is confirmed.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Driver card
                    const _DriverCard(),

                    const SizedBox(height: 10),

                    // Route card
                    const _RouteCard(),

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),

            // ── CTA Button (fixed at bottom) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PassengerDashboard(initialTab: 1),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC1414),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'View Booking Details',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Positioned(
                        right: 16,
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Nav (fixed at bottom) ──
            const _BottomNav(),
          ],
        ),
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
//  Confetti + Green Checkmark (Centered & Fixed coordinate system)
// ─────────────────────────────────────────────────────────────────────────────
class _ConfettiCheckmark extends StatelessWidget {
  const _ConfettiCheckmark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Left side confetti ──
          const Positioned(top: 64, left: 48, child: _Dot(color: Color(0xFF22C55E), size: 8)),
          const Positioned(top: 18, left: 70, child: _Dot(color: Color(0xFFEF4444), size: 9)),
          const Positioned(top: 44, left: 90, child: _Dot(color: Color(0xFFEF4444), size: 6)),
          const Positioned(top: 8, left: 110, child: _Dot(color: Color(0xFF22C55E), size: 7)),

          // ── Right side confetti ──
          const Positioned(top: 8, right: 110, child: _Dot(color: Color(0xFF22C55E), size: 7)),
          const Positioned(top: 50, right: 90, child: _Dot(color: Color(0xFF22C55E), size: 7)),
          const Positioned(top: 22, right: 70, child: _Dot(color: Color(0xFFEF4444), size: 9)),
          const Positioned(top: 64, right: 48, child: _Dot(color: Color(0xFFFBBF24), size: 8)),

          // ── Green circle ──
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E), // Vibrant green
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.7854, // 45 degrees to make it a diamond/square
      child: Container(
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Red decorative divider  ─◆─
// ─────────────────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 52, height: 1.5, color: const Color(0xFFDC2626)),
        const SizedBox(width: 6),
        Transform.rotate(
          angle: 0.7854,
          child: Container(width: 8, height: 8, color: const Color(0xFFDC2626)),
        ),
        const SizedBox(width: 6),
        Container(width: 52, height: 1.5, color: const Color(0xFFDC2626)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Driver Card
// ─────────────────────────────────────────────────────────────────────────────
class _DriverCard extends StatelessWidget {
  const _DriverCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top Row: Avatar, Name, Call & Chat ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/ram_kumar_avatar.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Ramesh Thapa',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 17),
                          const SizedBox(width: 2),
                          Text(
                            '4.8',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '128',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                            TextSpan(
                              text: ' rides',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _CircleBtn(
                  icon: Icons.call_outlined,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Calling Ramesh Thapa...'),
                        backgroundColor: Color(0xFFDC2626),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _CircleBtn(
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PassengerChatDetailPage(
                          driverName: 'Ramesh Thapa',
                          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                          initials: 'RT',
                          isOnline: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: const Color(0xFFF3F4F6)),

          // ── Bottom Row: Car details ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.directions_car_filled_rounded, color: Color(0xFF1F2937), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Hyundai i20',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5563),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(width: 1, height: 14, color: const Color(0xFFE5E7EB)),
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'White',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5563),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(width: 1, height: 14, color: const Color(0xFFE5E7EB)),
                ),
                const Text('🇳🇵', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'BA 01 JA 1234',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4B5563),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
          color: Colors.white,
        ),
        child: Icon(icon, color: const Color(0xFFDC2626), size: 18),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Route Card
// ─────────────────────────────────────────────────────────────────────────────
class _RouteCard extends StatelessWidget {
  const _RouteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Origin to Destination Row with vertical dashed line
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.directions_walk_rounded, color: Color(0xFF1F2937), size: 24),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: SizedBox(
                            width: 2,
                            child: CustomPaint(
                              painter: _DashPainter(),
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.sports_score_rounded, color: Color(0xFF1F2937), size: 24),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          'Kathmandu, New Baneshwor',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Pokhara, Lakeside',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Container(height: 1, color: const Color(0xFFF3F4F6)),
            const SizedBox(height: 14),

            // Date & Time Row
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Color(0xFF4B5563), size: 20),
                const SizedBox(width: 16),
                Text(
                  '25 May 2025, 08:00 AM',
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Seats Row
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, color: Color(0xFF4B5563), size: 20),
                const SizedBox(width: 16),
                Text(
                  '2 Seats',
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dash = 4, gap = 4;
    double y = 0;
    final paint = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dash), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter o) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NavItem(icon: Icons.home_outlined, label: 'Home', selected: false),
              _NavItem(icon: Icons.calendar_today_outlined, label: 'Bookings', selected: true),
              _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Messages', selected: false),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', selected: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavItem({required this.icon, required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFDC2626) : const Color(0xFF9CA3AF);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 3),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Kept for backward compatibility
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 4, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 1.5;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
