import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SortByEarliestSheet extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSelected;
  final VoidCallback onApply;

  const SortByEarliestSheet({
    super.key,
    required this.selectedSort,
    required this.onSelected,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24), // Spacer to center the title
              Expanded(
                child: Center(
                  child: Text(
                    'Sort by Earliest',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF1A1A1A),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Options List
          _buildOptionRow(
            id: 'earliest',
            title: 'Earliest',
            subtitle: 'Show earliest departures first',
            icon: Icons.access_time_rounded,
          ),
          _buildOptionRow(
            id: 'latest',
            title: 'Latest',
            subtitle: 'Show latest departures first',
            icon: Icons.access_time_rounded,
          ),
          _buildOptionRow(
            id: 'today',
            title: 'Today',
            subtitle: "Show only today's rides",
            icon: Icons.calendar_today_rounded,
          ),
          _buildOptionRow(
            id: 'tomorrow',
            title: 'Tomorrow',
            subtitle: "Show only tomorrow's rides",
            icon: Icons.calendar_today_rounded,
          ),

          const SizedBox(height: 16),

          // Apply Button
          ElevatedButton(
            onPressed: () {
              onApply();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE52020),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Apply',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedSort == id;
    return GestureDetector(
      onTap: () => onSelected(id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F5) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFFE52020) : const Color(0xFFF1F5F9),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Custom Radio Button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFE52020) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFFE52020) : Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Icon
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE52020) : const Color(0xFF94A3B8),
              size: 20,
            ),
            const SizedBox(width: 12),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFFE52020) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
