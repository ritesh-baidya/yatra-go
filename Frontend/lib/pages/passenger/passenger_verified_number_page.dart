import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';

class PassengerVerifiedNumberPage extends StatelessWidget {
  const PassengerVerifiedNumberPage({super.key});

  void _goBackToSafety(BuildContext context) {
    // Pops: Verified Page, Otp Verification Page, and Verify Phone Page
    // returning user back to the safety page.
    int count = 0;
    Navigator.popUntil(context, (route) {
      return count++ >= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      resizeToAvoidBottomInset: false,
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
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 80),
                        _buildVerifiedGraphic(),
                        const SizedBox(height: 36),
                        _buildSuccessText(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Continue Button at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _goBackToSafety(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE52020),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
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
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _goBackToSafety(context),
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
    );
  }

  Widget _buildVerifiedGraphic() {
    return Center(
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFEAFDF2), // Soft outermost green tint
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: const Color(0xFFD1FADF), // Inner green ring
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF12B76A).withValues(alpha: 0.1),
              width: 3,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.verified_user_rounded, // Shield with check icon
              color: Color(0xFF10B981), // Emerald/Green theme
              size: 52,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessText() {
    return Column(
      children: [
        Text(
          'Verified!',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF10B981), // Emerald green
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Your number has been\nsuccessfully verified.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF475569), // Slate grey text
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
