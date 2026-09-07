enum LeadTemperature { hot, warm, cold, newLead }

extension LeadTemperatureLabel on LeadTemperature {
  String get label {
    switch (this) {
      case LeadTemperature.hot:
        return 'Hot';
      case LeadTemperature.warm:
        return 'Warm';
      case LeadTemperature.cold:
        return 'Cold';
      case LeadTemperature.newLead:
        return 'New';
    }
  }
}

class Lead {
  const Lead({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.temperature,
    this.phone,
    this.email,
    this.whatsapp,
    this.pendingSync = false,
  });

  final String id;
  final String name;
  final String title; // e.g. "Marketing Head, Nova Textiles"
  final String company;
  final LeadTemperature temperature;
  final String? phone;
  final String? email;
  final String? whatsapp;

  // True while a lead captured offline hasn't synced to the server yet.
  final bool pendingSync;

  Lead copyWith({
    String? id,
    String? name,
    String? title,
    String? company,
    LeadTemperature? temperature,
    String? phone,
    String? email,
    String? whatsapp,
    bool? pendingSync,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      company: company ?? this.company,
      temperature: temperature ?? this.temperature,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }
}
