class Brochure {
  final int? id;
  final int? companyId;
  final String title;
  final String? filePath;
  final String fileType;
  final String? createdAt;
  final String? updatedAt;
  final int? savedByVisitorsCount;

  Brochure({
    this.id,
    this.companyId,
    required this.title,
    this.filePath,
    required this.fileType,
    this.createdAt,
    this.updatedAt,
    this.savedByVisitorsCount,
  });

  factory Brochure.fromJson(Map<String, dynamic> json) {
    return Brochure(
      id: json['id'],
      companyId: json['company_id'],
      title: json['title'] ?? '',
      filePath: json['file_path'],
      fileType: json['file_type'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      savedByVisitorsCount: json['saved_by_visitors_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'title': title,
      'file_path': filePath,
      'file_type': fileType,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'saved_by_visitors_count': savedByVisitorsCount,
    };
  }
}
