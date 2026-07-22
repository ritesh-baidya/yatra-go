import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Passenger bottom navigation bar with flat design, red active theme and active underline.
/// Includes tabs: Home, Bookings, Chat, Profile.
class PassengerBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const PassengerBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  // Define navigation items with correct icons and labels
  static const List<_NavItem> _items = [
    _NavItem(activeIcon: Icons.home, inactiveIcon: Icons.home_outlined, label: 'Home'),
    _NavItem(activeIcon: Icons.calendar_month, inactiveIcon: Icons.calendar_month_outlined, label: 'Bookings'),
    _NavItem(activeIcon: Icons.person, inactiveIcon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  static const Color _activeColor = Color(0xFFE52020); // Red accent
  static const Color _inactiveColor = Color(0xFF94A3B8); // Slate/Grey

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 68, // slightly taller for indicator line
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: _buildItem(item, isSelected),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(_NavItem item, bool isSelected) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? item.activeIcon : item.inactiveIcon,
            color: isSelected ? _activeColor : _inactiveColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? _activeColor : _inactiveColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 20,
            height: 2.5,
            decoration: BoxDecoration(
              color: isSelected ? _activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(1.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}
