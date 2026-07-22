import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_page.dart';

class RiderNotificationPage extends StatelessWidget {
  const RiderNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: CustomScrollView(
        slivers: [
          // Header section with illustration and Today label
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          SliverToBoxAdapter(
            child: _buildNotificationCard(
              icon: Icons.account_balance_wallet_rounded,
              iconBgColor: const Color(0xFF0A5C36),
              iconColor: Colors.white,
              title: 'Payout Successful',
              description:
                  'Rs. 12,300 has been transferred to your eSewa account.',
              time: '12:30 PM',
              amountText: '+Rs. 12,300',
              amountColor: const Color(0xFF0A5C36),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildNotificationCard(
              icon: Icons.calendar_today_rounded,
              iconBgColor: const Color(0xFFE6F6EE),
              iconColor: const Color(0xFF0A5C36),
              title: 'Upcoming Ride',
              description:
                  'You have an upcoming ride to Pokhara on Sun, 25 May at 7:00 AM.',
              time: '9:15 AM',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage(),
                  ),
                );
              },
            ),
          ),
          // Yesterday section
          SliverToBoxAdapter(
            child: _buildSectionLabel('Yesterday'),
          ),
          SliverToBoxAdapter(
            child: _buildNotificationCard(
              icon: Icons.star_rounded,
              iconBgColor: const Color(0xFFFFF9E6),
              iconColor: const Color(0xFFF59E0B),
              title: 'Great Job!',
              description:
                  'You completed 3 rides yesterday.\nKeep up the great work!',
              time: 'Yesterday, 8:45 PM',
            ),
          ),
          SliverToBoxAdapter(
            child: _buildNotificationCard(
              icon: Icons.card_giftcard_rounded,
              iconBgColor: const Color(0xFFE6F6EE),
              iconColor: const Color(0xFF0A5C36),
              title: 'Bonus Earned',
              description:
                  'You earned a bonus of Rs. 150 for completing 5 rides in a day.',
              time: 'Yesterday, 6:10 PM',
              amountText: '+Rs. 150',
              amountColor: const Color(0xFF0A5C36),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildNotificationCard(
              icon: Icons.error_rounded,
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFDC2626),
              title: 'Ride Cancelled',
              description: 'A ride to Lakeside, Pokhara\nwas cancelled.',
              time: 'Yesterday, 8:30 PM',
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [

        // Content overlay (This is the main child, so the Stack will resize to fit this)
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF0A5C36),
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  'Notifications',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0A3D20),
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  'Stay updated with your rides,\noffers and important updates.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF4A5568),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Today Label
              _buildSectionLabel('Today'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF0A5C36),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
    String? amountText,
    Color? amountColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Container(
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
            onTap: onTap,
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
                      icon,
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
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A202C),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (amountText != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  amountText,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: amountColor ?? const Color(0xFF0A5C36),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF718096),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          time,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFA0AEC0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFC4C4C4),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
