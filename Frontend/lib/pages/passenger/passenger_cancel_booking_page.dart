import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelBookingPage extends StatefulWidget {
  final Map<String, dynamic> ride;
  final VoidCallback onCancelConfirmed;

  const CancelBookingPage({
    super.key,
    required this.ride,
    required this.onCancelConfirmed,
  });

  @override
  State<CancelBookingPage> createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  int _selectedReason = 0;

  final List<String> _reasons = [
    'Change of plans',
    'Found another ride',
    'Schedule issue',
    'Pickup / Drop location issue',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 480;

    Widget mainContent = Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // ─── Header Section (Solid Background with Pagoda Background Image) ───
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
            ),
            child: Stack(
              children: [

                // Header Content (Back Button + Centered Title)
                SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // Back Arrow
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFFE52020),
                                  size: 24,
                                ),
                              ),
                            ),
                            // Title with Diamond Divider
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Cancel Booking',
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(width: 44, height: 1.5, color: const Color(0xFFE52020)),
                                      const SizedBox(width: 6),
                                      Transform.rotate(
                                        angle: 0.7854,
                                        child: Container(width: 7, height: 7, color: const Color(0xFFE52020)),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(width: 44, height: 1.5, color: const Color(0xFFE52020)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 44), // placeholder for alignment
                          ],
                        ),
                      ),
                      const SizedBox(height: 14), // Space below divider to show the full pagoda base
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ─── Scrollable Content ───
          Expanded(
            child: ClipRect(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // ═══════════════════════════════
                        // Booking Summary Card
                        // ═══════════════════════════════
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFF1F5F9), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // ── Driver Row ──
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/ram_kumar_avatar.png',
                                      width: 52,
                                      height: 52,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.ride['driverName'] ??
                                              'Ram Kumar',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${widget.ride['date'] ?? 'Today'}',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Nepal Plate Box
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const NepalFlag(width: 14, height: 17),
                                          const SizedBox(width: 6),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                widget.ride['plateProvince'] ?? 'BAGMATI',
                                                style: GoogleFonts.inter(
                                                  fontSize: 7.5,
                                                  fontWeight: FontWeight.w800,
                                                  color: const Color(0xFF9CA3AF),
                                                ),
                                              ),
                                              const SizedBox(height: 0.5),
                                              Text(
                                                widget.ride['licensePlate'] ?? 'BAA 1234',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  color: const Color(0xFF111827),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xFFF1F5F9),
                                thickness: 1,
                                height: 32,
                              ),
                              // ── Route + Seat/Fare Row ──
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Route (Left side)
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Icons column
                                        Transform.translate(
                                          offset: const Offset(0, -1),
                                          child: Column(
                                            children: [

                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8FAFC),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: const Icon(
                                                Icons.directions_walk_rounded,
                                                color: Color(0xFF0F172A),
                                                size: 17,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Column(
                                              children: List.generate(
                                                  6,
                                                  (index) => Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 1.5),
                                                        width: 3,
                                                        height: 3,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFCBD5E1),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      )),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8FAFC),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                              ),
                                              child: const Icon(
                                                Icons.sports_score_rounded,
                                                color: Color(0xFF0F172A),
                                                size: 17,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Text column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.ride['from'] ??
                                                    'Kathmandu',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      const Color(0xFF1E293B),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Gongabu, KTM',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF94A3B8),
                                                ),
                                              ),
                                              const SizedBox(height: 26),
                                              Text(
                                                widget.ride['to'] ?? 'Pokhara',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      const Color(0xFF1E293B),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Lakeside, Pokhara',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF94A3B8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ═══════════════════════════════
                        // Reason for Cancellation Card
                        // ═══════════════════════════════
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFF1F5F9), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reason for cancellation',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Radio options
                              ...List.generate(_reasons.length, (index) {
                                final isSelected = _selectedReason == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedReason = index;
                                    });
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    decoration: BoxDecoration(
                                      border: index < _reasons.length - 1
                                          ? const Border(
                                              bottom: BorderSide(
                                                color: Color(0xFFF1F5F9),
                                                width: 1,
                                              ),
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        // Custom Radio
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xFFE52020)
                                                  : const Color(0xFFCBD5E1),
                                              width: 2,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: isSelected
                                              ? Center(
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Color(0xFFE52020),
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            _reasons[index],
                                            style: GoogleFonts.inter(
                                              fontSize: 14.5,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? const Color(0xFF1E293B)
                                                  : const Color(0xFF475569),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ═══════════════════════════════
                        // Info Banner
                        // ═══════════════════════════════
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFFECDD3), width: 1),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFFE52020),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF475569),
                                      height: 1.45,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text:
                                            'You can cancel your booking before ',
                                      ),
                                      TextSpan(
                                        text: '1 hour of departure',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFE52020),
                                          height: 1.45,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            ' to avoid cancellation charge.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ═══════════════════════════════
                        // Yes, Cancel Booking Button
                        // ═══════════════════════════════
                        GestureDetector(
                          onTap: () {
                            widget.onCancelConfirmed();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Booking to ${widget.ride['to']} cancelled successfully.',
                                ),
                                backgroundColor: const Color(0xFFE52020),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE52020),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE52020)
                                      .withOpacity(0.2),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Yes, Cancel Booking',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    // ─── Desktop/Simulator Frame ───
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
                  border: Border.all(
                      color: const Color(0xFF1A0A0A), width: 10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.65),
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



class NepalFlag extends StatelessWidget {
  final double width;
  final double height;

  const NepalFlag({
    super.key,
    this.width = 14,
    this.height = 18,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: NepalFlagPainter(),
    );
  }
}

class NepalFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDC2626) // crimson red
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF1E3A8A) // dark blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.48);
    path.lineTo(size.width * 0.28, size.height * 0.48);
    path.lineTo(size.width * 0.9, size.height * 0.95);
    path.lineTo(0, size.height * 0.95);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    final symbolPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Upper crescent moon representation
    canvas.drawCircle(
      Offset(size.width * 0.22, size.height * 0.25),
      1.2,
      symbolPaint,
    );

    // Lower sun representation
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.72),
      1.6,
      symbolPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
