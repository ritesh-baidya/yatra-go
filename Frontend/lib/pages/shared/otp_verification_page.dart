import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'turn_on_location_page.dart';
import '../passenger/passenger_verified_number_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final bool isFromSafety;

  const OtpVerificationPage({
    super.key,
    this.phoneNumber = '98XXXXXXXX',
    this.isFromSafety = false,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  final List<String> _otpDigits = List.filled(6, '');
  int _currentIndex = 0;

  // Countdown timer
  late Timer _timer;
  int _secondsRemaining = 25;

  // Animation
  bool _visible = false;
  late AnimationController _shieldAnimController;
  late Animation<double> _shieldScaleAnim;

  @override
  void initState() {
    super.initState();

    // Shield animation
    _shieldAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shieldScaleAnim = CurvedAnimation(
      parent: _shieldAnimController,
      curve: Curves.elasticOut,
    );

    // Start countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });

    // Trigger animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _visible = true);
        _shieldAnimController.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _shieldAnimController.dispose();
    super.dispose();
  }

  void _onKeyTap(String key) {
    setState(() {
      if (key == 'delete') {
        if (_currentIndex > 0) {
          _currentIndex--;
          _otpDigits[_currentIndex] = '';
        }
      } else {
        if (_currentIndex < 6) {
          _otpDigits[_currentIndex] = key;
          _currentIndex++;

          // Auto-verify when all 6 digits entered
          if (_currentIndex == 6) {
            _verifyOtp();
          }
        }
      }
    });
  }

  void _verifyOtp() {
    // Navigate to PassengerDashboard or PassengerVerifiedPage on successful verification
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        if (widget.isFromSafety) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PassengerVerifiedNumberPage(),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const TurnOnLocationPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
            (route) => false, // Remove all previous routes
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Back button
                      _buildBackButton(),

                      const SizedBox(height: 8),

                      // Shield icon with circular rings
                      _buildShieldIcon(),

                      const SizedBox(height: 4),

                      // "Verify your number"
                      _buildTitle(),

                      const SizedBox(height: 6),

                      // Subtitle with phone number
                      _buildSubtitle(),

                      const SizedBox(height: 12),

                      // OTP input boxes
                      _buildOtpBoxes(),

                      const SizedBox(height: 28),

                      // Dashed divider with temple icon
                      _buildDashedDivider(),

                      const SizedBox(height: 8),

                      // Resend OTP timer
                      _buildResendTimer(),

                      const Spacer(),

                      // ─── Custom numeric keypad ───
                      _buildNumericKeypad(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // BACK BUTTON
  // ════════════════════════════════════════════════════════════
  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          top: MediaQuery.of(context).padding.top + 12,
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE52020).withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFFE52020),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // SHIELD ICON — Red shield with checkmark + animated rings
  // ════════════════════════════════════════════════════════════
  Widget _buildShieldIcon() {
    return ScaleTransition(
      scale: _shieldScaleAnim,
      child: SizedBox(
        width: 130,
        height: 130,
        child: CustomPaint(
          painter: _ShieldRingsPainter(),
          child: Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE52020),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE52020).withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified_user,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // TITLE — "Verify your number"
  // ════════════════════════════════════════════════════════════
  Widget _buildTitle() {
    return Text(
      'Enter the code',
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  // ════════════════════════════════════════════════════════════
  // SUBTITLE — "We've sent a 6-digit OTP to +977 98XXXXXXXX"
  // ════════════════════════════════════════════════════════════
  Widget _buildSubtitle() {
    return Column(
      children: [
        Text(
          "We've sent a 6-digit OTP to",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '+977 ${widget.phoneNumber}',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // OTP INPUT BOXES — 6 boxes with red borders
  // ════════════════════════════════════════════════════════════
  Widget _buildOtpBoxes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          final bool isFilled = _otpDigits[index].isNotEmpty;
          final bool isCurrent = index == _currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 56,
            decoration: BoxDecoration(
              color: isFilled
                  ? const Color(0xFFE52020).withValues(alpha: 0.06)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrent
                    ? const Color(0xFFE52020)
                    : isFilled
                        ? const Color(0xFFE52020).withValues(alpha: 0.5)
                        : const Color(0xFFE0E0E0),
                width: isCurrent ? 2.0 : 1.5,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: const Color(0xFFE52020).withValues(alpha: 0.15),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                _otpDigits[index],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE52020),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // DASHED DIVIDER — Dashed red line with temple/mandala icon
  // ════════════════════════════════════════════════════════════
  Widget _buildDashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _DashedLinePainter(),
              size: const Size(double.infinity, 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              'assets/images/login_mandala.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: _DashedLinePainter(),
              size: const Size(double.infinity, 1),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // RESEND TIMER — Clock icon + "Resend OTP in 00:25"
  // ════════════════════════════════════════════════════════════
  Widget _buildResendTimer() {
    final String timeStr = '00:${_secondsRemaining.toString().padLeft(2, '0')}';
    final bool canResend = _secondsRemaining == 0;

    return GestureDetector(
      onTap: canResend
          ? () {
              setState(() {
                _secondsRemaining = 25;
                _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  if (_secondsRemaining > 0) {
                    setState(() => _secondsRemaining--);
                  } else {
                    timer.cancel();
                  }
                });
              });
            }
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            color:
                canResend ? const Color(0xFFE52020) : const Color(0xFF666666),
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            'Resend OTP in ',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF666666),
            ),
          ),
          Text(
            timeStr,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFE52020),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // NUMERIC KEYPAD — Custom phone-style keypad
  // ════════════════════════════════════════════════════════════
  Widget _buildNumericKeypad() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1.0,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: 1, 2, 3
                _buildKeyRow([
                  _KeyData('1', ''),
                  _KeyData('2', 'ABC'),
                  _KeyData('3', 'DEF'),
                ], showBottomBorder: true),
                // Row 2: 4, 5, 6
                _buildKeyRow([
                  _KeyData('4', 'GHI'),
                  _KeyData('5', 'JKL'),
                  _KeyData('6', 'MNO'),
                ], showBottomBorder: true),
                // Row 3: 7, 8, 9
                _buildKeyRow([
                  _KeyData('7', 'PQRS'),
                  _KeyData('8', 'TUV'),
                  _KeyData('9', 'WXYZ'),
                ], showBottomBorder: true),
                // Row 4: empty, 0, delete
                _buildBottomRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyRow(List<_KeyData> keys, {required bool showBottomBorder}) {
    return Row(
      children: List.generate(keys.length, (index) {
        final isLast = index == keys.length - 1;
        return Expanded(
          child: _buildKey(
            keys[index],
            showRightBorder: !isLast,
            showBottomBorder: showBottomBorder,
          ),
        );
      }),
    );
  }

  Widget _buildKey(_KeyData keyData,
      {required bool showRightBorder, required bool showBottomBorder}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: showRightBorder
              ? const BorderSide(color: Color(0xFFE0E0E0), width: 1.0)
              : BorderSide.none,
          bottom: showBottomBorder
              ? const BorderSide(color: Color(0xFFE0E0E0), width: 1.0)
              : BorderSide.none,
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => _onKeyTap(keyData.digit),
          child: SizedBox(
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  keyData.digit,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1D1D1D),
                  ),
                ),
                if (keyData.letters.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    keyData.letters,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8E8E8E),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        // Empty space
        Expanded(
          child: Container(
            height: 75,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
              ),
            ),
          ),
        ),
        // 0 key
        Expanded(
          child: _buildKey(
            _KeyData('0', ''),
            showRightBorder: true,
            showBottomBorder: false,
          ),
        ),
        // Delete key
        Expanded(
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => _onKeyTap('delete'),
              child: const SizedBox(
                height: 75,
                child: Center(
                  child: Icon(
                    Icons.backspace_rounded,
                    color: Color(0xFFE52020),
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
// KEY DATA MODEL
// ════════════════════════════════════════════════════════════
class _KeyData {
  final String digit;
  final String letters;

  _KeyData(this.digit, this.letters);
}

// ════════════════════════════════════════════════════════════
// SHIELD RINGS PAINTER — Concentric rings around shield icon
// ════════════════════════════════════════════════════════════
class _ShieldRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer ring (faint)
    final outerPaint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width / 2, outerPaint);

    // Middle ring
    final middlePaint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width / 2 - 10, middlePaint);

    // Inner ring
    final innerPaint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width / 2 - 22, innerPaint);

    // Decorative ring stroke
    final ringStrokePaint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, size.width / 2 - 5, ringStrokePaint);

    // Small dot decorations around the ring
    final dotPaint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (pi / 180);
      final radius = size.width / 2 - 5;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ════════════════════════════════════════════════════════════
// DASHED LINE PAINTER — Red dashed horizontal line
// ════════════════════════════════════════════════════════════
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
