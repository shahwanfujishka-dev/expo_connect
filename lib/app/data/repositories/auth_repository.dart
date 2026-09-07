import 'package:dio/dio.dart' as dio;
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class AuthRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
    int remember = 0,
  }) async {
    final formData = dio.FormData.fromMap({
      'email': email,
      'password': password,
      'remember': remember,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.login,
      body: formData,
      authMode: AuthMode.none,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> logout() async {
    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.logout,
      authMode: AuthMode.header,
    );
  }
}
