import '../models/sales_team_model.dart';
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class SalesTeamRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<SalesTeamResponse>> getSalesTeam() async {
    return _apiService.get<SalesTeamResponse>(
      Endpoints.salesTeam,
      parser: (json) => SalesTeamResponse.fromJson(json),
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<SalesPerson>> getSalesPersonDetails(int id) async {
    return _apiService.get<SalesPerson>(
      Endpoints.salesPersonDetails(id),
      parser: (json) => SalesPerson.fromJson(json['data']),
      authMode: AuthMode.header,
    );
  }

  Future<ApiResult<TeamPerformanceResponse>> getTeamPerformance() async {
    return _apiService.get<TeamPerformanceResponse>(
      Endpoints.salesTeamPerformance,
      parser: (json) => TeamPerformanceResponse.fromJson(json),
      authMode: AuthMode.header,
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
      authMode: AuthMode.header,
    );
  }
}
