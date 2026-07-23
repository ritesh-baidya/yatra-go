import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

/// Reverse geocoding via OpenStreetMap Nominatim (free, no API key).
///
/// Nominatim's usage policy asks for a descriptive User-Agent and at most
/// ~1 request/second, so callers should debounce (e.g. only after the map
/// stops moving). Returns a short human-readable label, or null on failure.
class GeocodingService {
  GeocodingService._();
  static final GeocodingService instance = GeocodingService._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://nominatim.openstreetmap.org',
      headers: {'User-Agent': 'YatriApp/1.0 (ride-sharing app)'},
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );

  Future<String?> reverse(LatLng point) async {
    try {
      final response = await _dio.get('/reverse', queryParameters: {
        'lat': point.latitude,
        'lon': point.longitude,
        'format': 'jsonv2',
        'zoom': 16,
      });
      final data = response.data;
      if (data is Map && data['display_name'] is String) {
        return _shorten(data['display_name'] as String);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Nominatim returns a long comma-separated string; keep the first few
  /// parts for a compact label (e.g. "Lazimpat, Kathmandu").
  String _shorten(String displayName) {
    final parts = displayName.split(',').map((s) => s.trim()).toList();
    if (parts.length <= 2) return displayName;
    return parts.take(2).join(', ');
  }
}
