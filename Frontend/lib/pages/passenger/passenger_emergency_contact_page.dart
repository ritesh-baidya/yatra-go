import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_add_contact_page.dart';
import 'passenger_edit_contact_page.dart';

class PassengerEmergencyContactPage extends StatefulWidget {
  const PassengerEmergencyContactPage({super.key});

  @override
  State<PassengerEmergencyContactPage> createState() => _PassengerEmergencyContactPageState();
}

class _PassengerEmergencyContactPageState extends State<PassengerEmergencyContactPage> {
  final List<Map<String, String>> _contacts = [
    {'name': 'Mom', 'phone': '+977 98XXXXXXXX', 'relationship': 'Mother'},
    {'name': 'Brother', 'phone': '+977 98XXXXXXXX', 'relationship': 'Brother'},
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Your Emergency Contacts',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        _buildContactsList(),
                        const SizedBox(height: 20),
                        _buildAddContactButton(),
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
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Emergency Contact',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE52020),
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
            const SizedBox(height: 16),
            Text(
              'Add or manage your emergency contacts.',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _contacts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        final initial = contact['name']!.isNotEmpty ? contact['name']![0] : 'C';

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE52020),
                ),
              ),
            ),
            title: Text(
              contact['name']!,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                contact['phone']!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Color(0xFF64748B),
              ),
              onPressed: () => _navigateToEdit(contact),
            ),
            onTap: () => _navigateToEdit(contact),
          ),
        );
      },
    );
  }

  void _navigateToEdit(Map<String, String> contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerEditContactPage(
          name: contact['name']!,
          phone: contact['phone']!,
          relationship: contact['relationship']!,
        ),
      ),
    ).then((value) {
      if (value != null && value is Map<String, dynamic>) {
        setState(() {
          if (value['action'] == 'delete') {
            _contacts.removeWhere((element) => element['name'] == contact['name']);
          } else if (value['action'] == 'update') {
            final idx = _contacts.indexWhere((element) => element['name'] == contact['name']);
            if (idx != -1) {
              _contacts[idx] = {
                'name': value['name'],
                'phone': value['phone'],
                'relationship': value['relationship'],
              };
            }
          }
        });
      }
    });
  }

  Widget _buildAddContactButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PassengerAddContactPage(),
          ),
        ).then((value) {
          if (value != null && value is Map<String, String>) {
            setState(() {
              _contacts.add(value);
            });
          }
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE52020),
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline_rounded,
              color: Color(0xFFE52020),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Emergency Contact',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE52020),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
