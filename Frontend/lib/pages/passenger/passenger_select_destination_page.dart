import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassengerSelectDestinationPage extends StatefulWidget {
  final bool isPickup;
  final String initialAddress;

  const PassengerSelectDestinationPage({
    super.key,
    this.isPickup = false,
    this.initialAddress = '',
  });

  @override
  State<PassengerSelectDestinationPage> createState() =>
      _PassengerSelectDestinationPageState();
}

class _PassengerSelectDestinationPageState extends State<PassengerSelectDestinationPage> {
  Offset _mapOffset = Offset.zero;
  Offset _pinOffset = Offset.zero;
  String _selectedTitle = 'Sunrise Cafe & Bakery';
  String _selectedSubtitle = 'Lazimpat, Kathmandu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: Stack(
        children: [
          // ─── 1. Map Canvas Background & Gestures ───
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _mapOffset += details.delta;
                });
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MapCanvasPainter(offset: _mapOffset),
                    ),
                  ),
                  // Map Landmark Pins
                  _buildMapLandmark(
                    top: 140 + _mapOffset.dy,
                    left: 230 + _mapOffset.dx,
                    title: 'Green Palm Resort',
                    isRed: true,
                  ),
                  _buildMapLandmark(
                    top: 230 + _mapOffset.dy,
                    left: 170 + _mapOffset.dx,
                    title: 'Nepal Youth Society',
                    isRed: false,
                  ),
                  _buildMapLandmark(
                    top: 300 + _mapOffset.dy,
                    left: 70 + _mapOffset.dx,
                    title: 'Nawa Upakar Nepal\nRehabilitation Center',
                    isRed: false,
                  ),
                  _buildMapLandmark(
                    top: 480 + _mapOffset.dy,
                    left: 260 + _mapOffset.dx,
                    title: 'Saraswati\nGovernment\nSchool',
                    isRed: false,
                  ),
                ],
              ),
            ),
          ),

          // ─── 2. Center Pin & Callout Box Assembly (Moveable) ───
          Center(
            child: Transform.translate(
              offset: _pinOffset,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _pinOffset += details.delta;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  // Callout Box ("4 min • Rs.159")
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.sports_score_rounded,
                            color: Color(0xFFE52020),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Estimated ride time',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '4 min ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '• ',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFE52020),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Rs.159',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0F172A),
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

                  // Black Connecting Stem with Top and Bottom End Dots
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2.5,
                    height: 24,
                    color: const Color(0xFF0F172A),
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

          // ─── 3. Top Header Bar ───
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFFE52020),
                        size: 28,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Move the map',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.isPickup
                              ? 'Drag to set your pickup'
                              : 'Drag to set your destination',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
          ),

          // ─── 4. Bottom Right Floating Target Button ───
          Positioned(
            right: 20,
            bottom: 325,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _mapOffset = Offset.zero;
                  _pinOffset = Offset.zero;
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.gps_fixed_rounded,
                  color: Color(0xFFE52020),
                  size: 22,
                ),
              ),
            ),
          ),

          // ─── 5. Bottom Sheet Card (Draggable Content) ───
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.14,
            maxChildSize: 0.38,
            snap: true,
            snapSizes: const [0.14, 0.38],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag indicator handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Destination Header Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.sports_score_rounded,
                                color: Color(0xFFE52020),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.isPickup ? 'PICKUP' : 'DESTINATION',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFE52020),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedTitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedSubtitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFF1F5F9), height: 1),
                        const SizedBox(height: 16),

                        // Metrics Row (Estimated Time & Estimated Fare)
                        Row(
                          children: [
                            // Estimated Time
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1F1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.access_time_rounded,
                                      color: Color(0xFFE52020),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ESTIMATED TIME',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF64748B),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '4 minute',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Vertical Divider
                            Container(
                              width: 1,
                              height: 28,
                              color: const Color(0xFFF1F5F9),
                            ),
                            const SizedBox(width: 16),

                            // Estimated Fare
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1F1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: Color(0xFFE52020),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ESTIMATED FARE',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF64748B),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rs.159',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Horizontal Dashed Line
                        CustomPaint(
                          size: const Size(double.infinity, 1),
                          painter: _DashedLinePainter(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ─── 6. Fixed Confirm Destination Button ───
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'title': _selectedTitle,
                      'address': _selectedSubtitle,
                      'fullAddress':
                          '$_selectedTitle, $_selectedSubtitle',
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE52020),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.isPickup
                        ? 'Confirm Pickup'
                        : 'Confirm Destination',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLandmark({
    required double top,
    required double left,
    required String title,
    required bool isRed,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: isRed ? const Color(0xFFE52020) : const Color(0xFF64748B),
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isRed ? FontWeight.w700 : FontWeight.w600,
              color: isRed ? const Color(0xFFE52020) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Custom Painter for Light Vector Map ───
class _MapCanvasPainter extends CustomPainter {
  final Offset offset;

  _MapCanvasPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF4F5F7);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final thinRoadPaint = Paint()
      ..color = const Color(0xFFEBECEF)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final buildingPaint = Paint()
      ..color = const Color(0xFFEAEAED).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Draw building block shapes
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(40, 100, 100, 70), const Radius.circular(8)),
      buildingPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(180, 80, 80, 120), const Radius.circular(8)),
      buildingPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(60, 260, 120, 90), const Radius.circular(8)),
      buildingPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(220, 240, 90, 140), const Radius.circular(8)),
      buildingPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(80, 420, 140, 100), const Radius.circular(8)),
      buildingPaint,
    );

    // Draw Main Roads
    final mainRoadPath = Path()
      ..moveTo(-50, 120)
      ..cubicTo(100, 180, 250, 60, 420, 140)
      ..cubicTo(320, 300, 200, 450, 150, 600);
    canvas.drawPath(mainRoadPath, roadPaint);

    final branchRoadPath = Path()
      ..moveTo(220, 110)
      ..quadraticBezierTo(200, 300, 380, 420)
      ..quadraticBezierTo(100, 500, -20, 480);
    canvas.drawPath(branchRoadPath, roadPaint);

    // Draw Secondary Roads
    final secPath = Path()
      ..moveTo(80, -20)
      ..lineTo(140, 350)
      ..lineTo(350, 320);
    canvas.drawPath(secPath, thinRoadPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) =>
      oldDelegate.offset != offset;
}

// ─── Dashed Line Painter ───
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    double dashWidth = 5, dashSpace = 4, startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
