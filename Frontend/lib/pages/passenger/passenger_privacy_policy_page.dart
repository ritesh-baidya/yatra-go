import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_info_collect_page.dart';
import '../shared/turn_on_location_page.dart';
import 'passenger_privacy_detail_page.dart';
import 'passenger_delete_account_page.dart';
import 'passenger_full_privacy_policy_page.dart';

class PassengerPrivacyPolicyPage extends StatelessWidget {
  const PassengerPrivacyPolicyPage({super.key});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      _PrivacySectionItem(
        icon: Icons.assignment_ind_outlined,
        title: 'Information We Collect',
        subtitle: 'The data we collect from you.',
        onTap: (ctx) => _navigateToPage(ctx, const PassengerInfoCollectPage()),
      ),
      _PrivacySectionItem(
        icon: Icons.location_on_outlined,
        title: 'Location Permission',
        subtitle: 'Why we use your location.',
        onTap: (ctx) => _navigateToPage(ctx, const TurnOnLocationPage()),
      ),
      _PrivacySectionItem(
        icon: Icons.verified_user_outlined,
        title: 'How We Protect Your Data',
        subtitle: 'Security measures we follow.',
        onTap: (ctx) => _navigateToPage(
          ctx,
          const PassengerPrivacyDetailPage(
            title: 'How We Protect Your Data',
            subtitle: 'Security measures we follow.',
            bulletPoints: [
              'All personal information is encrypted during transit and at rest.',
              'We run regular vulnerability scans and safety assessments.',
              'Access to user details is restricted to authorized personnel only.',
              'We comply with international data security standards (GDPR/ISO).',
            ],
          ),
        ),
      ),
      _PrivacySectionItem(
        icon: Icons.share_outlined,
        title: 'When We Share Information',
        subtitle: 'When and why we share data.',
        onTap: (ctx) => _navigateToPage(
          ctx,
          const PassengerPrivacyDetailPage(
            title: 'When We Share Information',
            subtitle: 'When and why we share data.',
            bulletPoints: [
              'We share locations and contact info with drivers to facilitate rides.',
              'We may share data with legal authorities if required by law.',
              'Aggregated, non-personal data is used to analyze application patterns.',
              'We do not sell your personal data to advertisers or third parties.',
            ],
          ),
        ),
      ),
      _PrivacySectionItem(
        icon: Icons.no_accounts_outlined,
        title: 'Delete Account & Data',
        subtitle: 'How you can delete your data.',
        onTap: (ctx) => _navigateToPage(ctx, const PassengerDeleteAccountPage()),
      ),
      _PrivacySectionItem(
        icon: Icons.privacy_tip_outlined,
        title: 'Full Privacy Policy',
        subtitle: 'Read the complete policy.',
        onTap: (ctx) => _navigateToPage(ctx, const PassengerFullPrivacyPolicyPage()),
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
                          "We are committed to protecting your privacy and data.",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ─── Privacy List Card ───
                        _buildPrivacyCard(context, sections),
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
                          'Got It',
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
              'Privacy Policy',
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

  Widget _buildPrivacyCard(BuildContext context, List<_PrivacySectionItem> items) {
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
                onTap: () => item.onTap(context),
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

class _PrivacySectionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Function(BuildContext) onTap;

  const _PrivacySectionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
