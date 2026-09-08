class EventDropdownResponse {
  final bool success;
  final String message;
  final EventData data;

  EventDropdownResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EventDropdownResponse.fromJson(Map<String, dynamic> json) {
    return EventDropdownResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: EventData.fromJson(json['data'] ?? {}),
    );
  }
}

class EventData {
  final List<EventModel> data;
  final int? total;

  EventData({
    required this.data,
    this.total,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      data: (json['data'] as List?)
              ?.map((item) => EventModel.fromJson(item))
              .toList() ??
          [],
      total: json['total'],
    );
  }
}

class EventModel {
  final int id;
  final String name;
  final String? slug;
  final String? venue;
  final String? status;

  EventModel({
    required this.id,
    required this.name,
    this.slug,
    this.venue,
    this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'],
      venue: json['venue'],
      status: json['status'],
    );
  }
}
