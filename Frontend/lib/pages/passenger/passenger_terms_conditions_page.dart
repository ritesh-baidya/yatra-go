import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_terms_detail_page.dart';

class PassengerTermsConditionsPage extends StatelessWidget {
  const PassengerTermsConditionsPage({super.key});

  void _navigateToDetailPage(BuildContext context, String title, String subtitle, List<String> bullets) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerTermsDetailPage(
          title: title,
          subtitle: subtitle,
          bulletPoints: bullets,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _TermsSectionItem(
        icon: Icons.article_outlined,
        title: 'Using the App',
        subtitle: 'Rules for using our platform.',
        bullets: [
          'You must be at least 18 years old to use our services.',
          'You agree to provide accurate and up-to-date information.',
          'You are responsible for maintaining the confidentiality of your account.',
          'We reserve the right to update or modify these terms at any time.',
          'Continued use of the app means you accept the updated terms.',
        ],
      ),
      _TermsSectionItem(
        icon: Icons.directions_car_outlined,
        title: 'Ride Booking',
        subtitle: 'Terms related to ride bookings.',
        bullets: [
          'You agree to request rides only when you intend to travel.',
          'You must provide correct pickup and drop-off destinations.',
          'You must respect the driver and their vehicle at all times.',
          'Fares are calculated based on distance, time, and demand.',
          'You agree to pay the fare shown at the time of booking.',
        ],
      ),
      _TermsSectionItem(
        icon: Icons.payment_outlined,
        title: 'Payments & Refunds',
        subtitle: 'Payment methods, charges and refunds.',
        bullets: [
          'All payments are processed securely through our payment partners.',
          'You must link a valid payment method to your account.',
          'Refunds are processed in accordance with our cancellation policy.',
          'Any payment disputes must be reported within 7 days of the ride.',
          'Promo codes are subject to specific terms and expiration dates.',
        ],
      ),
      _TermsSectionItem(
        icon: Icons.cancel_outlined,
        title: 'Cancellation Policy',
        subtitle: 'Rules for cancelling a booking.',
        bullets: [
          'You can cancel a ride request before a driver accepts it without fee.',
          'A cancellation fee may apply if you cancel after a driver accepts.',
          'If a driver cancels after arriving, you will not be charged.',
          'Frequent cancellations may lead to account suspension.',
          'Cancellation fees are credited to the driver for their time.',
        ],
      ),
      _TermsSectionItem(
        icon: Icons.person_outlined,
        title: 'User Responsibilities',
        subtitle: 'Your responsibilities while using the app.',
        bullets: [
          'You must follow all local traffic laws and safety regulations.',
          'You are responsible for any damage caused to the driver\'s vehicle.',
          'Do not engage in abusive, threatening, or illegal behavior.',
          'Report any safety concerns or incidents immediately.',
          'Keep your account credentials secure and do not share them.',
        ],
      ),
      _TermsSectionItem(
        icon: Icons.gavel_outlined,
        title: 'Full Terms & Conditions',
        subtitle: 'Read the complete terms.',
        bullets: [
          'These terms represent the entire agreement between you and WrapIt.',
          'We reserve the right to suspend accounts that violate these terms.',
          'All content, logos, and software are the property of WrapIt.',
          'We are not liable for indirect or consequential damages.',
          'These terms are governed by the local jurisdiction\'s laws.',
        ],
      ),
    ];

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
                      bottom: MediaQuery.of(context).padding.bottom + 160,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ─── Header ───
                        _buildHeader(context),
                        const SizedBox(height: 16),

                        Text(
                          "Please read our terms and conditions carefully.",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ─── Terms List Card ───
                        _buildTermsCard(context, sections),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Pinned Bottom Section
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: const Color(0xFFFEFEFE),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE52020),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'I Understand',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  PassengerBottomNavBar(
                    selectedIndex: 2,
                    onTap: (index) {
                      Navigator.pop(context, index);
                    },
                  ),
                ],
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
                      color: Colors.black.withOpacity(0.04),
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
              'Terms & Conditions',
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
                Container(
                  width: 32,
                  height: 1.5,
                  color: const Color(0xFFE52020),
                ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: 45 * 3.14159265 / 180,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE52020),
                      border: Border.all(
                        color: const Color(0xFFE52020),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 1.5,
                  color: const Color(0xFFE52020),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTermsCard(BuildContext context, List<_TermsSectionItem> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              InkWell(
                onTap: () => _navigateToDetailPage(
                  context,
                  item.title,
                  'By using our app, you agree to the following terms and conditions.',
                  item.bullets,
                ),
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(20) : Radius.zero,
                  bottom: index == items.length - 1 ? const Radius.circular(20) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          item.icon,
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
                              item.title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFE52020),
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              if (index < items.length - 1)
                const Divider(
                  height: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _TermsSectionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> bullets;

  const _TermsSectionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bullets,
  });
}
