import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/passenger_bottom_nav_bar.dart';
import 'passenger_incoming_call_page.dart';

class PassengerChatDetailPage extends StatefulWidget {
  final String driverName;
  final String avatarUrl;
  final String initials;
  final bool isOnline;

  const PassengerChatDetailPage({
    super.key,
    required this.driverName,
    required this.avatarUrl,
    required this.initials,
    required this.isOnline,
  });

  @override
  State<PassengerChatDetailPage> createState() => _PassengerChatDetailPageState();
}

class _PassengerChatDetailPageState extends State<PassengerChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Prepopulate messages matching the screenshot
    _messages.addAll([
      _ChatMessage(
        text: 'Hi! I am on my way. Please be at the pickup point.',
        time: '9:30 AM',
        isMe: false,
      ),
      _ChatMessage(
        text: 'Okay, I\'ll be there.',
        time: '9:31 AM',
        isMe: true,
      ),
      _ChatMessage(
        text: 'I have arrived at the pickup point.',
        time: '9:36 AM',
        isMe: false,
      ),
      _ChatMessage(
        text: 'Great, I\'m coming.',
        time: '9:37 AM',
        isMe: true,
      ),
      _ChatMessage(
        text: 'Traffic is a little heavy on the main road. It may take 2-3 mins.',
        time: '9:40 AM',
        isMe: false,
      ),
      _ChatMessage(
        text: 'No problem.',
        time: '9:41 AM',
        isMe: true,
      ),
      _ChatMessage(
        text: 'See you soon!',
        time: '9:41 AM',
        isMe: false,
      ),
    ]);
    
    // Scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        time: timeStr,
        isMe: true,
      ));
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulated reply from driver after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        final replyTime = DateTime.now();
        final replyTimeStr = "${replyTime.hour.toString().padLeft(2, '0')}:${replyTime.minute.toString().padLeft(2, '0')} ${replyTime.hour >= 12 ? 'PM' : 'AM'}";
        setState(() {
          _messages.add(_ChatMessage(
            text: 'Alright, see you soon!',
            time: replyTimeStr,
            isMe: false,
          ));
        });
        _scrollToBottom();
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
            Column(
              children: [
                // ─── Header ───
                _buildHeader(context),
                
                // ─── Messages List ───
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 12,
                      bottom: MediaQuery.of(context).padding.bottom + 150, // Space for inputs & bottom nav bar
                    ),
                    children: [
                      // Date Indicator
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Today',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                      
                      // Message bubbles
                      ..._messages.map((msg) => _buildMessageBubble(msg)),
                    ],
                  ),
                ),
              ],
            ),

            // Pinned Bottom Section (Input & Bottom Nav Bar)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Message Input Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: const Color(0xFFFEFEFE),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          // Smiley Emoji Button
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.sentiment_satisfied_alt_outlined,
                              color: Color(0xFFE52020),
                              size: 24,
                            ),
                          ),
                          
                          // Input Field
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF94A3B8),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          
                          // Send Button
                          GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE52020),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Pinned bottom nav bar
                  PassengerBottomNavBar(
                    selectedIndex: 1,
                    onTap: (index) {
                      Navigator.pop(context, index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
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
          
          // User name & status details
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.driverName,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.isOnline ? 'Online' : 'Offline',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.isOnline ? const Color(0xFF22C55E) : const Color(0xFF94A3B8),
                    ),
                  ),
                  if (widget.isOnline) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          
          // Actions on the right
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PassengerIncomingCallPage(
                        driverName: widget.driverName,
                        avatarAsset: 'assets/images/ram_kumar_avatar.png',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.phone_outlined,
                  color: Color(0xFFE52020),
                  size: 24,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    if (msg.isMe) {
      // User Message (Right Side, light red/pink bubble)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFF1), // very light cream/pink
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFF1F2),
                    Color(0xFFFFE4E6),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                msg.text,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.done_all_rounded,
                  color: Color(0xFFE52020),
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Driver Message (Left Side, light grey bubble, with avatar)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF1F5F9),
              backgroundImage: NetworkImage(widget.avatarUrl),
              child: widget.avatarUrl.isEmpty
                  ? Text(
                      widget.initials,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF64748B),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0F172A),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  msg.time,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class _ChatMessage {
  final String text;
  final String time;
  final bool isMe;

  const _ChatMessage({
    required this.text,
    required this.time,
    required this.isMe,
  });
}
