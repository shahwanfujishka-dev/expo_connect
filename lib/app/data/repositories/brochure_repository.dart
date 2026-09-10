import 'package:dio/dio.dart' as dio;
import '../models/brochure_model.dart';
import '../providers/api_service.dart';

class BrochureRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<List<Brochure>>> getBrochures() async {
    return await _apiService.get<List<Brochure>>(
      '/api/brochures',
      parser: (json) {
        if (json['data'] is List) {
          return (json['data'] as List)
              .map((item) => Brochure.fromJson(item))
              .toList();
        }
        return [];
      },
    );
  }

  Future<ApiResult<Brochure>> addBrochure({
    required String title,
    required String filePath,
    required String fileType,
  }) async {
    final formData = dio.FormData.fromMap({
      'title': title,
      'file_type': fileType,
      'file': await dio.MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    return await _apiService.post<Brochure>(
      '/api/brochures',
      body: formData,
      parser: (json) => Brochure.fromJson(json['data']),
    );
  }

  Future<ApiResult<void>> deleteBrochure(int id) async {
    return await _apiService.delete<void>(
      '/api/brochures/$id',
    );
  }
}
