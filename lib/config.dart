/// Configuration file for white-label customization
/// This allows easy customization of the app for different clients

class AppConfig {
  // Company Information
  static const String companyName = 'Sr Classic Coach';
  static const String companyTagline = 'Connecting East & Central Africa';
  
  // App Branding
  static const String appName = 'Sr Classic Coach';
  static const String appLogoPath = 'assets/images/app_icon.png';
  static const String splashLogoPath = 'assets/images/app_icon.png';
  
  // Colors
  static const int primaryColor = 0xFFE53E3E; // Red
  static const int secondaryColor = 0xFF2D3748; // Dark gray
  static const int accentColor = 0xFFF7FAFC; // Light gray
  
  // Contact Information
  static const String companyPhone = '+255 123 456 789';
  static const String companyEmail = 'info@srclassiccoach.com';
  static const String companyWebsite = 'www.srclassiccoach.com';
  
  // Social Media
  static const String whatsappNumber = '+255 123 456 789';
  static const String facebookPage = 'SrClassicCoach';
  static const String instagramHandle = '@srclassiccoach';
  
  // Features Configuration
  static const bool enableRealTimeTracking = false;
  static const bool enablePushNotifications = false;
  static const bool enableAnalytics = false;
  static const bool enableMultiLanguage = true;
  static const bool enableDarkMode = true;
  
  // API Configuration
  static const String baseApiUrl = 'https://api.srclassiccoach.com';
  static const String trackingApiEndpoint = '/track';
  static const String bookingApiEndpoint = '/book';
  
  // App Store Information
  static const String appStoreId = 'com.srclassiccoach.app';
  static const String playStoreId = 'com.srclassiccoach.app';
  
  // Support Information
  static const String supportEmail = 'support@srclassiccoach.com';
  static const String supportPhone = '+255 123 456 789';
  
  // Legal Information
  static const String privacyPolicyUrl = 'https://srclassiccoach.com/privacy';
  static const String termsOfServiceUrl = 'https://srclassiccoach.com/terms';
  
  // Customization Methods
  static void customizeForClient({
    required String clientName,
    required String clientLogoPath,
    required int clientPrimaryColor,
    required String clientPhone,
    required String clientEmail,
    required String clientWebsite,
  }) {
    // This method would be used to customize the app for different clients
    // In a real implementation, this would update the configuration dynamically
  }
  
  // Get client-specific configuration
  static Map<String, dynamic> getClientConfig(String clientId) {
    // This would return client-specific configuration from a database or API
    switch (clientId) {
      case 'client1':
        return {
          'companyName': 'Client 1 Transport',
          'primaryColor': 0xFF1E40AF, // Blue
          'logoPath': 'assets/images/client1_logo.png',
        };
      case 'client2':
        return {
          'companyName': 'Client 2 Logistics',
          'primaryColor': 0xFF059669, // Green
          'logoPath': 'assets/images/client2_logo.png',
        };
      default:
        return {
          'companyName': companyName,
          'primaryColor': primaryColor,
          'logoPath': appLogoPath,
        };
    }
  }
}
