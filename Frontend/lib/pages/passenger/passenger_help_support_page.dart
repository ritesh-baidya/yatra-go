import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_faq_page.dart';
import 'passenger_contact_us_page.dart';
import 'passenger_report_issue_page.dart';
import 'passenger_terms_conditions_page.dart';
import 'passenger_privacy_policy_page.dart';

class PassengerHelpSupportPage extends StatefulWidget {
  const PassengerHelpSupportPage({super.key});

  @override
  State<PassengerHelpSupportPage> createState() => _PassengerHelpSupportPageState();
}

class _PassengerHelpSupportPageState extends State<PassengerHelpSupportPage> {
  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((value) {
      if (value != null && mounted) {
        Navigator.pop(context, value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main content
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ─── Header ───
                        _buildHeader(context),
                        const SizedBox(height: 16),

                        Text(
                          "Need help? We're here to assist you.",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ─── Get Help Card ───
                        _buildCard(
                          title: 'Get Help',
                          items: [
                            _HelpItem(
                              icon: Icons.help_outline_rounded,
                              title: 'FAQs',
                              subtitle: 'Find answers to common questions.',
                              onTap: () => _navigateToPage(const PassengerFaqPage()),
                            ),
                            _HelpItem(
                              icon: Icons.gpp_maybe_outlined,
                              title: 'Report an Issue',
                              subtitle: 'Report a problem or share your concern.',
                              onTap: () => _navigateToPage(const PassengerReportIssuePage()),
                            ),
                            _HelpItem(
                              icon: Icons.mail_outline_rounded,
                              title: 'Contact Us',
                              subtitle: "Send us an email and we'll get back to you.",
                              onTap: () => _navigateToPage(const PassengerContactUsPage()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ─── About Card ───
                        _buildCard(
                          title: 'About',
                          items: [
                            _HelpItem(
                              icon: Icons.description_outlined,
                              title: 'Terms & Conditions',
                              subtitle: 'Read our terms and conditions.',
                              onTap: () => _navigateToPage(const PassengerTermsConditionsPage()),
                            ),
                            _HelpItem(
                              icon: Icons.shield_outlined,
                              title: 'Privacy Policy',
                              subtitle: 'Learn how we protect your data.',
                              onTap: () => _navigateToPage(const PassengerPrivacyPolicyPage()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // ─── Version Number ───
                        Text(
                          'Version 1.0.0',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
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
                selectedIndex: 2, // Profile index active
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
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
                children: const [
                  TextSpan(
                    text: 'Help & ',
                    style: TextStyle(color: Color(0xFF0F172A)),
                  ),
                  TextSpan(
                    text: 'Support',
                    style: TextStyle(color: Color(0xFFE52020)),
                  ),
                ],
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

  Widget _buildCard({
    required String title,
    required List<_HelpItem> items,
  }) {
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
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                InkWell(
                  onTap: item.onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        ],
      ),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.inter(
                color: const Color(0xFFE52020),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
