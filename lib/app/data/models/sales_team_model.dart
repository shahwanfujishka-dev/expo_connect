class SalesTeamResponse {
  final bool success;
  final String message;
  final List<SalesPerson> data;

  SalesTeamResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SalesTeamResponse.fromJson(Map<String, dynamic> json) {
    return SalesTeamResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => SalesPerson.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class SalesPerson {
  final int id;
  final int companyId;
  final int userId;
  final String role;
  final String createdAt;
  final String updatedAt;
  final int capturedCount;
  final int assignedCount;
  final int convertedCount;
  final User user;

  SalesPerson({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.capturedCount,
    required this.assignedCount,
    required this.convertedCount,
    required this.user,
  });

  factory SalesPerson.fromJson(Map<String, dynamic> json) {
    return SalesPerson(
      id: json['id'],
      companyId: json['company_id'],
      userId: json['user_id'],
      role: json['role'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      capturedCount: json['captured_count'] ?? 0,
      assignedCount: json['assigned_count'] ?? 0,
      convertedCount: json['converted_count'] ?? 0,
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String userType;

  User({
    required this.id,
    required this.name,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      userType: json['user_type'] ?? '',
    );
  }
}
