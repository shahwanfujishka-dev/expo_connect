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
  
  // Profile
  static const String myProfile = "/api/my-profile";
  static const String myQrCode = "/api/my-profile/my-qr-code";
  static const String changePassword = "/api/my-profile/change-password";
  static const String updateAvatar = "/api/my-profile/update-profile-picture";
  static const String removeAvatar = "/api/my-profile/remove-profile-picture";
  
  // Lead Capture
  static const String manualLeadCapture = "/api/lead-capture/manual";
  static const String scanQrCode = "/api/lead-capture/scan-qrcode";
  
  // Dashboard
  static const String dashboard = "/api/dashboard";

  // Leads
  static const String leads = "/api/lead";
  static const String leadShow = "/api/lead/show"; // Needs ID suffix

  // Sales Team
  static const String salesTeam = "/api/sales-team";
  static const String salesTeamPerformance = "/api/sales-team/performance";
  static String salesPersonDetails(int id) => "/api/sales-team/$id";

  // Dropdowns
  static const String eventsDropdown = "/api/dropdown/events";

  // Connect timeout
  static const int connectionTimeout = 30000;

  // Receive timeout
  static const int receiveTimeout = 30000;
}
