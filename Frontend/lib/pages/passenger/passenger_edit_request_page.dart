import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_cancel_booking_page.dart';

class PassengerEditRequestPage extends StatefulWidget {
  final Map<String, dynamic>? ride;

  const PassengerEditRequestPage({
    super.key,
    this.ride,
  });

  @override
  State<PassengerEditRequestPage> createState() => _PassengerEditRequestPageState();
}

class _PassengerEditRequestPageState extends State<PassengerEditRequestPage> {
  late int _selectedSeats;
  late int _pricePerSeat;
  late int _couponDiscount;
  final TextEditingController _couponController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    final rideData = widget.ride ?? {};
    _selectedSeats = (rideData['bookedSeats'] ?? rideData['seats'] ?? 2) as int;
    _pricePerSeat = (rideData['price'] ?? 700) as int;
    _couponDiscount = 200;
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _incrementSeats() {
    if (_selectedSeats < 3) {
      setState(() {
        _selectedSeats++;
      });
    }
  }

  void _decrementSeats() {
    if (_selectedSeats > 1) {
      setState(() {
        _selectedSeats--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 480;

    Widget mainContent = Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: Back Button, Title & Red Diamond Accent ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: Color(0xFFE52020),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Edit Request',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const _RedDivider(),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Main Scrollable Body ───
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Request Pending Banner
                    _buildPendingBanner(),

                    const SizedBox(height: 14),

                    // 2. Driver Info Card
                    _buildDriverCard(),

                    const SizedBox(height: 14),

                    // 3. Route Details Card
                    _buildRouteCard(),

                    const SizedBox(height: 14),

                    // 4. Combined Trip Specs & Seat Selector Card
                    _buildTripSpecsAndSeatSelectorCard(),

                    const SizedBox(height: 14),

                    // 5. Coupon Code Input Field
                    _buildCouponSection(),

                    const SizedBox(height: 14),

                    // 6. Price Details Card
                    _buildPriceDetailsCard(),

                    const SizedBox(height: 14),

                    // 7. Amenities Section
                    _buildAmenitiesCard(),

                    const SizedBox(height: 20),

                    // 8. Action Buttons (Update Request & Cancel Request)
                    _buildActionButtons(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      final screenHeight = MediaQuery.of(context).size.height;
      final clampedHeight = screenHeight > 940 ? 900.0 : screenHeight - 40.0;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
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
            Center(
              child: Container(
                width: 390,
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

  // ════════════════════════════════════════════════════
  // 1. REQUEST PENDING BANNER
  // ════════════════════════════════════════════════════
  Widget _buildPendingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED), // Warm light peach/orange background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFEDD5), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Clock Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF97316), width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.access_time_rounded,
                color: Color(0xFFEA580C),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Pending',
                  style: GoogleFonts.inter(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFEA580C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Waiting for the driver to review your request.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'We’ll notify you as soon as they respond.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF475569),
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
  // 2. DRIVER INFO CARD
  // ════════════════════════════════════════════════════
  Widget _buildDriverCard() {
    final rideData = widget.ride ?? {};
    final driverName = rideData['driverName'] ?? 'Ram Kumar';
    final driverRating = (rideData['driverRating'] ?? 4.8).toDouble();
    final driverRides = rideData['driverRides'] ?? 128;
    final vehicle = rideData['vehicle'] ?? 'Hyundai i20';
    final vehicleColor = rideData['vehicleColor'] ?? 'White';
    final plateNumber = rideData['plateNumber'] ?? 'BA 01 JA 1234';
    final avatar = rideData['avatar'] ?? 'assets/images/ram_kumar_avatar.png';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Driver Avatar with Online Dot
          Stack(
            children: [
              ClipOval(
                child: Image.asset(
                  avatar,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 58,
                    height: 58,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.person, color: Color(0xFF64748B), size: 32),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Driver Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Name + Verified Driver Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        driverName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF16A34A),
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Verified Driver',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                // Rating Row
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFE52020), size: 15),
                      const SizedBox(width: 3),
                      Text(
                        '$driverRating',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '  •  $driverRides rides',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Vehicle & License Plate Row
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car_rounded, size: 14, color: Color(0xFF1E293B)),
                      const SizedBox(width: 4),
                      Text(
                        vehicle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF64748B), width: 1.2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vehicleColor,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // License Plate Pill Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _MiniNepalFlag(),
                            const SizedBox(width: 4),
                            Text(
                              plateNumber,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                                letterSpacing: 0.3,
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

  // ════════════════════════════════════════════════════
  // 3. ROUTE DETAILS CARD
  // ════════════════════════════════════════════════════
  Widget _buildRouteCard() {
    final rideData = widget.ride ?? {};
    final pickup = rideData['from'] ?? 'Gongabu, Kathmandu';
    final dropoff = rideData['to'] ?? 'Lakeside, Pokhara';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Column
          Column(
            children: [
              const Icon(Icons.directions_walk_rounded, color: Color(0xFF0F172A), size: 18),
              const SizedBox(height: 2),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF22C55E), width: 2),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 20,
                child: CustomPaint(
                  painter: _VerticalDottedLinePainter(),
                ),
              ),
              const SizedBox(height: 2),
              const Icon(Icons.flag_outlined, color: Color(0xFF0F172A), size: 16),
              const SizedBox(height: 2),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE52020), width: 2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          // Route Locations Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PICKUP',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF16A34A),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pickup,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'DESTINATION',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFE52020),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dropoff,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
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
  // 4. COMBINED TRIP SPECS & SEAT SELECTOR CARD
  // ════════════════════════════════════════════════════
  Widget _buildTripSpecsAndSeatSelectorCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top 3-Column Specs Row ──
          Row(
            children: [
              // Column 1: Duration
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFF475569),
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '5 hr',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Est. Duration',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 42, color: const Color(0xFFF1F5F9)),
              // Column 2: Price per person
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFECFDF5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Color(0xFF0F766E),
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rs. $_pricePerSeat',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Price per person',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 42, color: const Color(0xFFF1F5F9)),
              // Column 3: Seats selected
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.airline_seat_recline_normal_rounded,
                        color: Color(0xFF3730A3),
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_selectedSeats / 4',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Seats selected',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // ── Bottom Seat Counter Controls ──
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 0.7854,
                  child: Container(width: 6, height: 6, color: const Color(0xFFE52020)),
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Number of Seats',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: 0.7854,
                  child: Container(width: 6, height: 6, color: const Color(0xFFE52020)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minus Button
              GestureDetector(
                onTap: _decrementSeats,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.remove_rounded,
                      color: Color(0xFFE52020),
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Count Display Box
              Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                ),
                child: Center(
                  child: Text(
                    '$_selectedSeats',
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Plus Button
              GestureDetector(
                onTap: _incrementSeats,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_rounded,
                      color: Color(0xFFE52020),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Maximum 3 seats',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D4ED8),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // 5. COUPON SECTION
  // ════════════════════════════════════════════════════
  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFCA5A5), width: 1.2),
            ),
            child: const Icon(
              Icons.percent_rounded,
              color: Color(0xFFE52020),
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          // TextField
          Expanded(
            child: TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: 'Enter coupon code',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Apply Button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Coupon applied successfully!',
                    style: GoogleFonts.inter(),
                  ),
                  backgroundColor: const Color(0xFF16A34A),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE52020),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Apply',
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // 6. PRICE DETAILS CARD
  // ════════════════════════════════════════════════════
  Widget _buildPriceDetailsCard() {
    final rawPrice = _pricePerSeat * _selectedSeats;
    final totalPayable = rawPrice - _couponDiscount;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: GoogleFonts.inter(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          // Line 1: Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Price ($_selectedSeats ${_selectedSeats == 1 ? "seat" : "seats"})',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
              Text(
                'Rs. ${_formatAmount(rawPrice)}',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Line 2: Coupon Discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Coupon Discount',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
              Text(
                '- Rs. $_couponDiscount',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Dashed Divider
          CustomPaint(
            size: const Size(double.infinity, 1),
            painter: _HorizontalDashedLinePainter(),
          ),
          const SizedBox(height: 10),
          // Line 3: Total Payable
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Payable',
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              Text(
                'Rs. ${_formatAmount(totalPayable)}',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE52020),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000) {
      final str = amount.toString();
      return '${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}';
    }
    return amount.toString();
  }

  // ════════════════════════════════════════════════════
  // 7. AMENITIES CARD
  // ════════════════════════════════════════════════════
  Widget _buildAmenitiesCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildAmenityItem('AC', icon: Icons.ac_unit_rounded),
                  Container(width: 1, height: 20, color: const Color(0xFFF1F5F9)),
                  _buildAmenityItem('Music', icon: Icons.music_note_rounded),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(color: Color(0xFFF1F5F9), thickness: 1, height: 1),
              ),
              Row(
                children: [
                  _buildAmenityItem('Charger', icon: Icons.power_rounded),
                  Container(width: 1, height: 20, color: const Color(0xFFF1F5F9)),
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
                            color: Color(0xFF1E293B),
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
            Icon(icon, color: const Color(0xFF1E293B), size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // 8. ACTION BUTTONS (UPDATE & CANCEL)
  // ════════════════════════════════════════════════════
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Update Request Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Request updated successfully!',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: const Color(0xFF16A34A),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.of(context).maybePop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE52020),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Update Request',
              style: GoogleFonts.inter(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Cancel Request Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              final rideData = widget.ride ?? {
                'id': 'pend1',
                'driverName': 'Ram Kumar',
                'price': _pricePerSeat * _selectedSeats,
                'from': 'Gongabu, Kathmandu',
                'to': 'Lakeside, Pokhara',
              };
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CancelBookingPage(
                    ride: rideData,
                    onCancelConfirmed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFE52020),
              side: const BorderSide(color: Color(0xFFE52020), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel Request',
              style: GoogleFonts.inter(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE52020),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Red Diamond Accent Header Divider
// ─────────────────────────────────────────────────────────────────────────────
class _RedDivider extends StatelessWidget {
  const _RedDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vertical Dotted Line Painter
// ─────────────────────────────────────────────────────────────────────────────
class _VerticalDottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashHeight = 3;
    const double dashGap = 3;
    double startY = 0;
    final paint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Horizontal Dashed Line Painter
// ─────────────────────────────────────────────────────────────────────────────
class _HorizontalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 4;
    const double dashGap = 4;
    double startX = 0;
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Mini Nepal Flag Painter for License Plate Badge
// ─────────────────────────────────────────────────────────────────────────────
class _MiniNepalFlag extends StatelessWidget {
  const _MiniNepalFlag();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(11, 14),
      painter: _NepalFlagPainter(),
    );
  }
}

class _NepalFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.45);
    path.lineTo(size.width * 0.3, size.height * 0.45);
    path.lineTo(size.width * 0.9, size.height * 0.95);
    path.lineTo(0, size.height * 0.95);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    final symbolPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.24),
      1.0,
      symbolPaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.28, size.height * 0.72),
      1.2,
      symbolPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
