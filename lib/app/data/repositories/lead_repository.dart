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
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> scanQrCode(String qrCode) async {
    final formData = dio.FormData.fromMap({
      'qr_code': qrCode,
    });

    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.scanQrCode,
      body: formData,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getDashboardData() async {
    return await _apiService.get<Map<String, dynamic>>(
      Endpoints.dashboard,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getAllLeads() async {
    return await _apiService.get<Map<String, dynamic>>(
      Endpoints.leads,
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getLeadDetails(String id) async {
    return await _apiService.get<Map<String, dynamic>>(
      "${Endpoints.leadShow}/$id",
      authMode: AuthMode.header,
    );
  }
}
