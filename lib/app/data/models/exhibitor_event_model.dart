class ExhibitorEventResponse {
  final bool success;
  final String message;
  final ExhibitorEventData? data;

  ExhibitorEventResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ExhibitorEventResponse.fromJson(Map<String, dynamic> json) {
    return ExhibitorEventResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ExhibitorEventData.fromJson(json['data']) : null,
    );
  }
}

class ExhibitorEventData {
  final int currentPage;
  final List<ExhibitorEventModel> data;
  final int? lastPage;
  final int? total;

  ExhibitorEventData({
    required this.currentPage,
    required this.data,
    this.lastPage,
    this.total,
  });

  factory ExhibitorEventData.fromJson(Map<String, dynamic> json) {
    return ExhibitorEventData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List?)
              ?.map((item) => ExhibitorEventModel.fromJson(item))
              .toList() ??
          [],
      lastPage: json['last_page'],
      total: json['total'],
    );
  }
}

class ExhibitorEventModel {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? venue;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? banner;
  final String? status;

  ExhibitorEventModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.venue,
    this.startDate,
    this.endDate,
    this.banner,
    this.status,
  });

  factory ExhibitorEventModel.fromJson(Map<String, dynamic> json) {
    return ExhibitorEventModel(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'],
      description: json['description'],
      venue: json['venue'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      banner: json['banner'],
      status: json['status'],
    );
  }
}
