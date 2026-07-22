import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_calling_driver_page.dart';
import 'passenger_chat_detail_page.dart';

class PassengerRateRiderPage extends StatefulWidget {
  const PassengerRateRiderPage({super.key});

  @override
  State<PassengerRateRiderPage> createState() => _PassengerRateRiderPageState();
}

class _PassengerRateRiderPageState extends State<PassengerRateRiderPage> {
  int _selectedRating = 4; // Default 4 stars as shown in image
  final TextEditingController _reviewController = TextEditingController();
  final Set<String> _selectedTags = {};

  static const Color _redAccent = Color(0xFFE52020);
  static const Color _darkText = Color(0xFF1E293B);
  static const Color _subtitleText = Color(0xFF64748B);

  final List<Map<String, dynamic>> _quickTags = [
    {'label': 'Safe Driving', 'icon': Icons.verified_user_outlined},
    {'label': 'On Time', 'icon': Icons.access_time_rounded},
    {'label': 'Polite', 'icon': Icons.sentiment_satisfied_alt_rounded},
    {'label': 'Clean Vehicle', 'icon': Icons.directions_car_rounded},
  ];

  String get _ratingLabel {
    switch (_selectedRating) {
      case 1:
        return 'Very Bad';
      case 2:
        return 'Bad';
      case 3:
        return 'Average';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ─── Header with illustration ───
                  _buildHeader(context),

                  const SizedBox(height: 16),

                  // ─── Driver Info Card ───
                  _buildDriverInfoCard(),

                  const SizedBox(height: 12),

                  // ─── Route Details Card ───
                  _buildRouteDetailsCard(),

                  const SizedBox(height: 12),

                  // ─── Star Rating Section ───
                  _buildRatingSection(),

                  const SizedBox(height: 12),

                  // ─── Review Text Area ───
                  _buildReviewSection(),

                  const SizedBox(height: 16),

                  // ─── Quick Tags ───
                  _buildQuickTags(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ─── Submit Button (pinned at bottom) ───
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // HEADER — Green checkmark, route illustration, title
  // ════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // White background with subtle bottom curve
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            bottom: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Back button row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: _redAccent,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Route illustration with green checkmark
              SizedBox(
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dashed route line (left to right)
                    CustomPaint(
                      size: const Size(260, 60),
                      painter: _RouteDashedPainter(),
                    ),
                    // Left location pin
                    const Positioned(
                      left: 60,
                      top: 28,
                      child: Icon(
                        Icons.location_on,
                        color: _redAccent,
                        size: 22,
                      ),
                    ),
                    // Right location pin
                    const Positioned(
                      right: 60,
                      top: 28,
                      child: Icon(
                        Icons.location_on,
                        color: _redAccent,
                        size: 22,
                      ),
                    ),
                    // Center green checkmark circle
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF16A34A).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                'Rate Driver',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _darkText,
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Your feedback helps us improve your next rides',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _subtitleText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════
  // DRIVER INFO CARD
  // ════════════════════════════════════════════════════
  Widget _buildDriverInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Driver avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/ram_kumar_avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF94A3B8),
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Driver details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ram Kumar',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFE52020), size: 16),
                    const SizedBox(width: 3),
                    Text(
                      '4.8',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _darkText,
                      ),
                    ),
                    Text(
                      '  ·  128 rides',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _subtitleText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Hyundai i20  ·  White',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _subtitleText,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons (call + chat)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCircleActionButton(
                icon: Icons.phone_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PassengerCallingDriverPage(
                        driverName: 'Sujan Thapa',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              _buildCircleActionButton(
                icon: Icons.chat_bubble_outline_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PassengerChatDetailPage(
                        driverName: 'Sujan Thapa',
                        avatarUrl: 'assets/images/sujan_thapa_avatar.png',
                        initials: 'ST',
                        isOnline: true,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFD4D4), width: 1.5),
        ),
        child: Icon(
          icon,
          color: _redAccent,
          size: 20,
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // ROUTE DETAILS CARD
  // ════════════════════════════════════════════════════
  Widget _buildRouteDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Pickup/Dropoff with vertical indicator
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pickup
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filled red location pin
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.location_on,
                        color: _redAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _redAccent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kathmandu',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _darkText,
                          ),
                        ),
                        Text(
                          'New Bus Park',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: _subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Vertical dotted line
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: List.generate(4, (index) => Container(
                      width: 2,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    )),
                  ),
                ),

                // Drop-off
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Outlined red location pin
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _redAccent, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.circle,
                            color: Color(0xFFE52020),
                            size: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Drop-off',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _redAccent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pokhara',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _darkText,
                          ),
                        ),
                        Text(
                          'Lakeside',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: _subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right: Date and Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: _redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sun, 25 May',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _darkText,
                          ),
                        ),
                        Text(
                          '7:00 AM',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _darkText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // STAR RATING SECTION
  // ════════════════════════════════════════════════════
  Widget _buildRatingSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'How was your ride?',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 20),
          // Star row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= _selectedRating;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = starIndex;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isSelected ? _redAccent : const Color(0xFFCBD5E1),
                    size: 44,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          // Rating label
          Text(
            _ratingLabel,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _redAccent,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // REVIEW TEXT AREA
  // ════════════════════════════════════════════════════
  Widget _buildReviewSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a review (optional)',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _reviewController,
                  maxLines: 3,
                  maxLength: 500,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Share your experience with this driver...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    counterText: '', // Hide default counter
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _darkText,
                  ),
                ),
                // Character count
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${_reviewController.text.length}/500',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // QUICK TAGS
  // ════════════════════════════════════════════════════
  Widget _buildQuickTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _quickTags.map((tag) {
          final label = tag['label'] as String;
          final icon = tag['icon'] as IconData;
          final isSelected = _selectedTags.contains(label);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedTags.remove(label);
                } else {
                  _selectedTags.add(label);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFF1F1) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? _redAccent : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? _redAccent : const Color(0xFF94A3B8),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? _redAccent : _darkText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // SUBMIT BUTTON
  // ════════════════════════════════════════════════════
  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Handle submit
          Navigator.pop(context);
        },
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: _redAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _redAccent.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Submit Review',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// Custom painter for dashed route line in header
// ════════════════════════════════════════════════════
class _RouteDashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Left arc curving up to center
    path.moveTo(centerX - 100, centerY + 10);
    path.quadraticBezierTo(centerX - 50, centerY - 30, centerX, centerY - 10);

    // Right arc curving down from center
    path.quadraticBezierTo(centerX + 50, centerY - 30, centerX + 100, centerY + 10);

    // Draw dashed path
    final dashPath = _createDashedPath(path, 5, 4);
    canvas.drawPath(dashPath, paint);

    // Draw small red dots along the path
    final dotPaint = Paint()
      ..color = const Color(0xFFE52020).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    for (final metric in path.computeMetrics()) {
      final length = metric.length;
      for (double i = 0; i < length; i += length / 6) {
        final tangent = metric.getTangentForOffset(i);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 2.5, dotPaint);
        }
      }
    }
  }

  Path _createDashedPath(Path source, double dashLength, double gapLength) {
    final dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0, metric.length).toDouble();
        dashedPath.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += dashLength + gapLength;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
