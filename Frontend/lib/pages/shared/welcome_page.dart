import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  Timer? _deleteTimer;
  bool _visible = false;
  bool _showKeypad = false;

  @override
  void initState() {
    super.initState();
    // Listen to focus changes on the phone field
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
      setState(() => _showKeypad = _phoneFocusNode.hasFocus);
    });
    // Trigger fade-in after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  void dispose() {
    _deleteTimer?.cancel();
    _phoneFocusNode.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _startDeleting() {
    _deleteTimer?.cancel();
    _onKeyTap('delete');
    
    // 350ms delay before start repeating
    _deleteTimer = Timer(const Duration(milliseconds: 350), () {
      _deleteTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_phoneController.text.isNotEmpty) {
          _onKeyTap('delete');
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _stopDeleting() {
    _deleteTimer?.cancel();
    _deleteTimer = null;
  }

  void _onSendOtp() {
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid 10-digit mobile number.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFE52020),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final phone = _phoneController.text;
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            OtpVerificationPage(phoneNumber: phone),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _onKeyTap(String key) {
    setState(() {
      if (key == 'delete') {
        if (_phoneController.text.isNotEmpty) {
          _phoneController.text = _phoneController.text
              .substring(0, _phoneController.text.length - 1);
        }
      } else {
        if (_phoneController.text.length < 10) {
          _phoneController.text += key;
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
        duration: const Duration(milliseconds: 800),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Top hero section: back button + welcome text + car image ───
                      _buildHeroSection(context),

                      // ─── Mobile number input ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                        child: _buildPhoneInputSection(),
                      ),

                      // ─── Send OTP Button ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                        child: _buildSendOtpButton(),
                      ),

                      // ─── Terms & Conditions ───
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: _buildTermsSection(),
                      ),

                      const Spacer(),

                      // ─── Custom numeric keypad (only when phone field focused) ───
                      if (_showKeypad)
                        _buildNumericKeypad()
                      else
                        _buildBottomIllustration(),
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
  // HERO SECTION — Back button, Welcome to Yatri, car image
  // ════════════════════════════════════════════════════════════
  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: Stack(
        children: [
          // ── Car + Nepal illustration on the right side ──
          Positioned(
            right: -20,
            top: 30,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.65,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.75, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/login_bg.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // ── Back button (top-left) ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
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

          // ── Welcome text overlay on the left ──
          Positioned(
            left: 24,
            top: MediaQuery.of(context).padding.top + 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                Text(
                  'Yatri',
                  style: GoogleFonts.poppins(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE52020),
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your ride, your way.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Get moving with ',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                    Text(
                      'Yatri.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE52020),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // PHONE INPUT SECTION — Country code + phone number
  // ════════════════════════════════════════════════════════════
  Widget _buildPhoneInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE52020).withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Country code section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '+977',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF666666),
                      size: 20,
                    ),
                  ],
                ),
              ),
              // Vertical divider
              Container(
                width: 1,
                height: 28,
                color: const Color(0xFFE0E0E0),
              ),
              // Phone number input
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  readOnly: true,
                  showCursor: true,
                  keyboardType: TextInputType.none,
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1A1A1A),
                  ),
                  decoration: InputDecoration(
                    hintText: '98XXXXXXXX',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFBBBBBB),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
              // Phone icon
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.phone,
                  color: const Color(0xFFE52020),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // SEND OTP BUTTON
  // ════════════════════════════════════════════════════════════
  Widget _buildSendOtpButton() {
    return GestureDetector(
      onTap: _onSendOtp,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE52020), Color(0xFFCC1A1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE52020).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(width: 40), // balance the arrow on the right
            Text(
              'Send OTP',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // TERMS & CONDITIONS
  // ════════════════════════════════════════════════════════════
  Widget _buildTermsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              color: const Color(0xFFE52020),
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              'By continuing, you agree to our',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terms & Conditions',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE52020),
              ),
            ),
            Text(
              ' and ',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
            ),
            Text(
              'Privacy Policy',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE52020),
              ),
            ),
          ],
        ),
      ],
    );
  }



  // ════════════════════════════════════════════════════════════
  // BOTTOM ILLUSTRATION — City skyline with bridge, car, and colored bar
  // ════════════════════════════════════════════════════════════
  Widget _buildBottomIllustration() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // City skyline illustration
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.0),
                Colors.white.withValues(alpha: 0.3),
                Colors.white,
              ],
              stops: const [0.0, 0.15, 0.45],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            'assets/images/login_bottom_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 180,
          ),
        ),
        // Removed decorative yellow line that was visible at the bottom
      ],
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => _startDeleting(),
              onTapUp: (_) => _stopDeleting(),
              onTapCancel: () => _stopDeleting(),
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

class _KeyData {
  final String digit;
  final String letters;

  _KeyData(this.digit, this.letters);
}

class _YatriKnotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE52020)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // Draw two overlapping squares to resemble a stylized knot
    final double s = size.width * 0.6;
    final Offset center = Offset(size.width / 2, size.height / 2);
    // First square (axis-aligned)
    final Path path = Path();
    path.addRect(Rect.fromCenter(center: center, width: s, height: s));
    // Second square rotated 45°
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(45 * 3.1415927 / 180);
    canvas.translate(-center.dx, -center.dy);
    path.addRect(Rect.fromCenter(center: center, width: s, height: s));
    canvas.restore();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
