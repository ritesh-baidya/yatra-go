import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_cancel_booking_page.dart';
import 'passenger_chat_detail_page.dart';
import 'passenger_edit_request_page.dart';
import 'passenger_notification_page.dart';
import 'passenger_ride_details_page.dart';
import 'passenger_calling_driver_page.dart';

class PassengerMyBookingPage extends StatefulWidget {
  const PassengerMyBookingPage({super.key});

  @override
  State<PassengerMyBookingPage> createState() => _PassengerMyBookingPageState();
}

class _PassengerMyBookingPageState extends State<PassengerMyBookingPage> {
  int _selectedTab = 0; // 0 for Upcoming, 1 for Pending

  // Mock data for upcoming rides
  final List<Map<String, dynamic>> _upcomingRides = [
    {
      'id': 'up1',
      'driverName': 'Ram Kumar',
      'driverRating': 4.8,
      'driverRides': 128,
      'vehicle': 'Hyundai i20',
      'vehicleColor': 'White',
      'vehicleIcon': Icons.directions_car_rounded,
      'plateProvince': 'BAGMATI',
      'plateNumber': 'BAA 1234',
      'from': 'Gongabu, Kathmandu',
      'to': 'Lakeside, Pokhara',
      'price': 700,
      'avatar': 'assets/images/ram_kumar_avatar.png',
      'driverPhone': '+977 9801234567',
      'status': 'Confirmed',
      'date': 'Sun, 25 May',
      'time': '7:00 AM',
      'availableSeats': 3,
    },
    {
      'id': 'up2',
      'driverName': 'Bikash Tamang',
      'driverRating': 4.7,
      'driverRides': 98,
      'vehicle': 'Bajaj Pulsar 150',
      'vehicleColor': 'Black',
      'vehicleIcon': Icons.motorcycle_rounded,
      'plateProvince': 'BAGMATI',
      'plateNumber': 'BAA 5678',
      'from': 'Kalanki, Kathmandu',
      'to': 'Lakeside, Pokhara',
      'price': 650,
      'avatar': 'assets/images/bikash_tamang_avatar.png',
      'driverPhone': '+977 9812345678',
      'status': 'Confirmed',
      'date': 'Sun, 8 Jun',
      'time': '9:00 AM',
      'availableSeats': 2,
    },
    {
      'id': 'up3',
      'driverName': 'Sujan Thapa',
      'driverRating': 4.6,
      'driverRides': 76,
      'vehicle': 'Suzuki WagonR',
      'vehicleColor': 'Silver',
      'vehicleIcon': Icons.directions_car_rounded,
      'plateProvince': 'BAGMATI',
      'plateNumber': 'BAA 9012',
      'from': 'Baneshwor, Kathmandu',
      'to': 'Lakeside, Pokhara',
      'price': 600,
      'avatar': 'assets/images/sujan_thapa_avatar.png',
      'driverPhone': '+977 9823456789',
      'status': 'Confirmed',
      'date': 'Sun, 15 Jun',
      'time': '10:30 AM',
      'availableSeats': 4,
    },
  ];

  // Mock data for pending/requested rides
  final List<Map<String, dynamic>> _pendingRides = [
    {
      'id': 'pend1',
      'driverName': 'Sujan Thapa',
      'driverRating': 4.6,
      'driverRides': 76,
      'vehicle': 'Suzuki WagonR',
      'vehicleColor': 'Silver',
      'vehicleIcon': Icons.directions_car_rounded,
      'plateProvince': 'BAGMATI',
      'plateNumber': 'BAA 9012',
      'from': 'Kathmandu, New Baneshwor',
      'to': 'Pokhara, Lakeside',
      'price': 700,
      'avatar': 'assets/images/sujan_thapa_avatar.png',
      'driverPhone': '+977 9823456789',
      'status': 'Pending',
      'date': 'Sun, 25 May',
      'time': '08:00 AM',
      'bookedSeats': 2,
      'seats': 2,
      'availableSeats': 2,
    }
  ];

  void _showCancelDialog(Map<String, dynamic> ride) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CancelBookingPage(
          ride: ride,
          onCancelConfirmed: () {
            setState(() {
              _upcomingRides.removeWhere((item) => item['id'] == ride['id']);
              _pendingRides.removeWhere((item) => item['id'] == ride['id']);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── Header: Centered Title & Red Decorative Divider ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const SizedBox(width: 28), // Balance for centering
                  Expanded(
                    child: Center(
                      child: Text(
                        'My Bookings',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF111827),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PassengerNotificationPage(),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF111827),
                          size: 28,
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE52020),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ─── Tab Navigation Bar (Upcoming | Pending) ───
            _buildTabBar(),

            // ─── Bookings Scrollable List ───
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16, bottom: 100),
                  child: _selectedTab == 0
                      ? _buildUpcomingList()
                      : _buildPendingList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        Row(
          children: [
            _buildTabItem(0, 'Upcoming'),
            _buildTabItem(1, 'Pending'),
          ],
        ),
        Container(
          height: 1,
          color: const Color(0xFFF3F4F6),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFFE52020) : const Color(0xFF64748B),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE52020) : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  // UPCOMING TAB LIST
  // ════════════════════════════════════════════════════
  Widget _buildUpcomingList() {
    if (_upcomingRides.isEmpty) {
      return _buildEmptyState('No upcoming bookings');
    }

    return Column(
      children: _upcomingRides.map((ride) => _buildBookingCard(ride, isPendingTab: false)).toList(),
    );
  }

  // ════════════════════════════════════════════════════
  // PENDING TAB LIST
  // ════════════════════════════════════════════════════
  Widget _buildPendingList() {
    if (_pendingRides.isEmpty) {
      return _buildEmptyState('No pending requests');
    }

    return Column(
      children: _pendingRides.map((ride) => _buildBookingCard(ride, isPendingTab: true)).toList(),
    );
  }

  // ════════════════════════════════════════════════════
  // SHARED BOOKING CARD
  // ════════════════════════════════════════════════════
  Widget _buildBookingCard(Map<String, dynamic> ride, {required bool isPendingTab}) {
    return GestureDetector(
      onTap: () {
        if (isPendingTab) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PassengerEditRequestPage(ride: ride),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PassengerRideDetailsPage(
                driverName: ride['driverName'] ?? 'Unknown',
                driverRating: (ride['driverRating'] ?? 4.5).toDouble(),
                totalRides: ride['driverRides'] ?? 0,
                vehicleName: ride['vehicle'] ?? '',
                vehicleColor: ride['vehicleColor'] ?? '',
                licensePlate: ride['plateNumber'] ?? '',
                pickupLocation: ride['from'] ?? '',
                dropoffLocation: ride['to'] ?? '',
                bookingDate: ride['date'] ?? '',
                estimatedDuration: '5h 30m',
                bookingId: 'BK123456789',
                bookedSeats: ride['bookedSeats'] ?? ride['seats'] ?? 2,
                totalAmount: ride['price'] ?? 0,
                paymentMethod: 'Cash Payment',
              ),
            ),
          );
        }
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Driver Info Row ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            ride['avatar'],
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 56,
                              height: 56,
                              color: const Color(0xFFF3F4F6),
                              child: const Icon(Icons.person, color: Colors.grey),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 10,
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
                        children: [
                          Text(
                            ride['driverName'],
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Rating Row
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFE52020), size: 16),
                                const SizedBox(width: 3),
                                Text(
                                  '${ride['driverRating']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '•  ${ride['driverRides']} rides',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Vehicle Row
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  ride['vehicleIcon'] ?? Icons.directions_car_rounded,
                                  size: 15,
                                  color: const Color(0xFF3B82F6),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${ride['vehicle']}  •  ${ride['vehicleColor']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Nepal Plate Box (on the far right)
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
                                  ride['plateProvince'],
                                  style: GoogleFonts.inter(
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                const SizedBox(height: 0.5),
                                Text(
                                  ride['plateNumber'],
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

                const SizedBox(height: 16),

                // ── Route & Price Section ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildRouteRow(ride),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rs. ${ride['price']}',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Total price',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Actions Footer ──
          _buildCardActions(ride, isPendingTab),
        ],
      ),
      ),
    );
  }

  Widget _buildRouteRow(Map<String, dynamic> ride) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const Icon(Icons.directions_walk_rounded, color: Color(0xFF1F2937), size: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    width: 2,
                    child: CustomPaint(
                      painter: _DashPainter(),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.sports_score_rounded, color: Color(0xFF1F2937), size: 20),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ride['from'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                Text(
                  ride['to'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPendingDate(dynamic rawDate) {
    if (rawDate == null) return '25 May';
    String dateStr = rawDate.toString();
    if (dateStr.contains(',')) {
      dateStr = dateStr.split(',').last.trim();
    }
    dateStr = dateStr.replaceAll(RegExp(r'\s*202\d'), '').trim();
    return dateStr;
  }

  Widget _buildCardActions(Map<String, dynamic> ride, bool isPendingTab) {
    if (isPendingTab) {
      final dateText = _formatPendingDate(ride['date']);
      final int seatCount = (ride['bookedSeats'] ?? ride['seats'] ?? ride['availableSeats'] ?? 2) as int;
      final seatsText = '$seatCount ${seatCount == 1 ? "Seat" : "Seats"}';

      return Column(
        children: [
          Container(
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Calendar Date Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF1F2937),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateText,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 18,
                  color: const Color(0xFFE5E7EB),
                ),
                // Seats Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: Color(0xFF1F2937),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            seatsText,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 18,
                  color: const Color(0xFFE5E7EB),
                ),
                // Cancel Request Section
                Expanded(
                  child: InkWell(
                    onTap: () => _showCancelDialog(ride),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Cancel Request',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE52020),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          height: 1,
          color: const Color(0xFFF3F4F6),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Message Action
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerChatDetailPage(
                          driverName: ride['driverName'],
                          avatarUrl: ride['avatar'],
                          initials: ride['driverName']
                              .split(' ')
                              .map((e) => e.isNotEmpty ? e[0] : '')
                              .join(),
                          isOnline: true,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 16,
                            color: Color(0xFF4B5563),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Message',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 18,
                color: const Color(0xFFE5E7EB),
              ),
              // Call Action
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerCallingDriverPage(
                          driverName: ride['driverName'] ?? 'Ritesh',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.call_outlined,
                            size: 16,
                            color: Color(0xFF4B5563),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Call',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 18,
                color: const Color(0xFFE5E7EB),
              ),
              // Cancel Action
              Expanded(
                child: InkWell(
                  onTap: () => _showCancelDialog(ride),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cancel_outlined,
                            size: 16,
                            color: Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cancel Booking',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dash = 4, gap = 4;
    double y = 0;
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dash), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter o) => false;
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
