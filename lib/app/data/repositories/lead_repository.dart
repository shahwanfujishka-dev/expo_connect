import 'package:dio/dio.dart' as dio;
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class LeadRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<Map<String, dynamic>>> captureManualLead({
    required int expoId,
    required String name,
    required String email,
    required String phone,
    required String website,
    required String whatsapp,
    required String address,
    required String companyName,
    required String designation,
  }) async {
    final formData = dio.FormData.fromMap({
      'expo_id': expoId,
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
      'whatsapp': whatsapp,
      'address': address,
      'company_name': companyName,
      'designation': designation,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.manualLeadCapture,
      body: formData,
      authMode: AuthMode.header, // Using header auth mode as it requires bearer token
    );
  }
}
