import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_dashboard.dart';
import 'passenger_cancel_booking_page.dart';

class PassengerWaitingDriverResponsePage extends StatelessWidget {
  final String pickupLocation;
  final String dropoffLocation;
  final int pricePerSeat;
  final int availableSeats;
  final String date;
  final String time;
  final Map<String, dynamic> rideData;

  const PassengerWaitingDriverResponsePage({
    super.key,
    this.pickupLocation = 'Kathmandu, New Baneshwor',
    this.dropoffLocation = 'Pokhara, Lakeside',
    this.pricePerSeat = 700,
    this.availableSeats = 2,
    this.date = '25 May 2025',
    this.time = '08:00 AM',
    this.rideData = const {},
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 480;

    Widget mainContent = const _WaitingBody();

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

class _WaitingBody extends StatelessWidget {
  const _WaitingBody();

  @override
  Widget build(BuildContext context) {
    // Collect page parameters from ancestor or fallback to default values
    final page = context.findAncestorWidgetOfExactType<PassengerWaitingDriverResponsePage>();
    final pickup = page?.pickupLocation ?? 'Kathmandu, New Baneshwor';
    final dropoff = page?.dropoffLocation ?? 'Pokhara, Lakeside';
    final seats = page?.availableSeats ?? 2;
    final dateStr = page?.date ?? '25 May 2025';
    final timeStr = page?.time ?? '08:00 AM';
    final price = page?.pricePerSeat ?? 700;

    // Build standard ride map for cancel page compatibility
    final rideMap = {
      'id': 'req1',
      'driverName': 'Ram Kumar',
      'driverRating': 4.8,
      'driverRides': 128,
      'vehicle': 'Hyundai i20',
      'vehicleColor': 'White',
      'from': pickup,
      'to': dropoff,
      'price': price,
      'avatar': 'assets/images/ram_kumar_avatar.png',
      'status': 'Requested',
      'date': dateStr,
      'time': timeStr,
      'availableSeats': seats,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // ── Main content area fills space ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 4),

                    // Header Row with Back button and Title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Color(0xFFDC2626),
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30.0), // Offset the back button width to center the title
                            child: Text(
                              'Booking Requested',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF111827),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    const _RedDivider(),
                    const Spacer(flex: 6),

                    // Vector driver illustration
                    const _DriverSteeringIllustration(),

                    const Spacer(flex: 3),

                    // Subtitle Waiting for Response
                    Text(
                      'Waiting for driver response',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),



                    const Spacer(flex: 4),

                    // Route Card
                    _RouteCard(
                      pickup: pickup,
                      dropoff: dropoff,
                      date: dateStr,
                      seats: seats,
                    ),

                    const Spacer(flex: 3),

                    // Info notification banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFECDD3), width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFFE52020),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You will be notified once the driver responds.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),

            // ── Bottom Fixed CTA Action Buttons ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // My Booking Button (Solid Red)
                  GestureDetector(
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'My Booking',
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

                  const SizedBox(height: 10),

                  // Cancel Request Button (Outline Red)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CancelBookingPage(
                            ride: rideMap,
                            onCancelConfirmed: () {
                              // Action completed, go back to main dashboard
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PassengerDashboard(initialTab: 1),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFCC1414), width: 1.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel Request',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFCC1414),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Bottom Nav ──
            const _BottomNav(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Confetti-like Red Diamond Divider
// ─────────────────────────────────────────────────────────────────────────────
class _RedDivider extends StatelessWidget {
  const _RedDivider();

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
//  Driver Steering Illustration with Clock Badge
// ─────────────────────────────────────────────────────────────────────────────
class _DriverSteeringIllustration extends StatelessWidget {
  const _DriverSteeringIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Waiting_driver_response_bg.png',
      width: 220,
      height: 220,
      fit: BoxFit.contain,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Route Card
// ─────────────────────────────────────────────────────────────────────────────
class _RouteCard extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String date;
  final int seats;

  const _RouteCard({
    required this.pickup,
    required this.dropoff,
    required this.date,
    required this.seats,
  });

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
                          pickup,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          dropoff,
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
                // Calendar icon inside pink background badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF4B5563),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF374151),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Seats Row
            Row(
              children: [
                // Seats icon inside pink background badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF4B5563),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$seats Seats',
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
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
