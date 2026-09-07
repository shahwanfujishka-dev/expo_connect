import 'package:dio/dio.dart' as dio;
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<Map<String, dynamic>>> getMyProfile() async {
    return await _apiService.get<Map<String, dynamic>>(
      Endpoints.myProfile,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateMyProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    return await _apiService.put<Map<String, dynamic>>(
      Endpoints.myProfile,
      query: {
        'name': name,
        'email': email,
        'phone': phone,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getMyQrCode() async {
    return await _apiService.get<Map<String, dynamic>>(
      Endpoints.myQrCode,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final formData = dio.FormData.fromMap({
      'current_password': currentPassword,
      'new_password': newPassword,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.changePassword,
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateAvatar(String filePath) async {
    final formData = dio.FormData.fromMap({
      'avatar': await dio.MultipartFile.fromFile(filePath, filename: 'avatar.jpg'),
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.updateAvatar,
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> removeAvatar() async {
    return await _apiService.delete<Map<String, dynamic>>(
      Endpoints.removeAvatar,
      authMode: AuthMode.header,
    );
  }
}
