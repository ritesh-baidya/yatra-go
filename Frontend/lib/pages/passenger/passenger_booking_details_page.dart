import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_booking_confirmed_page.dart';
import 'passenger_waiting_driver_response.dart';
import 'package:intl/intl.dart';

class NepalFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.85, h * 0.45)
      ..lineTo(w * 0.25, h * 0.5)
      ..lineTo(w * 0.95, h * 0.95)
      ..lineTo(0, h * 0.95)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    double startY = 0;
    const double dashHeight = 4;
    const double dashSpace = 4;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CheckeredFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // flagpole on the left
    final polePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // draw pole
    canvas.drawLine(const Offset(2, 0), Offset(2, size.height), polePaint);

    final double flagWidth = size.width - 4;
    final double flagHeight = size.height * 0.7;

    final int cols = 4;
    final int rows = 3;
    final double cellW = flagWidth / cols;
    final double cellH = flagHeight / rows;

    final blackPaint = Paint()
      ..color = const Color(0xFF111827)
      ..style = PaintingStyle.fill;
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final rect = Rect.fromLTWH(2 + c * cellW, r * cellH, cellW, cellH);
        final paint = (r + c) % 2 == 0 ? blackPaint : whitePaint;
        canvas.drawRect(rect, paint);
      }
    }

    // Border around flag
    final borderPaint = Paint()
      ..color = const Color(0xFF111827)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawRect(Rect.fromLTWH(2, 0, flagWidth, flagHeight), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RideDetailsPage extends StatefulWidget {
  final String driverName;
  final String driverInitials;
  final double driverRating;
  final int totalRides;
  final String pickupLocation;
  final String dropoffLocation;
  final String estimatedDuration;
  final int pricePerSeat;
  final int availableSeats;
  final List<String> amenities;

  const RideDetailsPage({
    super.key,
    this.driverName = 'Ram Kumar',
    this.driverInitials = 'RK',
    this.driverRating = 4.8,
    this.totalRides = 128,
    this.pickupLocation = 'Gongabu, Kathmandu',
    this.dropoffLocation = 'Lakeside, Pokhara',
    this.estimatedDuration = '5 hr',
    this.pricePerSeat = 700,
    this.availableSeats = 3,
    this.amenities = const ['AC', 'Music', 'Charger', 'No Smoking'],
  });

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  late int _selectedSeats;
  // Prevent coupon TextField from auto-focusing and opening keyboard on load
  final FocusNode _couponFocusNode = FocusNode();
  final TextEditingController _couponController = TextEditingController();
  bool _isCouponApplied = false;

  @override
  void initState() {
    super.initState();
    // Default to 2 if availableSeats >= 2, else availableSeats
    _selectedSeats = widget.availableSeats >= 2 ? 2 : widget.availableSeats;
    if (_selectedSeats <= 0) _selectedSeats = 1;
    // Ensure keyboard does NOT open on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _couponFocusNode.unfocus();
    });
  }

  @override
  void dispose() {
    _couponFocusNode.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), // Soft grey background
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App Bar ──
            _buildAppBar(),
            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    // ── 1. Driver Card ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildDriverCard(),
                    ),
                    const SizedBox(height: 6),
                    // ── 2. Route Card ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildRouteCard(),
                    ),
                    const SizedBox(height: 6),
                    // ── 3. Trip Info & Seat Selector Card ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildTripInfoCard(),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
                            ),
                            _buildSeatSelector(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // ── 4. Coupon Card ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildCouponCard(),
                    ),
                    const SizedBox(height: 6),
                    // ── 4b. Price Details Card ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPriceDetailsCard(),
                    ),
                    const SizedBox(height: 6),
                    // ── 5. Amenities ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildAmenities(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // ── Book Button ──
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFFE52020),
                    size: 32,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Title
              Text(
                'Booking Details',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Red line — diamond — red line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 40, height: 2, color: const Color(0xFFE52020)),
              const SizedBox(width: 8),
              Transform.rotate(
                angle: 0.785398, // 45 degrees
                child: Container(
                  width: 6,
                  height: 6,
                  color: const Color(0xFFE52020),
                ),
              ),
              const SizedBox(width: 8),
              Container(width: 40, height: 2, color: const Color(0xFFE52020)),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // DRIVER CARD
  // ═══════════════════════════════════════════
  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with green dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ram_kumar_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF22C55E),
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Name and Verified Driver
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.driverName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: Color(0xFF22C55E),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified Driver',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Row 2: Rating & Rides
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFE52020), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      widget.driverRating.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '•',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.totalRides} rides',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Row 3: Vehicle Specs and License Plate
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      // Car Info
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.directions_car_filled_outlined,
                            color: Color(0xFF111827),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Hyundai i20',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      // Color Info
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD1D5DB),
                                width: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'White',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // License Plate Box
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFD1D5DB),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomPaint(
                              size: const Size(10, 12),
                              painter: NepalFlagPainter(),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'BA 01 JA 1234',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF111827),
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
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // ROUTE CARD
  // ═══════════════════════════════════════════
  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SizedBox(height: 4), // Align with top of text
              const Icon(
                Icons.directions_walk_rounded,
                color: Color(0xFF111827),
                size: 24,
              ),
              const SizedBox(height: 6),
              // Dotted line
              CustomPaint(
                size: const Size(2, 36),
                painter: DottedLinePainter(),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 20,
                height: 24,
                child: CustomPaint(
                  painter: CheckeredFlagPainter(),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PICKUP',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF22C55E),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.pickupLocation,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'DESTINATION',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE52020),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.dropoffLocation,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // TRIP INFO (3-column)
  // ═══════════════════════════════════════════
  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          // Duration
          Expanded(
            child: _buildInfoColumn(
              icon: Icons.access_time_rounded,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF1F2937),
              value: widget.estimatedDuration,
              label: 'Est. Duration',
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          // Price
          Expanded(
            child: _buildInfoColumn(
              icon: Icons.account_balance_wallet_outlined,
              iconBgColor: const Color(0xFFE2F0D9),
              iconColor: const Color(0xFF1F2937),
              value: 'Rs. ${widget.pricePerSeat * _selectedSeats}',
              label: _selectedSeats > 1 ? 'Total price' : 'Price per person',
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          // Seats
          Expanded(
            child: _buildInfoColumn(
              icon: Icons.airline_seat_recline_normal_rounded,
              iconBgColor: const Color(0xFFF2E9FA),
              iconColor: const Color(0xFF1F2937),
              value: '$_selectedSeats / ${widget.availableSeats}',
              label: 'Seats selected',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  // SEAT SELECTOR
  // ═══════════════════════════════════════════
  Widget _buildSeatSelector() {
    final maxSeats = widget.availableSeats;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.keyboard_double_arrow_right_rounded,
                color: Color(0xFFE52020),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Select Number of Seats',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.keyboard_double_arrow_left_rounded,
                color: Color(0xFFE52020),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minus button
              GestureDetector(
                onTap: () {
                  if (_selectedSeats > 1) {
                    setState(() => _selectedSeats--);
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.remove,
                      color: Color(0xFFE52020),
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Count
              Container(
                width: 120,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$_selectedSeats',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Plus button
              GestureDetector(
                onTap: () {
                  if (_selectedSeats < maxSeats) {
                    setState(() => _selectedSeats++);
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Color(0xFFE52020),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Maximum $maxSeats seats',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // COUPON CARD
  // ═══════════════════════════════════════════
  Widget _buildCouponCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.discount_outlined,
            color: Color(0xFFE52020),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _couponController,
              focusNode: _couponFocusNode,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Enter coupon code',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.inter(
                color: const Color(0xFF111827),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: 24,
            width: 1,
            color: const Color(0xFFE5E7EB),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          GestureDetector(
            onTap: () {
              final code = _couponController.text.trim();
              if (code.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please enter a coupon code',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFFEF4444),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } else {
                setState(() {
                  _isCouponApplied = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Coupon applied successfully!',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFF22C55E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE52020),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Apply',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // PRICE DETAILS CARD
  // ═══════════════════════════════════════════
  Widget _buildPriceDetailsCard() {
    final basePrice = widget.pricePerSeat * _selectedSeats;
    final discount = _isCouponApplied ? 200 : 0;
    final totalPayable = basePrice - discount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price ($_selectedSeats ${_selectedSeats > 1 ? 'seats' : 'seat'})',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563),
                ),
              ),
              Text(
                'Rs. ${NumberFormat('#,##0').format(basePrice)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Coupon Discount',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563),
                ),
              ),
              Text(
                _isCouponApplied ? '- Rs. 200' : 'Rs. 0',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _isCouponApplied ? const Color(0xFF22C55E) : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payable',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
              Text(
                'Rs. ${NumberFormat('#,##0').format(totalPayable)}',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // AMENITIES
  // ═══════════════════════════════════════════
  Widget _buildAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildAmenityItem('AC', icon: Icons.ac_unit_rounded),
                  Container(width: 1, height: 20, color: const Color(0xFFE5E7EB)),
                  _buildAmenityItem('Music', icon: Icons.music_note_rounded),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 1),
              ),
              Row(
                children: [
                  _buildAmenityItem('Charger', icon: Icons.power_rounded),
                  Container(width: 1, height: 20, color: const Color(0xFFE5E7EB)),
                  _buildAmenityItem(
                    'No Smoking',
                    customIcon: SizedBox(
                      width: 22,
                      height: 22,
                      child: Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(
                            Icons.smoking_rooms_rounded,
                            color: Color(0xFF111827),
                            size: 16,
                          ),
                          Icon(
                            Icons.block_rounded,
                            color: Color(0xFFE52020),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityItem(String label, {IconData? icon, Widget? customIcon}) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (customIcon != null)
            customIcon
          else if (icon != null)
            Icon(icon, color: const Color(0xFF111827), size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4B5563),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityDivider() {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0xFFE5E7EB),
    );
  }

  // ═══════════════════════════════════════════
  // BOOK BUTTON
  // ═══════════════════════════════════════════
  Widget _buildBookButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            final basePrice = widget.pricePerSeat * _selectedSeats;
            final discount = _isCouponApplied ? 200 : 0;
            final totalPayable = basePrice - discount;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PassengerWaitingDriverResponsePage(
                  pickupLocation: widget.pickupLocation,
                  dropoffLocation: widget.dropoffLocation,
                  pricePerSeat: totalPayable,
                  availableSeats: _selectedSeats,
                  date: '25 May 2025',
                  time: '08:00 AM',
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE52020),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            'Book seat',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
