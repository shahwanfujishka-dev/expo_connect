class Endpoints {
  static const String baseUrl = "https://fosgos.com/expo_connect";
  static const String register = "/api/registration/register";
  static const String verifyOtp = "/api/registration/verify-otp";
  static const String resendOtp = "/api/registration/resend-otp";
  static const String selectUserType = "/api/registration/user-type";
  static const String companyProfile = "/api/registration/company-profile";
  static const String visitorProfile = "/api/registration/user-profile";
  static const String login = "/api/auth/login";
  static const String logout = "/api/auth/logout";
  
  // Lead Capture
  static const String manualLeadCapture = "/api/lead-capture/manual";
  
  // Connect timeout
  static const int connectionTimeout = 30000;

  // Receive timeout
  static const int receiveTimeout = 30000;
}
