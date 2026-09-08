import '../models/sales_team_model.dart';
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class SalesTeamRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<SalesTeamResponse>> getSalesTeam() async {
    return _apiService.get<SalesTeamResponse>(
      Endpoints.salesTeam,
      parser: (json) => SalesTeamResponse.fromJson(json),
    );
  }

  Future<ApiResult<dynamic>> createSalesTeamMember({
    required String name,
    required String email,
    required String role,
  }) async {
    return _apiService.post<dynamic>(
      Endpoints.salesTeam,
      body: {
        'name': name,
        'email': email,
        'role': role,
      },
    );
  }
}
