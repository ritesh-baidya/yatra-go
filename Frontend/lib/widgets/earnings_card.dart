import 'package:flutter/material.dart';
import '../util/responsive.dart';
import 'package:google_fonts/google_fonts.dart';

class EarningsCard extends StatefulWidget {
  const EarningsCard({super.key});

  @override
  _EarningsCardState createState() => _EarningsCardState();
}

class _EarningsCardState extends State<EarningsCard> {
  bool _showAmount = true;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 8, 48, 26).withValues(alpha: 0.9),
            const Color.fromARGB(255, 16, 71, 42).withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            offset: const Offset(0, 10),
            blurRadius: 20,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Left side: text and badges
          Padding(
            padding: EdgeInsets.only(
              left: r.widthPct(0.05),
              top: r.heightPct(0.015),
              bottom: r.heightPct(0.015),
              right: r.widthPct(0.28), // space for wallet image
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Today's Earnings",
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _showAmount ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _showAmount = !_showAmount;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: Text(
                    _showAmount ? 'Rs. 2,450' : 'xxx.xx',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                // Badges row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    // Rides Completed badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Color(0xFF10B981),
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '3 Rides Completed',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Great Job badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars,
                            color: Color(0xFF10B981),
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Great Job!',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF10B981),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
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
          // Right side: wallet image
          Positioned(
            right: -10,
            top: -24,
            bottom: -24,
            width: r.widthPct(0.40),
            child: Image.asset(
              'assets/images/wallet.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }
}
