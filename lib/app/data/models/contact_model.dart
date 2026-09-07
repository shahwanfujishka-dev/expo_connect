class ContactModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? company;
  String? note;

  ContactModel({this.id, this.name, this.email, this.phone, this.company, this.note});

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    company = json['company'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['company'] = company;
    data['note'] = note;
    return data;
  }
}
