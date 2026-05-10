class AppConfig {
  static const String appName = 'Pemilihan Ketua Kelas Informatika 4A';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'Kelas Informatika 4A';
  
  // API Configuration
  static const bool useLocalData = true;
  static const String apiBaseUrl = 'https://api.ketua-kelas-informatika.example.com';
  
  // Feature Flags
  static const bool enableNotifications = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = false;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Debug
  static const bool debugMode = true;
  
  static String getEnvironment() {
    return debugMode ? 'DEVELOPMENT' : 'PRODUCTION';
  }
}
