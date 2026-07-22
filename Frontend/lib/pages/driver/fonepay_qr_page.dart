import 'package:flutter/material.dart';
import '../../theme/yatri_theme.dart';

class YatriFonepayQR extends StatefulWidget {
  const YatriFonepayQR({super.key});

  @override
  State<YatriFonepayQR> createState() => _YatriFonepayQRState();
}

class _YatriFonepayQRState extends State<YatriFonepayQR> {
  bool _isPaid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Payment QR Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Fonepay Logo
                      Image.asset(
                        'assets/logo/fonepay_logo.png',
                        height: 40,
                      ),
                      const SizedBox(height: 24),

                      // QR Code Container (Green theme frame)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F6EE), // light green bg
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: YatriTheme.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Mock QR Code layout
                            _buildMockQRCode(180),

                            // Center icon decoration (Yatri car or checkmark if paid)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _isPaid
                                      ? const Color(0xFF10B981)
                                      : YatriTheme.primary,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPaid
                                    ? Icons.check_circle
                                    : Icons.directions_car_rounded,
                                color: _isPaid
                                    ? const Color(0xFF10B981)
                                    : YatriTheme.primary,
                                size: 22,
                              ),
                            ),

                            // Green Overlay if paid
                            if (_isPaid)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF10B981),
                                        size: 60,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Payment Success",
                                        style: TextStyle(
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Payment details
                      _buildDetailRow("Driver Name", "Ram Kumar"),
                      const SizedBox(height: 10),
                      _buildDetailRow("Vehicle No.", "BA 2 PA 9842"),
                      const SizedBox(height: 10),
                      _buildDetailRow("Total Fare", "Rs. 2,100", isPrice: true),

                      const Divider(
                          height: 32, color: Color(0xFFF1F5F9), thickness: 1.5),

                      // Status Widget
                      const SizedBox.shrink(),
                      // Status indicators removed per user request
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (_isPaid)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isPaid = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Reset Payment Status",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isPrice ? const Color(0xFF0F172A) : const Color(0xFF334155),
            fontSize: isPrice ? 16 : 14,
            fontWeight: isPrice ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMockQRCode(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.transparent,
      child: CustomPaint(
        painter: QRCodePainter(color: YatriTheme.primary),
      ),
    );
  }
}

class QRCodePainter extends CustomPainter {
  final Color color;
  QRCodePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double finderSize = size.width * 0.28;

    _drawFinderPattern(canvas, const Offset(0, 0), finderSize);
    _drawFinderPattern(canvas, Offset(size.width - finderSize, 0), finderSize);
    _drawFinderPattern(canvas, Offset(0, size.height - finderSize), finderSize);

    final pixelSize = size.width / 21;

    for (int r = 0; r < 21; r++) {
      for (int c = 0; c < 21; c++) {
        if ((r < 7 && c < 7) || (r < 7 && c >= 14) || (r >= 14 && c < 7)) {
          continue;
        }
        if (r >= 9 && r <= 11 && c >= 9 && c <= 11) {
          continue;
        }

        final hash = (r * 37 + c * 17) % 5;
        if (hash == 1 || hash == 3) {
          canvas.drawRect(
            Rect.fromLTWH(
                c * pixelSize, r * pixelSize, pixelSize - 0.5, pixelSize - 0.5),
            paint,
          );
        }
      }
    }
  }

  void _drawFinderPattern(Canvas canvas, Offset offset, double size) {
    final paintOuter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final paintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pixel = size / 7;

    canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, size, size), paintOuter);
    canvas.drawRect(
        Rect.fromLTWH(offset.dx + pixel, offset.dy + pixel, size - pixel * 2,
            size - pixel * 2),
        paintInner);
    canvas.drawRect(
        Rect.fromLTWH(offset.dx + pixel * 2, offset.dy + pixel * 2,
            size - pixel * 4, size - pixel * 4),
        paintOuter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
