import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../services/endpoints.dart';
import '../local/storage_service.dart';

/// How the auth token should be attached to a request.
enum AuthMode {
  none,
  header,     // Authorization: Bearer <token>
  queryParam, // ?token=<token>
}

class ApiResult<T> {
  final bool success;
  final T? data;
  final ApiException? error;
  ApiResult.success(this.data) : success = true, error = null;
  ApiResult.failure(this.error) : success = false, data = null;
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  ApiException(this.message, {this.statusCode, this.data});
}

class ApiService {
  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: Endpoints.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: Endpoints.receiveTimeout),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('--- API REQUEST ---');
          print('➡️ METHOD: ${options.method}');
          print('➡️ URL: ${options.uri}');
          print('🔑 HEADERS: ${options.headers}');
          
          if (options.data != null) {
            if (options.data is FormData) {
              final formData = options.data as FormData;
              print('📦 BODY (FormData): ${Map.fromEntries(formData.fields)}');
            } else {
              print('📦 BODY: ${options.data}');
            }
          }
          print('-------------------');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('--- API RESPONSE ---');
          print('⬅️ STATUS: ${response.statusCode}');
          print('📄 DATA: ${response.data}');
          print('--------------------');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print('--- API ERROR ---');
          print('⛔ STATUS: ${e.response?.statusCode}');
          print('📄 ERROR DATA: ${e.response?.data}');
          print('-----------------');
          handler.next(e);
        },
      ),
    );
  }

  static final ApiService instance = ApiService._internal();
  late final Dio _dio;
  String? _authToken;

  void setToken(String? token) {
    _authToken = token;
  }

  /// Internal helper to build headers and inject token if needed
  Options _buildOptions(AuthMode authMode) {
    final headers = <String, dynamic>{'Accept': 'application/json'};

    if (authMode == AuthMode.header) {
      // Pull from memory or storage
      final token = _authToken ?? StorageService.getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return Options(headers: headers);
  }

  /// Internal helper to build query params and inject token if needed
  Map<String, dynamic> _buildQuery(Map<String, dynamic>? query, AuthMode authMode) {
    final q = <String, dynamic>{...?query};
    
    if (authMode == AuthMode.queryParam) {
      final token = _authToken ?? StorageService.getAuthToken();
      if (token != null) {
        q['token'] = token;
      }
    }
    
    return q;
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    AuthMode authMode = AuthMode.header, 
    T Function(dynamic json)? parser,
  }) {
    return _request<T>(
      () => _dio.post(
        path,
        data: body,
        queryParameters: _buildQuery(query, authMode),
        options: _buildOptions(authMode),
      ),
      parser: parser,
    );
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    AuthMode authMode = AuthMode.header,
    T Function(dynamic json)? parser,
  }) {
    return _request<T>(
      () => _dio.get(
        path,
        queryParameters: _buildQuery(query, authMode),
        options: _buildOptions(authMode),
      ),
      parser: parser,
    );
  }

  Future<ApiResult<T>> _request<T>(Future<Response> Function() call, {T Function(dynamic json)? parser}) async {
    try {
      final response = await call();
      final raw = response.data;
      final parsed = parser != null ? parser(raw) : raw as T;
      return ApiResult.success(parsed);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDioError(e));
    } catch (e) {
      return ApiResult.failure(ApiException('Something went wrong: $e'));
    }
  }

  ApiException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final data = e.response?.data;
      String? msg;
      if (data is Map) msg = data['message']?.toString();
      return ApiException(msg ?? 'Request failed', statusCode: e.response?.statusCode, data: data);
    }
    return ApiException(e.message ?? 'Network error');
  }
}
