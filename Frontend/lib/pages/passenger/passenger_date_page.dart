import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassengerDatePage extends StatefulWidget {
  final DateTime initialDate;

  const PassengerDatePage({
    super.key,
    required this.initialDate,
  });

  @override
  State<PassengerDatePage> createState() => _PassengerDatePageState();
}

class _PassengerDatePageState extends State<PassengerDatePage> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  static const List<String> _weekDays = [
    'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
  ];
  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _goToPreviousMonth() {
    final now = DateTime.now();
    final prevMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    final currentMonth = DateTime(now.year, now.month);
    if (prevMonth.isBefore(currentMonth)) {
      return;
    }
    setState(() {
      _displayedMonth = prevMonth;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _selectToday() {
    final now = DateTime.now();
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
      _displayedMonth = DateTime(now.year, now.month);
    });
  }

  void _selectTomorrow() {
    final now = DateTime.now().add(const Duration(days: 1));
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
      _displayedMonth = DateTime(now.year, now.month);
    });
  }

  void _selectThisWeekend() {
    final now = DateTime.now();
    // Find the next Saturday
    int daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
    if (daysUntilSaturday == 0) daysUntilSaturday = 7;
    final saturday = now.add(Duration(days: daysUntilSaturday));
    setState(() {
      _selectedDate = DateTime(saturday.year, saturday.month, saturday.day);
      _displayedMonth = DateTime(saturday.year, saturday.month);
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  List<List<DateTime?>> _getCalendarGrid() {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDay = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7; // 0=Sun, 1=Mon, ...

    List<DateTime?> days = [];

    // Fill leading nulls for days before the 1st
    for (int i = 0; i < startWeekday; i++) {
      days.add(null);
    }

    // Fill actual days
    for (int d = 1; d <= lastDay.day; d++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, d));
    }

    // Fill trailing nulls
    while (days.length % 7 != 0) {
      days.add(null);
    }

    // Split into weeks
    List<List<DateTime?>> weeks = [];
    for (int i = 0; i < days.length; i += 7) {
      weeks.add(days.sublist(i, i + 7));
    }

    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final weeks = _getCalendarGrid();
    final now = DateTime.now();
    final isSelectedToday = _isToday(_selectedDate);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final isTomorrow = _selectedDate.year == tomorrow.year &&
        _selectedDate.month == tomorrow.month &&
        _selectedDate.day == tomorrow.day;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              color: Color(0xFF0F172A), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Date',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // ─── Quick Select Pills ───
            Row(
              children: [
                _buildQuickPill('Today', isSelectedToday, _selectToday),
                const SizedBox(width: 10),
                _buildQuickPill('Tomorrow', isTomorrow, _selectTomorrow),
                const SizedBox(width: 10),
                _buildQuickPill('This Weekend', false, _selectThisWeekend),
              ],
            ),
            const SizedBox(height: 28),
            // ─── Month Header Row ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (_displayedMonth.year == now.year &&
                          _displayedMonth.month == now.month)
                      ? null
                      : _goToPreviousMonth,
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: (_displayedMonth.year == now.year &&
                            _displayedMonth.month == now.month)
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF475569),
                    size: 28,
                  ),
                ),
                Text(
                  '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                GestureDetector(
                  onTap: _goToNextMonth,
                  child: const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF475569), size: 28),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ─── Weekday Headers ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekDays.map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // ─── Calendar Grid ───
            ...weeks.map((week) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: week.map((date) {
                    if (date == null) {
                      return const Expanded(child: SizedBox(height: 40));
                    }

                    final selected = _isSelected(date);
                    final today = _isToday(date);
                    final midnightToday = DateTime(now.year, now.month, now.day);
                    final isBeforeToday = date.isBefore(midnightToday);

                    return Expanded(
                      child: GestureDetector(
                        onTap: isBeforeToday
                            ? null
                            : () {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFE52020)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight:
                                    selected || today ? FontWeight.w700 : FontWeight.w500,
                                color: isBeforeToday
                                    ? const Color(0xFFCBD5E1)
                                    : (selected
                                        ? Colors.white
                                        : const Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
      // ─── Confirm Button ───
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedDate);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE52020),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm Date',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPill(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE52020) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFFE52020) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
