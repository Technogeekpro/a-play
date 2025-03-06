// App-wide configuration settings 

class AppConfig {
  static const String appName = 'A Play World';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const int apiTimeout = 30; // seconds
  static const String apiVersion = 'v1';
  
  // Cache Configuration
  static const Duration cacheDuration = Duration(hours: 24);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Image Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png'];
  
  // Date Formats
  static const String defaultDateFormat = 'yyyy-MM-dd';
  static const String defaultTimeFormat = 'HH:mm';
  static const String defaultDateTimeFormat = 'yyyy-MM-dd HH:mm';
} 