import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_cancel_booking_page.dart';
import 'passenger_chat_detail_page.dart';
import 'passenger_calling_driver_page.dart';

// ═══════════════════════════════════════════
// CUSTOM PAINTERS
// ═══════════════════════════════════════════

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
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

class _CheckeredFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final polePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(2, 0), Offset(2, size.height), polePaint);

    final double flagWidth = size.width - 4;
    final double flagHeight = size.height * 0.7;

    const int cols = 4;
    const int rows = 3;
    final double cellW = flagWidth / cols;
    final double cellH = flagHeight / rows;

    final blackPaint = Paint()
      ..color = const Color(0xFF1E293B)
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

    final borderPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawRect(Rect.fromLTWH(2, 0, flagWidth, flagHeight), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════
// RIDE DETAILS PAGE (Fixed, Non-Scrollable, Uncongested)
// ═══════════════════════════════════════════

class PassengerRideDetailsPage extends StatefulWidget {
  final String driverName;
  final double driverRating;
  final int totalRides;
  final String vehicleName;
  final String vehicleColor;
  final String licensePlate;
  final String pickupLocation;
  final String dropoffLocation;
  final String bookingDate;
  final String estimatedDuration;
  final String bookingId;
  final int bookedSeats;
  final int totalAmount;
  final String paymentMethod;

  const PassengerRideDetailsPage({
    super.key,
    this.driverName = 'Ram Kumar',
    this.driverRating = 4.8,
    this.totalRides = 128,
    this.vehicleName = 'Hyundai i20',
    this.vehicleColor = 'White',
    this.licensePlate = 'BAA 1234',
    this.pickupLocation = 'Gongabu, Kathmandu',
    this.dropoffLocation = 'Lakeside, Pokhara',
    this.bookingDate = 'May 21, 2024',
    this.estimatedDuration = '5h 30m',
    this.bookingId = 'BK123456789',
    this.bookedSeats = 1,
    this.totalAmount = 1400,
    this.paymentMethod = 'Cash Payment',
  });

  @override
  State<PassengerRideDetailsPage> createState() =>
      _PassengerRideDetailsPageState();
}

class _PassengerRideDetailsPageState extends State<PassengerRideDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // App Bar
              _buildAppBar(),
              const SizedBox(height: 10),
              // Main non-scrollable body layout
              Expanded(
                child: Column(
                  children: [
                    // 1. Driver & Actions Card
                    _buildDriverCard(),
                    const SizedBox(height: 10),
                    // 2. Route Card
                    _buildRouteCard(),
                    const SizedBox(height: 10),
                    // 3. Summary & Payment Card
                    Expanded(child: _buildSummaryCard()),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Cancel Booking Action Button
              _buildCancelBookingButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ── App Bar ──
  Widget _buildAppBar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFFDC2626),
                size: 26,
              ),
            ),
          ),
        ),
        Text(
          'Ride Details',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // ── Driver & Actions Card ──
  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ram_kumar_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Driver Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.driverName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFE52020),
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.driverRating.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          ' • ${widget.totalRides} rides',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${widget.vehicleName} • ${widget.vehicleColor}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 8),
          // Call & Chat buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.phone_outlined,
                  label: 'Call',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerCallingDriverPage(
                          driverName: widget.driverName,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Message',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerChatDetailPage(
                          driverName: widget.driverName,
                          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                          initials: widget.driverName
                              .split(' ')
                              .map((e) => e.isNotEmpty ? e[0] : '')
                              .join(),
                          isOnline: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFE52020), size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Route Card ──
  Widget _buildRouteCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
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
              const SizedBox(height: 2),
              CustomPaint(
                size: const Size(2, 28),
                painter: _DottedLinePainter(),
              ),
              const SizedBox(height: 2),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Center(
                  child: SizedBox(
                    width: 15,
                    height: 17,
                    child: CustomPaint(
                      painter: _CheckeredFlagPainter(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pickup',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.pickupLocation,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Text(
                  'Destination',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE52020),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.dropoffLocation,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Combined Summary & Payment Card ──
  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryRow(
            icon: Icons.calendar_today_outlined,
            label: 'Booking Date',
            value: widget.bookingDate,
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          _buildSummaryRow(
            icon: Icons.person_outline_rounded,
            label: 'Booked Seats',
            value: '${widget.bookedSeats} ${widget.bookedSeats > 1 ? 'Seats' : 'Seat'}',
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          _buildSummaryRow(
            icon: Icons.timer_outlined,
            label: 'Duration',
            value: widget.estimatedDuration,
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          _buildSummaryRow(
            icon: Icons.credit_card_outlined,
            label: 'Booking ID',
            value: widget.bookingId,
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          // Payment Row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFFE52020),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    widget.paymentMethod,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Rs. ${_formatAmount(widget.totalAmount)}',
                style: GoogleFonts.inter(
                  fontSize: 18,
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

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF64748B), size: 17),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF475569),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  String _formatAmount(int amount) {
    final str = amount.toString();
    if (str.length <= 3) return str;
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i > 0) {
        result = ',$result';
        count = 0;
      }
    }
    return result;
  }

  // ── Cancel Booking Button ──
  Widget _buildCancelBookingButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CancelBookingPage(
                ride: {
                  'driverName': widget.driverName,
                  'from': widget.pickupLocation,
                  'to': widget.dropoffLocation,
                  'date': widget.bookingDate,
                  'time': '7:00 AM',
                  'seats': widget.bookedSeats,
                  'price': widget.totalAmount,
                },
                onCancelConfirmed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
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
          'Cancel Booking',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
