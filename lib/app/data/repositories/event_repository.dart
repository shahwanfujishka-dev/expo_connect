import 'package:dio/dio.dart' as dio;
import '../models/exhibitor_event_model.dart';
import '../providers/api_service.dart';
import '../services/endpoints.dart';

class EventRepository {
  final ApiService _apiService = ApiService.instance;

  Future<ApiResult<ExhibitorEventResponse>> getUpcomingEvents({int page = 1}) async {
    return await _apiService.get<ExhibitorEventResponse>(
      "${Endpoints.upcomingExpos}?page=$page",
      parser: (json) => ExhibitorEventResponse.fromJson(json),
    );
  }

  /// Creates a brand-new event with hall & stall in one shot.
  Future<ApiResult<EventCreationResult>> createEventWithHallStall({
    required String name,
    required String venue,
    required String description,
    required String startDate,
    required String endDate,
    required String hallName,
    required String stallNumber,
    dio.MultipartFile? banner,
  }) async {
    final formData = dio.FormData.fromMap({
      'name': name,
      'venue': venue,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'hall_name': hallName,
      'stall_number': stallNumber,
    });

    if (banner != null) {
      formData.files.add(MapEntry('banner', banner));
    }

    return await _apiService.post<EventCreationResult>(
      Endpoints.createEventWithHallStall,
      body: formData,
      parser: (json) => EventCreationResult.fromJson(json),
    );
  }

  /// GET /api/event/{eventId}/halls
  Future<ApiResult<HallListResponse>> getHalls(int eventId) async {
    return await _apiService.get<HallListResponse>(
      Endpoints.eventHalls(eventId),
      parser: (json) => HallListResponse.fromJson(json),
    );
  }

  /// POST /api/event/{eventId}/halls  body: { name }
  Future<ApiResult<HallModel>> createHall({
    required int eventId,
    required String name,
  }) async {
    return await _apiService.post<HallModel>(
      Endpoints.eventHalls(eventId),
      body: {'name': name},
      parser: (json) => HallModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// GET /api/event/{hallId}/stalls
  Future<ApiResult<StallListResponse>> getStalls(int hallId) async {
    return await _apiService.get<StallListResponse>(
      Endpoints.eventStalls(hallId),
      parser: (json) => StallListResponse.fromJson(json),
    );
  }

  /// POST /api/event/{hallId}/stalls  body: { stall_number }
  Future<ApiResult<StallModel>> createStall({
    required int hallId,
    required String stallNumber,
  }) async {
    return await _apiService.post<StallModel>(
      Endpoints.eventStalls(hallId),
      body: {'stall_number': stallNumber},
      parser: (json) => StallModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// POST /api/event/join  body: { expo_id, hall_id, stall_id }
  Future<ApiResult<dynamic>> joinEvent({
    required int expoId,
    required int hallId,
    required int stallId,
  }) async {
    return await _apiService.post(
      Endpoints.joinEvent,
      body: {
        'expo_id': expoId,
        'hall_id': hallId,
        'stall_id': stallId,
      },
    );
  }

  /// GET /api/event/{id}/joined-details
  Future<ApiResult<JoinedEventDetails>> getJoinedEventDetails(int id) async {
    return await _apiService.get<JoinedEventDetails>(
      Endpoints.joinedEventDetails(id),
      parser: (json) => JoinedEventDetails.fromJson(json['data']),
    );
  }

  /// POST /api/event/{id}/update-details
  Future<ApiResult<dynamic>> updateEventDetails({
    required int id,
    required String name,
    required String venue,
    required String description,
    required String startDate,
    required String endDate,
    required String status,
    dio.MultipartFile? banner,
  }) async {
    final formData = dio.FormData.fromMap({
      'name': name,
      'venue': venue,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
    });

    if (banner != null) {
      formData.files.add(MapEntry('banner', banner));
    }

    return await _apiService.post(
      Endpoints.updateEventDetails(id),
      body: formData,
    );
  }
}

class JoinedEventDetails {
  final ExhibitorEventModel expo;
  final bool isCreator;
  final int hallId;
  final String hallName;
  final int stallId;
  final String stallNumber;

  JoinedEventDetails({
    required this.expo,
    required this.isCreator,
    required this.hallId,
    required this.hallName,
    required this.stallId,
    required this.stallNumber,
  });

  factory JoinedEventDetails.fromJson(Map<String, dynamic> json) {
    return JoinedEventDetails(
      expo: ExhibitorEventModel.fromJson(json['expo']),
      isCreator: json['is_creator'] ?? false,
      hallId: json['hall_id'],
      hallName: json['hall_name'] ?? '',
      stallId: json['stall_id'],
      stallNumber: json['stall_number']?.toString() ?? '',
    );
  }
}

class HallModel {
  final int id;
  final String name;
  final int expoId;

  HallModel({
    required this.id,
    required this.name,
    required this.expoId,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      id: json['id'] as int,
      name: json['name'] as String,
      expoId: json['expo_id'] as int,
    );
  }
}

class StallModel {
  final int id;
  final String stallNumber;
  final int hallId;
  final String? companyName;

  StallModel({
    required this.id,
    required this.stallNumber,
    required this.hallId,
    this.companyName,
  });

  factory StallModel.fromJson(Map<String, dynamic> json) {
    return StallModel(
      id: json['id'] as int,
      stallNumber: json['stall_number']?.toString() ?? '',
      hallId: json['hall_id'] as int,
      companyName: json['company']?['name'] as String?,
    );
  }
}

class HallListResponse {
  final List<HallModel> halls;

  HallListResponse({required this.halls});

  factory HallListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = (json['data'] as List<dynamic>?) ?? const [];
    return HallListResponse(
      halls: rawList
          .map((e) => HallModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StallListResponse {
  final List<StallModel> stalls;

  StallListResponse({required this.stalls});

  factory StallListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = (json['data'] as List<dynamic>?) ?? const [];
    return StallListResponse(
      stalls: rawList
          .map((e) => StallModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class EventCreationResult {
  final int expoId;
  final int hallId;
  final int stallId;

  EventCreationResult({
    required this.expoId,
    required this.hallId,
    required this.stallId,
  });

  factory EventCreationResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return EventCreationResult(
      expoId: data['expo']['id'] as int,
      hallId: data['hall']['id'] as int,
      stallId: data['stall']['id'] as int,
    );
  }
}