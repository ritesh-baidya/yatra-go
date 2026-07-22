import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_notification_page.dart';
import 'passenger_my_booking_page.dart';
import 'passenger_profile.dart';
import 'passenger_search_results.dart';
import 'passenger_pickup_drop_page.dart';
import 'passenger_date_page.dart';
import 'passenger_return_trip_page.dart';

class PassengerDashboard extends StatefulWidget {
  final int initialTab;
  const PassengerDashboard({super.key, this.initialTab = 0});

  @override
  State<PassengerDashboard> createState() => PassengerDashboardState();
}

class PassengerDashboardState extends State<PassengerDashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentTabIndex;
  bool _showSearchCard = true;
  DateTime? _lastBackPressTime;

  void setTabIndex(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  late AnimationController _sheetController;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTab;
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..value = 1.0;
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  String _fromCity = 'Saraswati Government School';
  String _toCity = 'Techspire college';
  DateTime _selectedDate = DateTime.now();
  String _returnType = 'One way';
  DateTime? _returnDate;
  String _selectedVehicle = 'Scooter';



  void _openLocationPage({required bool isPickup}) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PassengerPickupDropPage(
          initialPickup: _fromCity,
          initialDropoff: _toCity,
          focusOnPickup: isPickup,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _fromCity = result['pickup'] ?? _fromCity;
        _toCity = result['dropoff'] ?? _toCity;
      });
    }
  }

  void _openDatePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerDatePage(
          initialDate: _selectedDate,
        ),
      ),
    );
    if (result != null && result is DateTime) {
      setState(() {
        _selectedDate = result;
      });
    }
  }

  void _openReturnTripPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerReturnTripPage(
          initialTripType: _returnType,
          initialReturnDate: _returnDate,
        ),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _returnType = result['tripType'] ?? _returnType;
        _returnDate = result['returnDate'] as DateTime?;
      });
    }
  }


  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == tomorrow) return 'Tomorrow';
    final formatter = DateFormat('EEE, d MMM');
    return formatter.format(date);
  }

  String _getReturnText() {
    if (_returnType == 'One way') {
      return 'One way';
    }
    if (_returnDate == null) {
      return 'Select date';
    }
    return _formatDate(_returnDate!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 480;

    Widget body;
    if (_currentTabIndex == 0) {
      body = _buildDashboardHome();
    } else {
      body = _buildOtherTab(_currentTabIndex);
    }

    Widget scaffold = Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAF7F4),
      body: Stack(
        children: [
          Positioned.fill(child: body),
          // Bottom nav bar pinned
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PassengerBottomNavBar(
              selectedIndex: _currentTabIndex,
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );

    Widget rootWidget;
    if (isDesktop) {
      final height = MediaQuery.of(context).size.height;
      final clampedHeight = height > 940 ? 900.0 : height - 40.0;
      rootWidget = Scaffold(
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
                  child: scaffold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      rootWidget = scaffold;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          _showExitToast(context);
          return;
        }
        SystemNavigator.pop();
      },
      child: rootWidget,
    );
  }

  void _showExitToast(BuildContext context) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 90,
        left: 40,
        right: 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.exit_to_app_rounded,
                    color: Color(0xFFE52020), size: 18),
                const SizedBox(width: 10),
                Text(
                  'Tap again to close app',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  Widget _buildOtherTab(int index) {
    if (index == 1) return const PassengerMyBookingPage();
    if (index == 2) return const PassengerProfilePage();
    return const SizedBox.shrink();
  }

  Widget _buildDashboardHome() {
    return Stack(
      children: [
        // ─── Map Background ───
        Positioned.fill(
          child: Image.asset(
            'assets/images/passenger_map_route.png',
            fit: BoxFit.cover,
          ),
        ),

        // ─── Blue location marker with glowing aura ring ───
        Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
            ),
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),



        // ─── Floating Notification Button (Top Right) ───
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF1E293B),
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PassengerNotificationPage(),
                      ),
                    ).then((value) {
                      if (value is int) {
                        setState(() {
                          _currentTabIndex = value;
                        });
                      }
                    });
                  },
                ),
                // Red badge dot
                Positioned(
                  top: 11,
                  right: 11,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE52020),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ─── Floating GPS / Zoom Controls (Middle Right) ───
        Positioned(
          right: 16,
          top: MediaQuery.of(context).size.height * 0.28,
          child: Column(
            children: [
              // GPS Button
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: Color(0xFF0F172A),
                      size: 20,
                    ),
                    onPressed: () {
                      // Recenter action
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Floating Zoom Controls
              Container(
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_rounded, color: Color(0xFF0F172A), size: 20),
                      onPressed: () {
                        // Zoom in action
                      },
                    ),
                    Container(
                      width: 24,
                      height: 1,
                      color: const Color(0xFFF1F5F9),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, color: Color(0xFF0F172A), size: 20),
                      onPressed: () {
                        // Zoom out action
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // ─── Bottom Sheet Search Card ───
        Positioned(
          left: 0,
          right: 0,
          bottom: 64 + MediaQuery.of(context).padding.bottom,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: !_showSearchCard
                ? () {
                    _sheetController.forward();
                    setState(() {
                      _showSearchCard = true;
                    });
                  }
                : null,
            onVerticalDragUpdate: (details) {
              _sheetController.value = (_sheetController.value - details.delta.dy / 380.0).clamp(0.0, 1.0);
            },
            onVerticalDragEnd: (details) {
              final double velocity = details.velocity.pixelsPerSecond.dy;
              if (velocity > 300) {
                _sheetController.fling(velocity: -1.0);
                setState(() {
                  _showSearchCard = false;
                });
              } else if (velocity < -300) {
                _sheetController.fling(velocity: 1.0);
                setState(() {
                  _showSearchCard = true;
                });
              } else if (_sheetController.value < 0.5) {
                _sheetController.reverse();
                setState(() {
                  _showSearchCard = false;
                });
              } else {
                _sheetController.forward();
                setState(() {
                  _showSearchCard = true;
                });
              }
            },
            child: _buildNewSearchCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildNewSearchCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF64748B),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _sheetController,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _sheetController.value,
                  child: Opacity(
                    opacity: _sheetController.value.clamp(0.0, 1.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Pickup Row
                        GestureDetector(
                          onTap: () => _openLocationPage(isPickup: true),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.directions_walk_rounded,
                                  color: Color(0xFF0F172A),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _fromCity.isNotEmpty ? _fromCity : 'Select pickup',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: _fromCity.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                                      color: _fromCity.isNotEmpty ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Divider
                        Container(
                          height: 1,
                          color: const Color(0xFFF1F5F9),
                        ),
                        // Destination Row
                        GestureDetector(
                          onTap: () => _openLocationPage(isPickup: false),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.sports_score_rounded,
                                  color: Color(0xFF0F172A),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _toCity.isNotEmpty ? _toCity : 'Select destination',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: _toCity.isNotEmpty ? FontWeight.w600 : FontWeight.w500,
                                      color: _toCity.isNotEmpty ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Vehicle Selection Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildVehicleCard('Scooter', 'assets/images/scooter.png', _selectedVehicle == 'Scooter'),
                            _buildVehicleCard('Bike', 'assets/images/bike.png', _selectedVehicle == 'Bike'),
                            _buildVehicleCard('Car', 'assets/images/car.png', _selectedVehicle == 'Car'),
                            _buildVehicleCard('Jeep', 'assets/images/jeep.png', _selectedVehicle == 'Jeep'),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Date & Return Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildParamCard(
                                iconData: Icons.calendar_today_rounded,
                                label: 'Date',
                                value: _formatDate(_selectedDate),
                                onTap: _openDatePage,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildParamCard(
                                iconData: Icons.autorenew_rounded,
                                label: 'Return',
                                value: _getReturnText(),
                                onTap: _openReturnTripPage,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Search Button
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PassengerSearchResultsPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE52020),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Search Rides',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(String title, String imagePath, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedVehicle = title;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF5F5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParamCard({
    required IconData iconData,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: const Color(0xFFE52020),
                size: 15,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFE52020),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
