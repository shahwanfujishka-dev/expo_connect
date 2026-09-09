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
}
