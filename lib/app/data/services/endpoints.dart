class Endpoints {
  static const String baseUrl = "https://fosgos.com/expo_connect";
  static const String storageUrl = "$baseUrl/public/storage/";

  // Auth
  static const String register = "/api/registration/register";
  static const String verifyOtp = "/api/registration/verify-otp";
  static const String resendOtp = "/api/registration/resend-otp";
  static const String userType = "/api/registration/user-type";
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
  static const String visitorScanQrCode = "/api/visitor/lead-capture/scan-qrcode";
  
  // Dashboard
  static const String dashboard = "/api/dashboard";
  static const String visitorDashboard = "/api/visitor/dashboard";
  static const String visitorExhibitorDetails = "/api/visitor/dashboard/show";
  static const String visitorSaveExhibitor = "/api/visitor/dashboard/save";

  // Contacts
  static const String visitorContactBook = "/api/visitor/contact-book";
  static const String visitorContactStatus = "/api/visitor/contact-book/status";
  static const String visitorContactFavorite = "/api/visitor/contact-book/favorite";
  static const String visitorContactNotes = "/api/visitor/contact-book/notes";
  static String visitorDeleteContact(int id) => "/api/visitor/contact-book/$id";

  // Brochures
  static const String visitorSaveBrochure = "/api/visitor/brochures";
  static String visitorDeleteBrochure(int id) => "/api/visitor/brochures/$id";

  // Leads
  static const String leads = "/api/lead";
  static const String leadShow = "/api/lead/show"; // Needs ID suffix

  // Sales Team
  static const String salesTeam = "/api/sales-team";
  static const String salesTeamPerformance = "/api/sales-team/performance";
  static String salesPersonDetails(int id) => "/api/sales-team/$id";

  // Dropdowns
  static const String eventsDropdown = "/api/dropdown/events";
  static const String leadStatusDropdown = "/api/dropdown/lead-status";
  static const String salesPersonsDropdown = "/api/dropdown/sales-persons";

  // Events
  static const String upcomingExpos = "/api/event/upcoming";
  static const String createEventWithHallStall = "/api/event/create-with-hall-stall";
  static String eventHalls(int id) => "/api/event/$id/halls";
  static String eventStalls(int hallId) => "/api/event/$hallId/stalls";
  static const String joinEvent = "/api/event/join";
  static String joinedEventDetails(int id) => "/api/event/$id/joined-details";
  static String updateEventDetails(int id) => "/api/event/$id/update-details";

  // Connect timeout
  static const int connectionTimeout = 30000;

  // Receive timeout
  static const int receiveTimeout = 30000;
}
