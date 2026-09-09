import 'package:dio/dio.dart' as dio;
import '../models/registration_response.dart';
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class RegistrationRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<RegistrationResponse>> register(String email) async {
    final formData = dio.FormData.fromMap({
      'email': email,
    });

    return await _apiService.post<RegistrationResponse>(
      Endpoints.register,
      body: formData,
      authMode: AuthMode.none,
      parser: (json) => RegistrationResponse.fromJson(json),
    );
  }

  Future<ApiResult<Map<String, dynamic>>> verifyOtp(String token, String otp) async {
    final formData = dio.FormData.fromMap({
      'token': token,
      'otp': otp,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.verifyOtp,
      body: formData,
      authMode: AuthMode.none,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> resendOtp(String token) async {
    final formData = dio.FormData.fromMap({
      'token': token,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.resendOtp,
      body: formData,
      authMode: AuthMode.none,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> selectUserType(String token, String userType) async {
    final formData = dio.FormData.fromMap({
      'token': token,
      'user_type': userType,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.userType,
      body: formData,
      authMode: AuthMode.none,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> completeCompanyProfile({
    required String token,
    required String name,
    required String description,
    required String phone,
    required String whatsapp,
    required String address,
    required String website,
    required String country,
    required String category,
    required String password,
    String? logoPath,
  }) async {
    final Map<String, dynamic> data = {
      'token': token,
      'name': name,
      'description': description,
      'phone': phone,
      'whatsapp': whatsapp,
      'address': address,
      'website': website,
      'country': country,
      'category': category,
      'password': password,
    };

    if (logoPath != null) {
      data['logo'] = await dio.MultipartFile.fromFile(logoPath, filename: 'logo.jpg');
    }

    final formData = dio.FormData.fromMap(data);

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.companyProfile,
      body: formData,
      authMode: AuthMode.none,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> completeVisitorProfile({
    required String token,
    required String name,
    required String phone,
    required String whatsapp,
    required String password,
    String? avatarPath,
  }) async {
    final Map<String, dynamic> data = {
      'token': token,
      'name': name,
      'phone': phone,
      'whatsapp': whatsapp,
      'password': password,
    };

    if (avatarPath != null) {
      data['logo'] = await dio.MultipartFile.fromFile(avatarPath, filename: 'logo.jpg');
    }

    final formData = dio.FormData.fromMap(data);

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.visitorProfile,
      body: formData,
      authMode: AuthMode.none,
    );
  }
}
