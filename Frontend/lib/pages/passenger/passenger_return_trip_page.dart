import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassengerReturnTripPage extends StatefulWidget {
  final String initialTripType;
  final DateTime? initialReturnDate;

  const PassengerReturnTripPage({
    super.key,
    this.initialTripType = 'One way',
    this.initialReturnDate,
  });

  @override
  State<PassengerReturnTripPage> createState() =>
      _PassengerReturnTripPageState();
}

class _PassengerReturnTripPageState extends State<PassengerReturnTripPage> {
  late String _tripType;
  DateTime? _returnDate;
  final ScrollController _dateScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tripType = widget.initialTripType;
    _returnDate = widget.initialReturnDate ?? DateTime.now();
    // Auto-scroll to today/selected date after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    if (!_dateScrollController.hasClients) return;
    final now = DateTime.now();
    final selected = _returnDate ?? now;
    final today = DateTime(now.year, now.month, now.day);
    // Index is 0-based from today — day 18 with today = 18 → index 0
    const tileWidth = 58.0;
    final selectedIndex = selected.day - today.day;
    if (selectedIndex < 0) return; // selected is in the past, nothing to scroll to
    final offset = (selectedIndex * tileWidth).clamp(
      0.0,
      _dateScrollController.position.maxScrollExtent,
    );
    _dateScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickReturnDate() async {
    final now = DateTime.now();
    final midnightToday = DateTime(now.year, now.month, now.day);
    
    DateTime initial = _returnDate ?? now.add(const Duration(days: 3));
    if (initial.isBefore(midnightToday)) {
      initial = midnightToday;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: midnightToday,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC80A0A),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _returnDate = picked;
      });
      // Scroll carousel to the newly selected date
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  String _formatReturnDate(DateTime date) {
    const weekdaysCustom = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final wd = weekdaysCustom[date.weekday - 1];
    final m = months[date.month - 1];
    return '$wd, ${date.day} $m ${date.year}';
  }

  /// Returns all days starting from today through the end of the current month.
  List<DateTime> _generateMonthDays(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final daysInMonth = DateUtils.getDaysInMonth(date.year, date.month);
    final List<DateTime> days = [];
    for (int d = today.day; d <= daysInMonth; d++) {
      days.add(DateTime(date.year, date.month, d));
    }
    return days;
  }

  String _getWeekdayAbbreviation(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _getMonthAbbreviation(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isRoundTrip = _tripType == 'Round trip';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFC80A0A),
                        size: 20,
                      ),
                    ),
                  ),
                  
                  // Centered Title
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Return Trip',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Decorative line: — ❖ —
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 24, height: 1.5, color: const Color(0xFFC80A0A)),
                              const SizedBox(width: 6),
                              Transform.rotate(
                                angle: 45 * 3.14159 / 180,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFC80A0A), width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(width: 24, height: 1.5, color: const Color(0xFFC80A0A)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Empty space for layout balance
                  const SizedBox(width: 40),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip type',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // One Way Card
                    _buildTripTypeCard(
                      title: 'One way',
                      subtitle: 'Single trip',
                      icon: Icons.arrow_forward_rounded,
                      isSelected: _tripType == 'One way',
                      onTap: () {
                        setState(() {
                          _tripType = 'One way';
                          _returnDate = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    // Round Trip Card
                    _buildTripTypeCard(
                      title: 'Round trip',
                      subtitle: 'Return to the original location',
                      icon: Icons.autorenew_rounded,
                      isSelected: isRoundTrip,
                      onTap: () {
                        setState(() {
                          _tripType = 'Round trip';
                          if (_returnDate == null) {
                            _returnDate = DateTime.now();
                          }
                        });
                      },
                    ),
                    
                    // Return Date Section (Only visible when Round Trip is selected)
                    if (isRoundTrip) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Return date',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Dropdown card
                      GestureDetector(
                        onTap: _pickReturnDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xFFE52020),
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _returnDate != null
                                      ? _formatReturnDate(_returnDate!)
                                      : 'Select return date',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF64748B),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Horizontal Date Carousel
                      if (_returnDate != null)
                        _buildDateCarousel(_returnDate!),
                        
                      const SizedBox(height: 20),
                      
                      // Info Alert Box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFFE52020),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Return trip will be completed on the selected date.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Done Button pinned to bottom
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'tripType': _tripType,
                  'returnDate': _returnDate,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC80A0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Done',
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

  Widget _buildTripTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFE52020) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio circle
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFE52020) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE52020),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFECEC) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFFE52020) : const Color(0xFF64748B),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
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

  Widget _buildDateCarousel(DateTime selectedDate) {
    // List starts from today — no past dates
    final days = _generateMonthDays(selectedDate);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _dateScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSameDay = day.day == selectedDate.day &&
              day.month == selectedDate.month &&
              day.year == selectedDate.year;

          final weekdayStr = _getWeekdayAbbreviation(day);
          final dayStr = day.day.toString();
          final monthStr = _getMonthAbbreviation(day);

          // Two states: selected (red) or unselected (light grey)
          final Color bgColor = isSameDay
              ? const Color(0xFFC80A0A)
              : const Color(0xFFF1F5F9);

          final Color dayNumColor = isSameDay
              ? Colors.white
              : const Color(0xFF1E293B);

          final Color labelColor = isSameDay
              ? Colors.white.withValues(alpha: 0.85)
              : const Color(0xFF94A3B8);

          return GestureDetector(
            onTap: () {
              setState(() {
                _returnDate = day;
              });
            },
            child: Container(
              width: 52,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 6,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekdayStr,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayStr,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: dayNumColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    monthStr,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
