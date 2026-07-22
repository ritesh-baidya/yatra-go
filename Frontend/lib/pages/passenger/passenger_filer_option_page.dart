import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FiltersSheet extends StatefulWidget {
  final String initialSeats;
  final String initialVehicleType;
  final Map<String, bool> initialAmenities;
  final double minPrice;
  final double maxPrice;
  final Function(String seats, String vehicle, Map<String, bool> amenities) onApply;
  final VoidCallback onReset;
  final VoidCallback onOpenPriceRange;

  const FiltersSheet({
    super.key,
    required this.initialSeats,
    required this.initialVehicleType,
    required this.initialAmenities,
    required this.minPrice,
    required this.maxPrice,
    required this.onApply,
    required this.onReset,
    required this.onOpenPriceRange,
  });

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late String _seats;
  late String _vehicleType;
  late Map<String, bool> _amenities;

  @override
  void initState() {
    super.initState();
    _seats = widget.initialSeats;
    _vehicleType = widget.initialVehicleType;
    _amenities = Map<String, bool>.from(widget.initialAmenities);
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
                    'Filters',
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

          // Price Range Row
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              widget.onOpenPriceRange();
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price Range',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Rs. ${widget.minPrice.round()} - Rs. ${widget.maxPrice.round()}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE52020),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFE52020),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Available Seats Section
          Text(
            'Available Seats',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSeatButton('any', 'Any'),
              const SizedBox(width: 8),
              _buildSeatButton('1+', '1+ Seats'),
              const SizedBox(width: 8),
              _buildSeatButton('2+', '2+ Seats'),
              const SizedBox(width: 8),
              _buildSeatButton('3+', '3+ Seats'),
            ],
          ),
          const SizedBox(height: 20),

          // Vehicle Type Section
          Text(
            'Vehicle Type',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildVehicleButton('any', 'Any', null),
              const SizedBox(width: 8),
              _buildVehicleButton('car', 'Car', Icons.directions_car_filled_outlined),
              const SizedBox(width: 8),
              _buildVehicleButton('bike', 'Bike', Icons.motorcycle_outlined),
            ],
          ),
          const SizedBox(height: 20),

          // Amenities Section
          Text(
            'Amenities',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: _amenities.keys.map((amenity) {
              final isChecked = _amenities[amenity] ?? false;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _amenities[amenity] = !isChecked;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isChecked ? const Color(0xFFE52020) : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: isChecked ? const Color(0xFFE52020) : const Color(0xFFCBD5E1),
                          width: 1.5,
                        ),
                      ),
                      child: isChecked
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _seats = 'any';
                      _vehicleType = 'any';
                      _amenities.updateAll((key, value) => key != 'No Smoking');
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
                    widget.onApply(_seats, _vehicleType, _amenities);
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

  Widget _buildSeatButton(String id, String label) {
    final isSelected = _seats == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _seats = id;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF5F5) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFFE52020) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFFE52020) : const Color(0xFF475569),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleButton(String id, String label, IconData? icon) {
    final isSelected = _vehicleType == id;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _vehicleType = id;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF5F5) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFFE52020) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? const Color(0xFFE52020) : const Color(0xFF475569),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? const Color(0xFFE52020) : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
