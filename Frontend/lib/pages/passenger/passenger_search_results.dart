import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_booking_details_page.dart';
import 'passenger_earliest_option_page.dart';
import 'passenger_price_range_page.dart';
import 'passenger_filer_option_page.dart';

class RideResult {
  final String name;
  final String rating;
  final String time;
  final DateTime dateTime;
  final String fromLoc;
  final String toLoc;
  final int seatsLeft;
  final int price;
  final String vehicleType; // 'car' or 'bike'
  final List<String> amenities;

  RideResult({
    required this.name,
    required this.rating,
    required this.time,
    required this.dateTime,
    required this.fromLoc,
    required this.toLoc,
    required this.seatsLeft,
    required this.price,
    required this.vehicleType,
    required this.amenities,
  });
}

class PassengerSearchResultsPage extends StatefulWidget {
  const PassengerSearchResultsPage({super.key});

  @override
  State<PassengerSearchResultsPage> createState() => _PassengerSearchResultsPageState();
}

class _PassengerSearchResultsPageState extends State<PassengerSearchResultsPage> {
  // Active state indicators
  bool _isEarliestApplied = true;
  bool _isPriceApplied = false;
  bool _isFilterApplied = false;

  // Search filter and sort state
  String _selectedSort = 'earliest';
  double _minPrice = 300.0;
  double _maxPrice = 1500.0;
  bool _showOnlyAvailableSeats = false;

  // Filter sheet options state
  String _availableSeats = 'any';
  String _vehicleType = 'any';
  final Map<String, bool> _amenities = {
    'AC': true,
    'Music': true,
    'Charger': true,
    'No Smoking': false,
  };

  final List<RideResult> _allRides = [
    RideResult(
      name: 'Ram Kumar',
      rating: '4.8',
      time: 'Today • 7:00 AM',
      dateTime: DateTime(2025, 5, 25, 7, 0),
      fromLoc: 'Gongabu, KTM',
      toLoc: 'Lakeside, Pokhara',
      seatsLeft: 3,
      price: 700,
      vehicleType: 'car',
      amenities: ['AC', 'Music', 'Charger'],
    ),
    RideResult(
      name: 'Bikash Tamang',
      rating: '4.7',
      time: 'Today • 8:30 AM',
      dateTime: DateTime(2025, 5, 25, 8, 30),
      fromLoc: 'Kalanki, KTM',
      toLoc: 'Lakeside, Pokhara',
      seatsLeft: 2,
      price: 650,
      vehicleType: 'bike',
      amenities: ['Music', 'Charger'],
    ),
    RideResult(
      name: 'Sujan Thapa',
      rating: '4.6',
      time: 'Today • 9:00 AM',
      dateTime: DateTime(2025, 5, 25, 9, 0),
      fromLoc: 'Baneshwor, KTM',
      toLoc: 'Pokhara Buspark',
      seatsLeft: 4,
      price: 600,
      vehicleType: 'car',
      amenities: ['AC', 'Music', 'No Smoking'],
    ),
  ];

  List<RideResult> get _filteredRides {
    List<RideResult> rides = List.from(_allRides);

    // Price filtering
    rides = rides.where((ride) => ride.price >= _minPrice && ride.price <= _maxPrice).toList();

    // Seats filtering
    if (_showOnlyAvailableSeats) {
      rides = rides.where((ride) => ride.seatsLeft > 0).toList();
    }
    if (_availableSeats == '1+') {
      rides = rides.where((ride) => ride.seatsLeft >= 1).toList();
    } else if (_availableSeats == '2+') {
      rides = rides.where((ride) => ride.seatsLeft >= 2).toList();
    } else if (_availableSeats == '3+') {
      rides = rides.where((ride) => ride.seatsLeft >= 3).toList();
    }

    // Vehicle Type filtering
    if (_vehicleType == 'car') {
      rides = rides.where((ride) => ride.vehicleType == 'car').toList();
    } else if (_vehicleType == 'bike') {
      rides = rides.where((ride) => ride.vehicleType == 'bike').toList();
    }

    // Amenities filtering
    _amenities.forEach((key, value) {
      if (value) {
        rides = rides.where((ride) => ride.amenities.contains(key)).toList();
      }
    });

    // Sorting
    if (_selectedSort == 'earliest') {
      rides.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (_selectedSort == 'latest') {
      rides.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else if (_selectedSort == 'today') {
      // All mock rides are today, no-op
    } else if (_selectedSort == 'tomorrow') {
      rides = [];
    }

    return rides;
  }

  void _showSortByEarliestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SortByEarliestSheet(
              selectedSort: _selectedSort,
              onSelected: (val) {
                setModalState(() {
                  _selectedSort = val;
                });
                setState(() {
                  _selectedSort = val;
                });
              },
              onApply: () {
                setState(() {
                  _isEarliestApplied = true;
                });
              },
            );
          },
        );
      },
    );
  }

  void _showPriceRangeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PriceRangeSheet(
          initialMin: _minPrice,
          initialMax: _maxPrice,
          initialShowSeats: _showOnlyAvailableSeats,
          onApply: (min, max, showSeats) {
            setState(() {
              _minPrice = min;
              _maxPrice = max;
              _showOnlyAvailableSeats = showSeats;
              _isPriceApplied = true;
            });
          },
          onReset: () {
            setState(() {
              _minPrice = 300.0;
              _maxPrice = 1500.0;
              _showOnlyAvailableSeats = false;
              _isPriceApplied = false;
            });
          },
        );
      },
    );
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FiltersSheet(
          initialSeats: _availableSeats,
          initialVehicleType: _vehicleType,
          initialAmenities: _amenities,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          onApply: (seats, vehicle, amenities) {
            setState(() {
              _availableSeats = seats;
              _vehicleType = vehicle;
              _amenities.addAll(amenities);
              _isFilterApplied = true;
            });
          },
          onReset: () {
            setState(() {
              _availableSeats = 'any';
              _vehicleType = 'any';
              _amenities.updateAll((key, value) => key != 'No Smoking');
              _isFilterApplied = false;
            });
          },
          onOpenPriceRange: () {
            Future.delayed(const Duration(milliseconds: 100), () {
              _showPriceRangeSheet();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 480;

    Widget mainContent = Scaffold(
      backgroundColor: const Color(0xFFFAF7F4),
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            // ─── Custom Top Bar ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFFE52020),
                        size: 28,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kathmandu → Pokhara',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 44), // To balance the back button space
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─── Filter Options Row ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterButton(
                    icon: Icons.access_time_rounded,
                    label: 'Earliest',
                    isActive: _isEarliestApplied,
                    onTap: _showSortByEarliestSheet,
                  ),
                  _buildFilterButton(
                    icon: Icons.workspace_premium_outlined,
                    label: 'Price',
                    isActive: _isPriceApplied,
                    onTap: _showPriceRangeSheet,
                  ),
                  _buildFilterButton(
                    icon: Icons.tune_rounded,
                    label: 'Filter',
                    isActive: _isFilterApplied,
                    onTap: _showFiltersSheet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─── Ride Results List ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _filteredRides.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          'No rides match your filter criteria.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: const Color(0xFF718096),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: _filteredRides.map((ride) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildResultCard(
                            context: context,
                            name: ride.name,
                            rating: ride.rating,
                            date: 'Sun, 25 May',
                            fromLoc: ride.fromLoc,
                            toLoc: ride.toLoc,
                            seatsLeft: '${ride.seatsLeft} Seats Left',
                            price: ride.price.toString(),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );

    if (isDesktop) {
      final height = MediaQuery.of(context).size.height;
      final clampedHeight = height > 940 ? 900.0 : height - 40.0;
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
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

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFF5F5) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? const Color(0xFFE52020) : const Color(0xFFF3EAE3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFE52020) : const Color(0xFF718096),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? const Color(0xFFE52020) : const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required BuildContext context,
    required String name,
    required String rating,
    required String date,
    required String fromLoc,
    required String toLoc,
    required String seatsLeft,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RideDetailsPage(
                  driverName: name,
                  driverInitials: name.split(' ').map((e) => e[0]).join(),
                  driverRating: double.tryParse(rating) ?? 4.5,
                  totalRides: 128,
                  pickupLocation: fromLoc,
                  dropoffLocation: toLoc,
                  pricePerSeat: int.tryParse(price) ?? 700,
                  availableSeats: int.tryParse(seatsLeft.split(' ').first) ?? 3,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Row: Avatar and Driver Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('assets/images/profile_image.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Color(0xFF10B981),
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  name,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A1A),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  date,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF718096),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFE52020), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  rating,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A1A),
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
                const SizedBox(height: 22),
                // Middle Row: Pickup
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      child: Center(
                        child: const Icon(
                          Icons.directions_walk_rounded,
                          color: Color(0xFF1E293B),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fromLoc,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              seatsLeft,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFE52020),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Timeline Dash
                Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Column(
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 1.5,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 1.5),
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Bottom Row: Destination
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 48,
                      child: Center(
                        child: const Icon(
                          Icons.sports_score_rounded,
                          color: Color(0xFF1E293B),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            toLoc,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569),
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Rs. $price\n',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1A1A1A),
                                    height: 1.2,
                                  ),
                                ),
                                TextSpan(
                                  text: 'per seat',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF94A3B8),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
