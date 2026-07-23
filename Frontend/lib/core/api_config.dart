/// Base URL for the Yatri backend API.
///
/// Physical devices can't reach `localhost` — point this at the dev
/// machine's LAN IP instead (find it with `ipconfig` / `ifconfig`).
/// Update this when your machine's IP or the deployed backend URL changes.
class ApiConfig {
  /// Host the backend is reachable at (dev machine LAN IP or deployed host).
  static const String host = 'http://192.168.1.78:3000';

  /// All backend routes live under the /api/v1 global prefix.
  static const String baseUrl = '$host/api/v1';
}
