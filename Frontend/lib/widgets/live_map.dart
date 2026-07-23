import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/location_service.dart';

/// Reusable OpenStreetMap-backed map that fills its parent.
///
/// Drops in wherever a static map image was used — the parent still controls
/// size, clipping and any overlays stacked on top. By default it is a
/// non-interactive preview centered on Kathmandu; enable [interactive] for
/// pan/zoom and [showUserLocation] to recenter on the device's GPS fix.
class LiveMap extends StatefulWidget {
  final LatLng? center;
  final double zoom;
  final bool interactive;
  final bool showUserLocation;

  /// Optional pins to draw (e.g. pickup / destination).
  final List<LatLng> markers;

  /// Optional polyline route drawn between points.
  final List<LatLng> route;

  /// Optional external controller so the parent can drive the map
  /// (e.g. a recenter button). When null, an internal one is used.
  final MapController? controller;

  const LiveMap({
    super.key,
    this.center,
    this.zoom = 14,
    this.interactive = false,
    this.showUserLocation = false,
    this.markers = const [],
    this.route = const [],
    this.controller,
  });

  /// Kathmandu — the app's default map focus when no location is known.
  static const LatLng kathmandu = LatLng(27.7172, 85.3240);

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  late final MapController _controller = widget.controller ?? MapController();
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    if (widget.showUserLocation) {
      _resolveUserLocation();
    }
  }

  Future<void> _resolveUserLocation() async {
    final pos = await LocationService.instance.getCurrentPosition();
    if (pos == null || !mounted) return;
    final here = LatLng(pos.latitude, pos.longitude);
    setState(() => _userLocation = here);
    _controller.move(here, widget.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final initialCenter =
        widget.center ?? _userLocation ?? LiveMap.kathmandu;

    final interactionOptions = InteractionOptions(
      flags: widget.interactive ? InteractiveFlag.all : InteractiveFlag.none,
    );

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: widget.zoom,
        interactionOptions: interactionOptions,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.yatri.app',
        ),
        if (widget.route.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.route,
                strokeWidth: 4,
                color: const Color(0xFFE52020),
              ),
            ],
          ),
        if (widget.markers.isNotEmpty)
          MarkerLayer(
            markers: [
              for (final point in widget.markers)
                Marker(
                  point: point,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFFE52020),
                    size: 40,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
