class ApiConfig {
  static const bool useMock = false;

  static String get baseUrl {
    return useMock
        ? 'http://192.168.68.219:3000' // JSON Server
        // ? 'https://f71e-154-73-174-180.ngrok-free.app/' // JSON Server
        : 'https://gogainde-back.apps.origins.heritage.africa';
  }
}
