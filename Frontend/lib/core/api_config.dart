/// Base URL for the Yatri backend API.
///
/// Physical devices can't reach `localhost` — point this at the dev
/// machine's LAN IP instead (find it with `ipconfig` / `ifconfig`).
/// Update this when your machine's IP or the deployed backend URL changes.
class ApiConfig {
  static const String baseUrl = 'http://192.168.1.78:3000';
}
