class RegistrationResponse {
  final bool success;
  final String message;
  final RegistrationData? data;

  RegistrationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RegistrationData.fromJson(json['data']) : null,
    );
  }
}

class RegistrationData {
  final String token;
  final String otpExpiresAt;

  RegistrationData({
    required this.token,
    required this.otpExpiresAt,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      token: json['token'] ?? '',
      otpExpiresAt: json['otp_expires_at'] ?? '',
    );
  }
}
