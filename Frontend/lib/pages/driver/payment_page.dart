import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum PaymentMethod { esewa, khalti, card }

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod _selectedMethod = PaymentMethod.esewa;

  void _processPayment() {
    String methodText = '';
    switch (_selectedMethod) {
      case PaymentMethod.esewa:
        methodText = 'eSewa';
        break;
      case PaymentMethod.khalti:
        methodText = 'Khalti';
        break;
      case PaymentMethod.card:
        methodText = 'Debit/Credit Card';
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFECFDF5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF10B981),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Payment Successful',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your payment of Rs. 700 via $methodText has been processed successfully.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to the dashboard or pop pages
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Back to Home',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 480;

    // Responsive scale factor (reference: 375 width)
    final double effectiveWidth = isDesktop ? 380.0 : screenWidth;
    final double s = (effectiveWidth / 375).clamp(0.8, 1.3);
    final double vs = (screenHeight / 812).clamp(0.75, 1.3); // vertical scale

    // Account for system navigation bar (gesture bar, 3-button nav, etc.)
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    Widget mainContent = Scaffold(
      backgroundColor: const Color(0xFFFCFAF9),
      body: Stack(
        children: [
          // ─── Top Background Illustration ───
          Positioned(
            top: 80 * vs,
            left: 0,
            right: 0,
            height: 100 * vs,
            child: Image.asset(
              'assets/images/payment_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // ─── Scrollable Content ───
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ─── Header Top Bar ───
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0 * s, vertical: 8.0 * vs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Circular Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 44 * s,
                          height: 44 * s,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10 * s,
                                offset: Offset(0, 4 * s),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: const Color(0xFFDC2626),
                            size: 22 * s,
                          ),
                        ),
                      ),
                      // Payment Title
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Payment',
                            style: GoogleFonts.inter(
                              fontSize: 26 * s,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFE52020),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32 * s,
                                height: 1.2,
                                color: const Color(0xFFE52020),
                              ),
                              SizedBox(width: 8 * s),
                              Text(
                                '❖',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFE52020),
                                  fontSize: 12 * s,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8 * s),
                              Container(
                                width: 32 * s,
                                height: 1.2,
                                color: const Color(0xFFE52020),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Right Pin Placeholder for symmetry
                      SizedBox(
                        width: 44 * s,
                        height: 44 * s,
                      ),
                    ],
                  ),
                ),

                // Spacer to skip the background route illustration path
                SizedBox(height: 75 * vs),

                // Card and lists scroll section
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                        left: 20.0 * s, right: 20.0 * s, bottom: (80 + bottomInset) * vs),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Total Fare Card ───
                        Container(
                          padding: EdgeInsets.all(20.0 * s),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24 * s),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 16 * s,
                                offset: Offset(0, 8 * s),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFF1F5F9),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Leading Route Icon
                                  Container(
                                    width: 48 * s,
                                    height: 48 * s,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFECEB),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomPaint(
                                      painter: RouteIconPainter(),
                                    ),
                                  ),
                                  SizedBox(width: 16 * s),
                                  // Destination Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Fare',
                                          style: GoogleFonts.inter(
                                            fontSize: 13 * s,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF718096),
                                          ),
                                        ),
                                        SizedBox(height: 4 * vs),
                                        Text(
                                          'Kathmandu → Pokhara',
                                          style: GoogleFonts.inter(
                                            fontSize: 18 * s,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF1E293B),
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        SizedBox(height: 4 * vs),
                                        Text(
                                          'Sun, 25 May • 7:00 AM',
                                          style: GoogleFonts.inter(
                                            fontSize: 13 * s,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF718096),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20 * vs),
                              // Bottom Seat count and price
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '1 Seat',
                                    style: GoogleFonts.inter(
                                      fontSize: 15 * s,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4A5568),
                                    ),
                                  ),
                                  Text(
                                    'Rs. 700',
                                    style: GoogleFonts.inter(
                                      fontSize: 18 * s,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFDC2626),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24 * vs),

                        // ─── Payment Method Header ───
                        Row(
                          children: [
                            Text(
                              'Payment Method',
                              style: GoogleFonts.inter(
                                fontSize: 16 * s,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(width: 12 * s),
                            Expanded(
                              child: Container(
                                height: 1.2,
                                color: const Color(0xFFFFC5C5),
                              ),
                            ),
                            SizedBox(width: 8 * s),
                            _buildDiamondFlower(),
                            SizedBox(width: 8 * s),
                            Expanded(
                              child: Container(
                                height: 1.2,
                                color: const Color(0xFFFFC5C5),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16 * vs),

                        // ─── Payment Options Card ───
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24 * s),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 16 * s,
                                offset: Offset(0, 8 * s),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFF1F5F9),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // eSewa option
                              _buildPaymentOptionRow(
                                method: PaymentMethod.esewa,
                                logo: SizedBox(
                                  width: 40 * s,
                                  height: 40 * s,
                                  child: Image.asset(
                                    'assets/logo/esewa_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                title: 'eSewa',
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0 * s),
                                child: const DashedDivider(),
                              ),
                              // Khalti option
                              _buildPaymentOptionRow(
                                method: PaymentMethod.khalti,
                                logo: SizedBox(
                                  width: 46 * s,
                                  height: 46 * s,
                                  child: Image.asset(
                                    'assets/logo/khalti_logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                title: 'Khalti',
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
          ),

          // ─── Bottom Pay Button ───
          Positioned(
            left: 20 * s,
            right: 20 * s,
            bottom: 16 + bottomInset,
            child: GestureDetector(
              onTap: _processPayment,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 60 * vs,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626), // Solid red
                  borderRadius: BorderRadius.circular(30 * s),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.25),
                      blurRadius: 16 * s,
                      offset: Offset(0, 8 * s),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pay Text
                    Text(
                      'Pay Rs. 700',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18 * s,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 10 * s),
                    // Arrow Right icon
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 22 * s,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // ─── Desktop/Simulator Frame Layout ───
    if (isDesktop) {
      final clampedHeight = screenHeight > 940 ? 900.0 : screenHeight - 40.0;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Dark elegant backdrop
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A0A0A),
                        Color(0xFF2D1515),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Simulator center card
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

  // ─── Helper: Payment Option Row Builder ───
  Widget _buildPaymentOptionRow({
    required PaymentMethod method,
    required Widget logo,
    required String title,
    String? subtitle,
  }) {
    final isSelected = _selectedMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            logo,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Custom Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFDC2626)
                      : const Color(0xFFCBD5E1),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDC2626),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helper: Diamond Flower Header Widget ───
  Widget _buildDiamondFlower() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: 45 * 3.1415927 / 180,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: const Color(0xFFDC2626),
                width: 2.0,
              ),
            ),
          ),
        ),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFFDC2626),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

// ─── Painter: Route Icon ───
class RouteIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final pinPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final startOffset = Offset(w * 0.35, h * 0.65);
    final endOffset = Offset(w * 0.65, h * 0.35);

    final path = Path();
    path.moveTo(startOffset.dx, startOffset.dy);
    path.cubicTo(
      w * 0.3,
      h * 0.45,
      w * 0.7,
      h * 0.55,
      endOffset.dx,
      endOffset.dy,
    );
    canvas.drawPath(path, linePaint);

    canvas.drawCircle(startOffset, 4, pinPaint);
    canvas.drawCircle(endOffset, 4, pinPaint);

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(startOffset, 1.5, whitePaint);
    canvas.drawCircle(endOffset, 1.5, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Painter: Dashed Rectangle Border ───
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dash = 6.0,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final len = (distance + dash < pathMetric.length)
            ? dash
            : pathMetric.length - distance;
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + len),
          paint,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Painter: Cityscape faint illustration ───
class CityscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFCA5A5).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final fillPaint = Paint()
      ..color = const Color(0xFFFFF5F5).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Draw faint curve line for hills/routes
    final curvePath = Path();
    curvePath.moveTo(0, h * 0.95);
    curvePath.quadraticBezierTo(w * 0.35, h * 0.35, w * 0.7, h * 0.85);
    curvePath.quadraticBezierTo(w * 0.85, h * 0.98, w, h * 0.55);
    canvas.drawPath(curvePath, paint);

    // Draw simple cityscape buildings
    final buildingsPath = Path();
    buildingsPath.addRect(Rect.fromLTWH(w * 0.45, h * 0.55, 12, h * 0.45));
    buildingsPath.addRect(Rect.fromLTWH(w * 0.56, h * 0.45, 16, h * 0.55));
    buildingsPath.addRect(Rect.fromLTWH(w * 0.72, h * 0.35, 10, h * 0.65));
    buildingsPath.addRect(Rect.fromLTWH(w * 0.82, h * 0.50, 14, h * 0.50));

    canvas.drawPath(buildingsPath, fillPaint);
    canvas.drawPath(buildingsPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Painter: Coupon tag with percentage ───
class CouponTagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Coupon ticket path (angled with punch holes)
    final path = Path();
    path.moveTo(w * 0.15, h * 0.4);
    path.lineTo(w * 0.4, h * 0.15);
    path.lineTo(w * 0.85, h * 0.6);
    path.lineTo(w * 0.6, h * 0.85);
    path.close();

    canvas.drawPath(path, paint);

    // Sparkles or outline details
    final path2 = Path();
    path2.moveTo(w * 0.10, h * 0.5);
    path2.lineTo(w * 0.35, h * 0.25);
    canvas.drawPath(path2, outlinePaint);

    // Draw percentage text inside or simple icon symbol
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '%',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(w * 0.36, h * 0.32),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Custom Dotted/Dashed Divider ───
class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashGap;

  const DashedDivider({
    super.key,
    this.height = 1.0,
    this.color = const Color(0xFFE2E8F0),
    this.dashWidth = 4.0,
    this.dashGap = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashGap)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
