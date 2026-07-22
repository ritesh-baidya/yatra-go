import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceRangeSheet extends StatefulWidget {
  final double initialMin;
  final double initialMax;
  final bool initialShowSeats;
  final Function(double min, double max, bool showSeats) onApply;
  final VoidCallback onReset;

  const PriceRangeSheet({
    super.key,
    required this.initialMin,
    required this.initialMax,
    required this.initialShowSeats,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<PriceRangeSheet> createState() => _PriceRangeSheetState();
}

class _PriceRangeSheetState extends State<PriceRangeSheet> {
  late double _currentMin;
  late double _currentMax;
  late bool _showSeats;

  @override
  void initState() {
    super.initState();
    _currentMin = widget.initialMin;
    _currentMax = widget.initialMax;
    _showSeats = widget.initialShowSeats;
  }

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
              const SizedBox(width: 24),
              Expanded(
                child: Center(
                  child: Text(
                    'Price Range',
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
          const SizedBox(height: 18),

          Text(
            'Select price range',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 12),

          // Min/Max Box Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Min Price',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs. ${_currentMin.round()}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Max Price',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs. ${_currentMax.round()}',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Range Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFE52020),
              inactiveTrackColor: const Color(0xFFF1F5F9),
              trackHeight: 4.0,
              thumbColor: const Color(0xFFE52020),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
              overlayColor: const Color(0xFFE52020).withValues(alpha: 0.12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10.0,
                elevation: 3.0,
              ),
            ),
            child: RangeSlider(
              values: RangeValues(_currentMin, _currentMax),
              min: 0.0,
              max: 2000.0,
              onChanged: (RangeValues values) {
                setState(() {
                  _currentMin = values.start;
                  _currentMax = values.end;
                });
              },
            ),
          ),

          // Slider Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSliderLabel('Rs. 0'),
                _buildSliderLabel('Rs. 500'),
                _buildSliderLabel('Rs. 1000'),
                _buildSliderLabel('Rs. 1500'),
                _buildSliderLabel('Rs. 2000'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Selected Range Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFCA3A3).withValues(alpha: 0.4),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Red badge tag icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_offer_outlined,
                    color: Color(0xFFE52020),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Range',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rs. ${_currentMin.round()} - Rs. ${_currentMax.round()}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFE52020),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Show only available seats Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                _showSeats = !_showSeats;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _showSeats ? const Color(0xFFE52020) : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: _showSeats ? const Color(0xFFE52020) : const Color(0xFFCBD5E1),
                        width: 1.5,
                      ),
                    ),
                    child: _showSeats
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Show only available seats',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentMin = 300.0;
                      _currentMax = 1500.0;
                      _showSeats = false;
                    });
                    widget.onReset();
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_currentMin, _currentMax, _showSeats);
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF94A3B8),
      ),
    );
  }
}
