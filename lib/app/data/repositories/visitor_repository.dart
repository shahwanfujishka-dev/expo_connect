import '../providers/api_service.dart';
import '../services/endpoints.dart';

class VisitorRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<Map<String, dynamic>>> getVisitorDashboard(int expoId) async {
    return await _apiService.get<Map<String, dynamic>>(
      Endpoints.visitorDashboard,
      query: {'expo_id': expoId},
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getExhibitorDetails(int expoId, int companyId) async {
    return await _apiService.get<Map<String, dynamic>>(
      Endpoints.visitorExhibitorDetails,
      query: {
        'expo_id': expoId,
        'company_id': companyId,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> saveExhibitor(int expoId, int companyId) async {
    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.visitorSaveExhibitor,
      body: {
        'expo_id': expoId,
        'company_id': companyId,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> scanQrCode(String qrCode) async {
    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.visitorScanQrCode,
      body: {
        'qr_code': qrCode,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getContactBook(int expoId, {int isFavorite = 0}) async {
    return await _apiService.get<Map<String, dynamic>>(
      Endpoints.visitorContactBook,
      query: {
        'expo_id': expoId,
        'is_favorite': isFavorite,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateContactStatus(int id, String status) async {
    return await _apiService.patch<Map<String, dynamic>>(
      Endpoints.visitorContactStatus,
      query: {
        'id': id,
        'plan_status': status,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateContactFavorite(int id, int isFavorite) async {
    return await _apiService.patch<Map<String, dynamic>>(
      Endpoints.visitorContactFavorite,
      query: {
        'id': id,
        'is_favorite': isFavorite,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateContactNotes(int id, String notes) async {
    return await _apiService.patch<Map<String, dynamic>>(
      Endpoints.visitorContactNotes,
      query: {
        'id': id,
        'notes': notes,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> deleteContact(int id) async {
    return await _apiService.delete<Map<String, dynamic>>(
      Endpoints.visitorDeleteContact(id),
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> saveBrochure(int brochureId) async {
    return await _apiService.post<Map<String, dynamic>>(
      Endpoints.visitorSaveBrochure,
      body: {
        'brochure_id': brochureId,
      },
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> deleteBrochure(int brochureId) async {
    return await _apiService.delete<Map<String, dynamic>>(
      Endpoints.visitorDeleteBrochure(brochureId),
      authMode: AuthMode.header,
    );
  }
}
