import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';

class PassengerNotificationPage extends StatefulWidget {
  const PassengerNotificationPage({super.key});

  @override
  State<PassengerNotificationPage> createState() => _PassengerNotificationPageState();
}

class _PassengerNotificationPageState extends State<PassengerNotificationPage> {
  // List of notifications matching the UI mock image exactly
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'booking',
      'title': 'Booking Confirmed',
      'description': 'Your booking from Kathmandu to Pokhara on 25 May at 7:00 AM is confirmed.',
      'time': '2m ago',
      'isUnread': true,
      'icon': Icons.calendar_today_rounded,
      'iconBgColor': const Color(0xFFFFF0F0),
      'iconColor': const Color(0xFFE53E3E),
    },
    {
      'id': '2',
      'type': 'booking',
      'title': 'Driver Assigned',
      'description': 'Ram Kumar is assigned as your driver. Contact the driver for any details.',
      'time': '5m ago',
      'isUnread': true,
      'icon': Icons.person_rounded,
      'iconBgColor': const Color(0xFFEBF8FF),
      'iconColor': const Color(0xFF3182CE),
    },
    {
      'id': '3',
      'type': 'booking',
      'title': 'Ride Reminder',
      'description': 'Your ride to Pokhara is tomorrow at 7:00 AM. Don\'t forget!',
      'time': '1 day ago',
      'isUnread': true,
      'icon': Icons.access_time_rounded,
      'iconBgColor': const Color(0xFFFFFAF0),
      'iconColor': const Color(0xFFDD6B20),
    },
    {
      'id': '4',
      'type': 'booking',
      'title': 'Driver is Nearby',
      'description': 'Ram Kumar is near your pickup location. Be ready for your ride.',
      'time': '10m ago',
      'isUnread': true,
      'icon': Icons.notifications_none_rounded,
      'iconBgColor': const Color(0xFFF0FFF4),
      'iconColor': const Color(0xFF38A169),
    },
    {
      'id': '5',
      'type': 'booking',
      'title': 'Ride Completed',
      'description': 'Thank you for riding with us. We hope you had a great trip!',
      'time': '2 days ago',
      'isUnread': false,
      'icon': Icons.shield_outlined,
      'iconBgColor': const Color(0xFFF0FFF4),
      'iconColor': const Color(0xFF38A169),
    },
    {
      'id': '6',
      'type': 'booking',
      'title': 'Payment Successful',
      'description': 'Your payment of NPR 1,250 has been completed successfully.',
      'time': '2 days ago',
      'isUnread': false,
      'icon': Icons.account_balance_wallet_outlined,
      'iconBgColor': const Color(0xFFFAF5FF),
      'iconColor': const Color(0xFF805AD5),
    },
    {
      'id': '7',
      'type': 'offer',
      'title': 'New Offer for You!',
      'description': 'Get 20% off on your next 3 rides. Use code: YATRI20',
      'time': '3 days ago',
      'isUnread': false,
      'icon': Icons.local_offer_outlined,
      'iconBgColor': const Color(0xFFFFFDF0),
      'iconColor': const Color(0xFFD69E2E),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: Stack(
        children: [
          // Main scrollable content
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Custom Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha:0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF0F172A),
                            size: 20,
                          ),
                        ),
                      ),
                      
                      // Centered Title
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Notifications',
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Empty space for layout balance
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Notifications Card List
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_allNotifications.length, (index) {
                            final item = _allNotifications[index];
                            final isLast = index == _allNotifications.length - 1;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildNotificationItem(item),
                                if (!isLast)
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: const Color(0xFFE2E8F0),
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation Bar pinned to bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PassengerBottomNavBar(
              selectedIndex: 2, // Profile selected as shown in image
              onTap: (index) {
                Navigator.pop(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item) {
    final isUnread = item['isUnread'] as bool? ?? false;
    final Color iconBgColor = item['iconBgColor'] as Color;
    final Color iconColor = item['iconColor'] as Color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            item['title'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A202C),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Time text on the right
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['time'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFA0AEC0),
                                ),
                              ),
                              if (isUnread) ...[
                                const SizedBox(width: 8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE52020),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['description'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF718096),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

