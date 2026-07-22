import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';

class PassengerFaqPage extends StatelessWidget {
  const PassengerFaqPage({super.key});

  static const List<Map<String, dynamic>> _faqs = [
    {
      'title': 'How to book a ride?',
      'steps': [
        'Open the Yatri app.',
        'Enter your destination in the search bar.',
        'Choose your preferred ride option.',
        'Confirm your booking and wait for a driver.'
      ],
      'note': 'Ensure your location services are enabled for accurate pickup.'
    },
    {
      'title': 'How to cancel a booking?',
      'steps': [
        "Go to your 'Bookings'.",
        'Select the booking you want to cancel.',
        "Tap on 'Cancel Booking'.",
        'Choose a reason and confirm.'
      ],
      'note': 'Cancellation charges may apply based on the timing and booking type.'
    },
    {
      'title': 'Payment & refunds',
      'steps': [
        "Navigate to 'Payment Methods' inside your profile.",
        'Select your preferred payment option.',
        'Follow the prompts to complete the transaction.',
        'Refunds will be credited to your wallet or original payment source.'
      ],
      'note': 'Refund processing times can vary depending on your payment provider.'
    },
    {
      'title': 'Driver is not responding',
      'steps': [
        'Try calling the driver via the in-app calling option.',
        'Send a message detailing your exact pickup location.',
        'If the driver does not respond after 5 minutes, you can cancel.',
        'Select the appropriate reason for cancellation.'
      ],
      'note': 'Repeated unresponsive behavior will affect the driver\'s rating.'
    },
    {
      'title': 'Driver didn\'t arrive',
      'steps': [
        'Check the live location of the driver on the map.',
        'Attempt to call the driver to verify their status.',
        'If the driver is not moving or has gone off-route, cancel the ride.',
        'Select \'Driver did not arrive\' as the reason.'
      ],
      'note': 'You will not be charged a fee if the driver fails to arrive at the pickup spot.'
    },
    {
      'title': 'How to contact my driver?',
      'steps': [
        'Open the active ride dashboard screen.',
        'Tap the call icon to call the driver.',
        'Tap the chat bubble icon to message them.',
        'Always communicate clearly and politely.'
      ],
      'note': 'Your mobile number is kept private through our masking system.'
    },
    {
      'title': 'How to rate a driver?',
      'steps': [
        'Once a ride is completed, a rating screen will appear automatically.',
        'Select between 1 to 5 stars depending on your experience.',
        'Add a comment or choose tags to describe the ride.',
        'Tap \'Submit Rating\' to finish.'
      ],
      'note': 'Your feedback is anonymous and helps improve Yatri quality.'
    },
    {
      'title': 'Lost an item during a ride',
      'steps': [
        'Go to \'Report an Issue\' in the Help & Support menu.',
        'Select \'Other issue\' or contact support directly.',
        'Provide ride details and describe the lost item.',
        'Our support agents will contact the driver to retrieve your item.'
      ],
      'note': 'Please report lost items within 24 hours of completing the ride.'
    },
  ];

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
                      left: 16,
                      right: 16,
                      top: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 16),
                        Text(
                          "Find answers to common questions.",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildFaqList(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
              'FAQs',
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

  Widget _buildFaqList(BuildContext context) {
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
        children: List.generate(_faqs.length, (index) {
          final faq = _faqs[index];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PassengerFaqDetailPage(
                        title: faq['title'] as String,
                        steps: List<String>.from(faq['steps']),
                        note: faq['note'] as String,
                      ),
                    ),
                  ).then((value) {
                    if (value != null && context.mounted) {
                      Navigator.pop(context, value);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          faq['title'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFE52020),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (index < _faqs.length - 1)
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

class PassengerFaqDetailPage extends StatelessWidget {
  final String title;
  final List<String> steps;
  final String note;

  const PassengerFaqDetailPage({
    super.key,
    required this.title,
    required this.steps,
    required this.note,
  });

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
                      left: 16,
                      right: 16,
                      top: 20,
                      bottom: MediaQuery.of(context).padding.bottom + 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 28),
                        Text(
                          "You can cancel your booking from the 'Bookings' section." == title
                              ? title
                              : "How to steps for '$title':",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildStepsList(),
                        const SizedBox(height: 32),
                        _buildNoteCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 20,
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
        ),
      ],
    );
  }

  Widget _buildStepsList() {
    return Column(
      children: List.generate(steps.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF1F2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE52020),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    steps[index],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFF1F2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE52020),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Note',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE52020),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
