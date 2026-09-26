class AppConstants {
  static const String appName = 'AI Customer Intelligence';

  // Android emulator
  static const String androidBaseUrl = 'http://10.0.2.2:8000';

  // iOS simulator
  static const String iosBaseUrl = 'http://127.0.0.1:8000';

  // Physical device - replace with your PC IP.
  static const String deviceBaseUrl = 'http://192.168.1.100:8000';

  static const String baseUrl = androidBaseUrl;

  static const String healthEndpoint = '/health';
  static const String predictionEndpoint = '/predict';

  static const Duration requestTimeout = Duration(seconds: 30);
}
