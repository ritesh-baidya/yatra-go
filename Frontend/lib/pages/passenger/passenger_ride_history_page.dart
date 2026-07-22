import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_ride_details_page.dart';

class PassengerRideHistoryPage extends StatefulWidget {
  const PassengerRideHistoryPage({super.key});

  @override
  State<PassengerRideHistoryPage> createState() =>
      _PassengerRideHistoryPageState();
}

class _PassengerRideHistoryPageState extends State<PassengerRideHistoryPage> {
  int _selectedTab = 0; // 0 for Completed, 1 for Cancelled

  final List<Map<String, dynamic>> _completedRides = [
    {
      'id': 'comp1',
      'driverName': 'Ram Kumar',
      'driverRating': 4.9,
      'totalRides': 142,
      'vehicle': 'Hyundai i20 (White)',
      'licensePlate': 'BAA 1234',
      'from': 'Gongabu, Kathmandu',
      'to': 'Lakeside, Pokhara',
      'date': 'Sun, 18 May 2025',
      'time': '7:00 AM',
      'duration': '5h 30m',
      'price': 700,
      'seats': 1,
      'paymentMethod': 'Cash Payment',
      'status': 'Completed',
    },
    {
      'id': 'comp2',
      'driverName': 'Bikash Tamang',
      'driverRating': 4.8,
      'totalRides': 98,
      'vehicle': 'Mahindra Scorpio (Black)',
      'licensePlate': 'BAB 5678',
      'from': 'Kalanki, Kathmandu',
      'to': 'Narayangarh, Chitwan',
      'date': 'Wed, 14 May 2025',
      'time': '8:30 AM',
      'duration': '4h 15m',
      'price': 950,
      'seats': 2,
      'paymentMethod': 'eSewa Payment',
      'status': 'Completed',
    },
    {
      'id': 'comp3',
      'driverName': 'Suman Shrestha',
      'driverRating': 4.7,
      'totalRides': 76,
      'vehicle': 'Swift Dzire (Silver)',
      'licensePlate': 'BAC 9012',
      'from': 'Thamel, Kathmandu',
      'to': 'Bhaktapur Durbar Square',
      'date': 'Fri, 09 May 2025',
      'time': '2:15 PM',
      'duration': '45m',
      'price': 450,
      'seats': 1,
      'paymentMethod': 'Cash Payment',
      'status': 'Completed',
    },
  ];

  final List<Map<String, dynamic>> _cancelledRides = [
    {
      'id': 'canc1',
      'driverName': 'Ramesh Thapa',
      'driverRating': 4.6,
      'totalRides': 54,
      'vehicle': 'EV Bus (Blue)',
      'licensePlate': 'BAD 3456',
      'from': 'Ratnapark, Kathmandu',
      'to': 'Nagarkot Hill Station',
      'date': 'Tue, 12 May 2025',
      'time': '9:00 AM',
      'duration': '1h 20m',
      'price': 500,
      'seats': 1,
      'paymentMethod': 'Cash Payment',
      'reason': 'Change of plans',
      'status': 'Cancelled',
    },
    {
      'id': 'canc2',
      'driverName': 'Hari Prasad',
      'driverRating': 4.5,
      'totalRides': 32,
      'vehicle': 'Bajaj Pulsar (Red)',
      'licensePlate': 'BAE 7890',
      'from': 'Koteshwor, Kathmandu',
      'to': 'Banepa Central Market',
      'date': 'Sat, 03 May 2025',
      'time': '10:30 AM',
      'duration': '35m',
      'price': 300,
      'seats': 1,
      'paymentMethod': 'Cash Payment',
      'reason': 'Found another ride',
      'status': 'Cancelled',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final rides = _selectedTab == 0 ? _completedRides : _cancelledRides;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(context),
                        const SizedBox(height: 20),

                        // Segmented Tab Switcher (Completed | Cancelled)
                        _buildTabSwitcher(),
                        const SizedBox(height: 20),

                        // Ride List or Empty State
                        if (rides.isEmpty)
                          _buildEmptyState()
                        else
                          ...rides.map((ride) => _buildRideCard(ride)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Pinned Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PassengerBottomNavBar(
                selectedIndex: 2,
                onTap: (index) {
                  Navigator.pop(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFFE52020),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ride History',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(0, 'Completed (${_completedRides.length})'),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildTabButton(1, 'Cancelled (${_cancelledRides.length})'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int tabIndex, String label) {
    final isSelected = _selectedTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tabIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFFE52020)
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride) {
    final isCompleted = ride['status'] == 'Completed';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PassengerRideDetailsPage(
              driverName: ride['driverName'],
              driverRating: ride['driverRating'] as double,
              totalRides: ride['totalRides'] as int,
              vehicleName: ride['vehicle'],
              vehicleColor: '',
              licensePlate: ride['licensePlate'],
              pickupLocation: ride['from'],
              dropoffLocation: ride['to'],
              bookingDate: ride['date'],
              estimatedDuration: ride['duration'],
              bookingId: ride['id'],
              bookedSeats: ride['seats'] as int,
              totalAmount: ride['price'] as int,
              paymentMethod: ride['paymentMethod'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Date/Time + Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF64748B),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${ride['date']}',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF475569),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCompleted
                          ? const Color(0xFFA7F3D0)
                          : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ride['status'],
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? const Color(0xFF047857)
                              : const Color(0xFFB91C1C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 16),

            // Route details (From -> To)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.directions_walk_rounded,
                      color: Color(0xFF1E293B),
                      size: 20,
                    ),
                    Container(
                      width: 1.5,
                      height: 18,
                      color: const Color(0xFFCBD5E1),
                    ),
                    const Icon(
                      Icons.sports_score_rounded,
                      color: Color(0xFF1E293B),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['from'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ride['to'],
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
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 16),

            // Driver & Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride['driverName'],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        ride['vehicle'],
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rs. ${ride['price']}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFE52020),
                      ),
                    ),
                    if (!isCompleted && ride['reason'] != null)
                      Text(
                        'Reason: ${ride['reason']}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Color(0xFFE52020),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedTab == 0 ? 'No completed rides' : 'No cancelled rides',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your ${_selectedTab == 0 ? 'completed' : 'cancelled'} rides will appear here.',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
