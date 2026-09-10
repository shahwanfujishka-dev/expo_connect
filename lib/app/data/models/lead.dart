class Lead {
  const Lead({
    required this.id,
    required this.name,
    required this.status_name,
    this.status_color,
    this.status_id,
    required this.title,
    required this.company,
    this.phone,
    this.email,
    this.whatsapp,
    this.pendingSync = false,
  });

  final String id;
  final String name;
  final String status_name;
  final String? status_color;
  final dynamic status_id;
  final String title; 
  final String company;
  final String? phone;
  final String? email;
  final String? whatsapp;

  final bool pendingSync;

  Lead copyWith({
    String? id,
    String? name,
    String? status_name,
    String? status_color,
    dynamic status_id,
    String? title,
    String? company,
    String? phone,
    String? email,
    String? whatsapp,
    bool? pendingSync,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      status_name: status_name ?? this.status_name,
      status_color: status_color ?? this.status_color,
      status_id: status_id ?? this.status_id,
      title: title ?? this.title,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }
}
