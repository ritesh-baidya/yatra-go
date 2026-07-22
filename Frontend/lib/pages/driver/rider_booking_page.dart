import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _selectedTab = 0; // 0 for Pending, 1 for History

  final List<BookingRequest> _pendingRequests = [
    BookingRequest(
      name: "Suresh Paudyal",
      rating: 4.8,
      ridesCount: 32,
      date: "Sun, 25 May 2025",
      time: "7:00 AM - 10:00 AM",
      calendarDay: "25",
      calendarMonth: "MAY",
      avatarAsset: "assets/images/profile_image.jpg",
      useAssetAvatar: true,
    ),
    BookingRequest(
      name: "Rajan Shreshta",
      rating: 4.7,
      ridesCount: 18,
      date: "Sun, 25 May 2025",
      time: "8:00 AM - 10:00 AM",
      calendarDay: "25",
      calendarMonth: "MAY",
      avatarAsset: "assets/images/profile_image.jpg",
      useAssetAvatar: false, // Letter avatar
    ),
  ];

  final List<BookingHistoryItem> _historyItems = [
    BookingHistoryItem(
      name: "Suresh Paudyal",
      date: "Sun, 18 May 2025",
      time: "9:00 AM - 12:00 PM",
      status: "Completed",
      fare: "Rs. 2,100",
      avatarAsset: "assets/images/profile_image.jpg",
      useAssetAvatar: true,
    ),
    BookingHistoryItem(
      name: "Binod Adhikari",
      date: "Fri, 16 May 2025",
      time: "2:00 PM - 5:00 PM",
      status: "Cancelled",
      fare: "Rs. 1,500",
      avatarAsset: "assets/images/profile_image.jpg",
      useAssetAvatar: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // 1. Background image at the top right
            Positioned(
              top: 80,
              right: 0,
              width: MediaQuery.of(context).size.width * 0.65,
              height: 190,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                    ],
                    stops: [0.0, 0.45],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/booking_background.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                ),
              ),
            ),

            // 2. Content Column
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildMenuButton(),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Booking ",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          TextSpan(
                            text: "Requests",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF007A48),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        "Manage and respond to ride booking requests",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 38),

                    // Toggle Tabs
                    _buildTabBar(),
                    const SizedBox(height: 24),

                    // Card List
                    if (_selectedTab == 0) ...[
                      ..._pendingRequests.map((req) => _buildRequestCard(req)),
                    ] else ...[
                      ..._historyItems.map((hist) => _buildHistoryCard(hist)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xFF007A48),
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF007A48), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sliding background indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: _selectedTab == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF007A48),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tab Items
          Row(
            children: [
              // Pending Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: _selectedTab == 0
                              ? Colors.white
                              : const Color(0xFF64748B),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Pending (2)",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: _selectedTab == 0
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _selectedTab == 0
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // History Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: _selectedTab == 1
                              ? Colors.white
                              : const Color(0xFF64748B),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "History",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: _selectedTab == 1
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _selectedTab == 1
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget(String name, String asset, bool useAsset) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Avatar circle with border
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF007A48),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE6F4EA), // light mint green
              ),
              clipBehavior: Clip.antiAlias,
              child: useAsset
                  ? Image.asset(
                      asset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            name.isNotEmpty ? name[0] : "",
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF007A48),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        name.isNotEmpty ? name[0] : "",
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF007A48),
                        ),
                      ),
                    ),
            ),
          ),
        ),

        // Green active star badge at the bottom-right corner
        Positioned(
          right: 2,
          bottom: 2,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF007A48),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsColumn(BookingRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          request.name,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        // Rating & Rides Row
        Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: Color(0xFF007A48), // green star
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              request.rating.toString(),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "|",
              style: TextStyle(color: Color(0xFFCBD5E1)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${request.ridesCount} rides",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Date Row
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF10B981),
              size: 15,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                request.date,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Time Row
        Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
              color: Color(0xFF10B981),
              size: 15,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                request.time,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarBlock(BookingRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "SUN",
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF007A48), // theme green
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          request.calendarDay,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
            height: 1.1,
          ),
        ),
        Text(
          request.calendarMonth,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF007A48),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.access_time_rounded,
            color: Color(0xFF007A48),
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        // Decline Button
        Expanded(
          child: SizedBox(
            height: 46,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cancel_outlined,
                    color: Color(0xFFEF4444),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Decline",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Accept Button
        Expanded(
          child: SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Accept",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(BookingRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Corner Tab
          Positioned(
            left: 0,
            top: 0,
            child: ClipPath(
              clipper: CornerTabClipper(),
              child: Container(
                width: 30,
                height: 30,
                color: const Color(0xFF007A48),
              ),
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    _buildAvatarWidget(request.name, request.avatarAsset,
                        request.useAssetAvatar),
                    const SizedBox(width: 8),

                    // Details
                    Expanded(
                      child: _buildDetailsColumn(request),
                    ),
                    const SizedBox(width: 6),

                    // Vertical Divider
                    Container(
                      width: 1,
                      height: 72,
                      color: const Color(0xFFE2E8F0),
                    ),
                    const SizedBox(width: 8),

                    // Calendar block
                    _buildCalendarBlock(request),
                  ],
                ),
                const SizedBox(height: 16),
                _buildButtonsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BookingHistoryItem history) {
    final isCompleted = history.status == "Completed";
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatarWidget(
              history.name, history.avatarAsset, history.useAssetAvatar),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.name,
                  style: GoogleFonts.inter(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${history.date}  •  ${history.time}",
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        history.status,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? const Color(0xFF059669)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      history.fare,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF94A3B8),
            size: 24,
          ),
        ],
      ),
    );
  }
}

class CornerTabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.2,
      0,
      size.height,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Data models for Mock Requests
class BookingRequest {
  final String name;
  final double rating;
  final int ridesCount;
  final String date;
  final String time;
  final String calendarDay;
  final String calendarMonth;
  final String avatarAsset;
  final bool useAssetAvatar;

  BookingRequest({
    required this.name,
    required this.rating,
    required this.ridesCount,
    required this.date,
    required this.time,
    required this.calendarDay,
    required this.calendarMonth,
    required this.avatarAsset,
    required this.useAssetAvatar,
  });
}

// Data models for Mock History
class BookingHistoryItem {
  final String name;
  final String date;
  final String time;
  final String status;
  final String fare;
  final String avatarAsset;
  final bool useAssetAvatar;

  BookingHistoryItem({
    required this.name,
    required this.date,
    required this.time,
    required this.status,
    required this.fare,
    required this.avatarAsset,
    required this.useAssetAvatar,
  });
}
