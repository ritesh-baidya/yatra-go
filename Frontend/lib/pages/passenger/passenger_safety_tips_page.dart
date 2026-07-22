import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';

class PassengerSafetyTipsPage extends StatefulWidget {
  const PassengerSafetyTipsPage({super.key});

  @override
  State<PassengerSafetyTipsPage> createState() => _PassengerSafetyTipsPageState();
}

class _PassengerSafetyTipsPageState extends State<PassengerSafetyTipsPage> {
  final Map<String, List<Map<String, String>>> _tipsData = {
    'General Safety': [
      {
        'title': 'Be Aware',
        'desc': 'Stay aware of your surroundings at all times.',
        'icon': 'eye',
      },
      {
        'title': 'Trust Your Instincts',
        'desc': 'If something feels wrong, remove yourself from the situation.',
        'icon': 'heart',
      },
      {
        'title': 'Keep Information Private',
        'desc': 'Avoid sharing personal information with strangers.',
        'icon': 'lock',
      },
      {
        'title': 'Stay In Touch',
        'desc': 'Let your family or friends know about your plans.',
        'icon': 'phone',
      },
      {
        'title': 'Use Verified Rides',
        'desc': 'Always use verified drivers for your safety.',
        'icon': 'check_decagram',
      },
    ],
    'While Traveling': [
      {
        'title': 'Check Ride Details',
        'desc': 'Always check driver details and vehicle number.',
        'icon': 'car',
      },
      {
        'title': 'Share Trip',
        'desc': 'Share your trip details with someone you trust.',
        'icon': 'share',
      },
      {
        'title': 'Sit Safely',
        'desc': 'Prefer sitting in the back seat while traveling.',
        'icon': 'seat',
      },
      {
        'title': 'Avoid Distractions',
        'desc': 'Avoid headphones and stay alert during the ride.',
        'icon': 'headset_off',
      },
      {
        'title': 'Report Suspicious Activity',
        'desc': 'Report any suspicious behavior immediately.',
        'icon': 'alert',
      },
    ],
    'Emergency Preparedness': [
      {
        'title': 'Know Emergency Numbers',
        'desc': 'Save important numbers like 100, 101, 102, 108, 112.',
        'icon': 'phone_emergency',
      },
      {
        'title': 'Keep Essentials',
        'desc': 'Carry a power bank, ID proof, and emergency contacts.',
        'icon': 'battery',
      },
      {
        'title': 'Plan Ahead',
        'desc': 'Plan your route and check the weather before traveling.',
        'icon': 'map',
      },
      {
        'title': 'Stay Calm',
        'desc': 'In an emergency, stay calm and think clearly.',
        'icon': 'smile',
      },
      {
        'title': 'Use SOS When Needed',
        'desc': 'Use the SOS button if you feel you\'re in danger.',
        'icon': 'sos',
      },
    ],
    'Personal Safety': [
      {
        'title': 'Dress Comfortably',
        'desc': 'Wear comfortable clothing and avoid flashy accessories.',
        'icon': 'shirt',
      },
      {
        'title': 'Avoid Isolated Areas',
        'desc': 'Avoid poorly lit or isolated places, especially at night.',
        'icon': 'moon',
      },
      {
        'title': 'Keep Valuables Safe',
        'desc': 'Keep your belongings secure and out of sight.',
        'icon': 'wallet',
      },
      {
        'title': 'Say No',
        'desc': 'Don\'t hesitate to say no to situations that feel unsafe.',
        'icon': 'close',
      },
      {
        'title': 'Help Others',
        'desc': 'If you see someone in danger, offer help or call authorities.',
        'icon': 'people',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
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
                      bottom: MediaQuery.of(context).padding.bottom + 90,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 28),
                        _buildMainContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom nav bar pinned
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

  // ─── HEADER ───
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFFE52020),
                  size: 22,
                ),
              ),
            ),
          ),
          // Title
          Text(
            'Safety Tips',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE52020),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── MAIN CONTENT ───
  Widget _buildMainContent() {
    return Column(
      children: [
        // Graphic
        Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1F2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE4E6),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.verified_user_outlined,
                color: Color(0xFFE52020),
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Learn useful tips to keep yourself safe.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 36),
        // Subcategories
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildCategoryCard('General Safety', 'Everyday safety practices'),
              const SizedBox(height: 12),
              _buildCategoryCard('While Traveling', 'Safety while on the go'),
              const SizedBox(height: 12),
              _buildCategoryCard('Emergency Preparedness', 'Be ready for emergencies'),
              const SizedBox(height: 12),
              _buildCategoryCard('Personal Safety', 'Protect yourself and others'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String desc) {
    IconData getCategoryIcon(String t) {
      if (t == 'General Safety') return Icons.shield_outlined;
      if (t == 'While Traveling') return Icons.local_taxi_outlined;
      if (t == 'Emergency Preparedness') return Icons.contact_emergency_outlined;
      return Icons.person_pin_outlined;
    }

    return GestureDetector(
      onTap: () {
        final tips = _tipsData[title] ?? [];
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PassengerSafetyDetailPage(
              categoryName: title,
              tips: tips,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
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
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(getCategoryIcon(title), color: const Color(0xFFE52020), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFE52020),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SAFETY DETAIL PAGE ───
class PassengerSafetyDetailPage extends StatelessWidget {
  final String categoryName;
  final List<Map<String, String>> tips;

  const PassengerSafetyDetailPage({
    super.key,
    required this.categoryName,
    required this.tips,
  });

  IconData _getTipIcon(String iconName) {
    switch (iconName) {
      case 'eye':
        return Icons.remove_red_eye_outlined;
      case 'heart':
        return Icons.favorite_border_rounded;
      case 'lock':
        return Icons.lock_outline_rounded;
      case 'phone':
        return Icons.phone_android_outlined;
      case 'check_decagram':
        return Icons.verified_user_outlined;
      case 'car':
        return Icons.directions_car_outlined;
      case 'share':
        return Icons.share_outlined;
      case 'seat':
        return Icons.airline_seat_recline_normal_outlined;
      case 'headset_off':
        return Icons.headset_off_outlined;
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'phone_emergency':
        return Icons.phone_in_talk_outlined;
      case 'battery':
        return Icons.battery_std_outlined;
      case 'map':
        return Icons.map_outlined;
      case 'smile':
        return Icons.emoji_emotions_outlined;
      case 'sos':
        return Icons.notifications_active_outlined;
      case 'shirt':
        return Icons.checkroom_outlined;
      case 'moon':
        return Icons.dark_mode_outlined;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'close':
        return Icons.cancel_outlined;
      case 'people':
        return Icons.people_outline_rounded;
      default:
        return Icons.lightbulb_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      bottom: MediaQuery.of(context).padding.bottom + 90,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 28),
                        _buildContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom nav bar pinned
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFFE52020),
                  size: 22,
                ),
              ),
            ),
          ),
          // Title
          Text(
            categoryName,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE52020),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: tips.map((tip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      _getTipIcon(tip['icon'] ?? ''),
                      color: const Color(0xFFE52020),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['title'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tip['desc'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
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
}
