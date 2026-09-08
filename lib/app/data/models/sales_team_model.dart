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
  final int? companyId;
  final int? userId;
  final String role;
  final String? createdAt;
  final String? updatedAt;
  final int capturedCount;
  final int assignedCount;
  final int? convertedCount;
  final User? user;
  
  // New fields from details API
  final String? name;
  final String? email;
  final String? phone;
  final String? userType;
  final String? companyName;
  final int? totalLeadsCount;
  final String? avatar;

  SalesPerson({
    required this.id,
    this.companyId,
    this.userId,
    required this.role,
    this.createdAt,
    this.updatedAt,
    required this.capturedCount,
    required this.assignedCount,
    this.convertedCount,
    this.user,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.companyName,
    this.totalLeadsCount,
    this.avatar,
  });

  factory SalesPerson.fromJson(Map<String, dynamic> json) {
    return SalesPerson(
      id: json['id'],
      companyId: json['company_id'],
      userId: json['user_id'],
      role: json['role'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      capturedCount: json['captured_count'] ?? json['captured_leads_count'] ?? 0,
      assignedCount: json['assigned_count'] ?? json['assigned_leads_count'] ?? 0,
      convertedCount: json['converted_count'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: json['user_type'],
      companyName: json['company_name'],
      totalLeadsCount: json['total_leads_count'],
      avatar: json['avatar'],
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

class TeamPerformanceResponse {
  final bool success;
  final String message;
  final List<TeamMemberPerformance> members;
  final int totalLeads;

  TeamPerformanceResponse({
    required this.success,
    required this.message,
    required this.members,
    required this.totalLeads,
  });

  factory TeamPerformanceResponse.fromJson(Map<String, dynamic> json) {
    return TeamPerformanceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      members: (json['members'] as List?)
              ?.map((item) => TeamMemberPerformance.fromJson(item))
              .toList() ??
          [],
      totalLeads: json['total_leads'] ?? 0,
    );
  }
}

class TeamMemberPerformance {
  final String name;
  final String role;
  final int assigned;
  final int captured;
  final int converted;
  final num conversionRate;
  final num captureRate;
  final num shareOfTotal;

  TeamMemberPerformance({
    required this.name,
    required this.role,
    required this.assigned,
    required this.captured,
    required this.converted,
    required this.conversionRate,
    required this.captureRate,
    required this.shareOfTotal,
  });

  factory TeamMemberPerformance.fromJson(Map<String, dynamic> json) {
    return TeamMemberPerformance(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      assigned: json['assigned'] ?? 0,
      captured: json['captured'] ?? 0,
      converted: json['converted'] ?? 0,
      conversionRate: json['conversion_rate'] ?? 0,
      captureRate: json['capture_rate'] ?? 0,
      shareOfTotal: json['share_of_total'] ?? 0,
    );
  }
}
