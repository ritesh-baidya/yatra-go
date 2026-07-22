import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'passenger_select_destination_page.dart';

class PassengerPickupDropPage extends StatefulWidget {
  final String initialPickup;
  final String initialDropoff;
  final bool focusOnPickup;

  const PassengerPickupDropPage({
    super.key,
    this.initialPickup = '',
    this.initialDropoff = '',
    this.focusOnPickup = true,
  });

  @override
  State<PassengerPickupDropPage> createState() =>
      _PassengerPickupDropPageState();
}

class _PassengerPickupDropPageState extends State<PassengerPickupDropPage> {
  late String _pickup;
  late String _dropoff;
  String _pickupSubtitle = '';
  String _dropoffSubtitle = '';


  // Which field is currently being edited (null = none)
  String? _editingField; // 'pickup' or 'dropoff' or null
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();



  @override
  void initState() {
    super.initState();
    _pickup = widget.initialPickup;
    _dropoff = widget.initialDropoff;

  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _startEditing(String field) {
    setState(() {
      _editingField = field;
      final currentAddress = field == 'pickup' ? _pickup : _dropoff;
      _searchController.text = currentAddress;
      // Move the blinking cursor to the end of the text
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: currentAddress.length),
      );
      _searchQuery = currentAddress;
    });
    // Request focus and ensure cursor shows
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        FocusScope.of(context).requestFocus(_searchFocusNode);
      }
    });
  }

  void _stopEditing() {
    setState(() {
      _editingField = null;
      _searchQuery = '';
      _searchController.clear();
    });
    _searchFocusNode.unfocus();
  }



  @override
  Widget build(BuildContext context) {
    final isSearching = _editingField != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              color: Color(0xFF0F172A), size: 28),
          onPressed: () {
            if (isSearching) {
              _stopEditing();
            } else {
              Navigator.pop(context, {
                'pickup': _pickup,
                'dropoff': _dropoff,
              });
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Location',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (_editingField != null) {
            _stopEditing();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: [
            // ─── Combined Location Card (always visible) ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildCombinedLocationCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedLocationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
      ),
      child: Column(
        children: [
          _buildRowItem(
            isPickup: true,
            label: 'Pickup',
            address: _pickup,
            subtitle: _pickupSubtitle,
            iconData: Icons.directions_walk_rounded,
            isEditing: _editingField == 'pickup',
            onTap: () => _startEditing('pickup'),
            onClear: () {
              setState(() {
                _pickup = '';
                _pickupSubtitle = '';

                if (_editingField == 'pickup') {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          Container(
            height: 1.2,
            color: const Color(0xFFE2E8F0),
            margin: const EdgeInsets.symmetric(horizontal: 14),
          ),
          _buildRowItem(
            isPickup: false,
            label: 'Destination',
            address: _dropoff,
            subtitle: _dropoffSubtitle,
            iconData: Icons.sports_score_rounded,
            isEditing: _editingField == 'dropoff',
            onTap: () => _startEditing('dropoff'),
            onClear: () {
              setState(() {
                _dropoff = '';
                _dropoffSubtitle = '';
                if (_editingField == 'dropoff') {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem({
    required bool isPickup,
    required String label,
    required String address,
    required String subtitle,
    required IconData iconData,
    required bool isEditing,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: isEditing ? () {} : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isEditing
              ? const Color(0xFFFFF8F8)
              : Colors.white,
          borderRadius: isPickup
              ? const BorderRadius.vertical(top: Radius.circular(20))
              : const BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isEditing ? const Color(0xFFE52020) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                color: isEditing ? Colors.white : const Color(0xFF0F172A),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  isEditing
                      ? TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                              if (isPickup) {
                                _pickup = val;
                              } else {
                                _dropoff = val;
                              }
                            });
                          },
                          textInputAction: isPickup 
                              ? (_dropoff.isEmpty ? TextInputAction.next : TextInputAction.done)
                              : (_pickup.isEmpty ? TextInputAction.next : TextInputAction.done),
                          onSubmitted: (val) {
                            if (isPickup) {
                              if (_dropoff.isEmpty) {
                                _startEditing('dropoff');
                              } else {
                                Navigator.pop(context, {
                                  'pickup': _pickup,
                                  'dropoff': _dropoff,
                                });
                              }
                            } else {
                              if (_pickup.isEmpty) {
                                _startEditing('pickup');
                              } else {
                                Navigator.pop(context, {
                                  'pickup': _pickup,
                                  'dropoff': _dropoff,
                                });
                              }
                            }
                          },
                          enableInteractiveSelection: false,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: isPickup ? 'Where from?' : 'Where to?',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        )
                      : Text(
                          address.isNotEmpty ? address : (isPickup ? 'Where from?' : 'Where to?'),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: address.isNotEmpty
                                ? const Color(0xFF0F172A)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Clear icon (X) – show when query or address is not empty
                if (isEditing ? _searchQuery.isNotEmpty : address.isNotEmpty) ...[
                  GestureDetector(
                    onTap: onClear,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF0F172A),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                // Map button: show while editing or when address is empty while not editing
                if (isEditing || (!isEditing && address.isEmpty)) ...[
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PassengerSelectDestinationPage(
                            isPickup: isPickup,
                            initialAddress: isPickup ? _pickup : _dropoff,
                          ),
                        ),
                      );
                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          if (isPickup) {
                            _pickup = result['fullAddress'] ?? result['title'] ?? '';
                            _pickupSubtitle = result['address'] ?? '';
                          } else {
                            _dropoff = result['fullAddress'] ?? result['title'] ?? '';
                            _dropoffSubtitle = result['address'] ?? '';
                          }
                          _editingField = null;
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                      child: Text('Map', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
