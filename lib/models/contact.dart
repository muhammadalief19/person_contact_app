const String tableContact = 'contacts';

class ContactField {
  static const String id = 'id';
  static const String name = 'name';
  static const String phoneNumber = 'phoneNumber';
  static const String time = 'time';
}

class Contact {
  final int? id;
  final String name;
  final String phoneNumber;
  final DateTime createdTime;

  Contact(
      {this.id,
      required this.name,
      required this.phoneNumber,
      required this.createdTime});

  Contact copy(
      {int? id, String? name, String? phoneNumber, DateTime? createdTime}) {
    return Contact(
        id: id,
        name: name ?? this.name,
        phoneNumber: this.phoneNumber,
        createdTime: this.createdTime);
  }

  static Contact fromJson(Map<String, Object?> json) {
    return Contact(
        id: json[ContactField.id] as int?,
        name: json[ContactField.name] as String,
        phoneNumber: json[ContactField.phoneNumber] as String,
        createdTime: DateTime.parse(json[ContactField.time] as String));
  }

  Map<String, Object?> toJson() => {
        ContactField.id: id,
        ContactField.name: name,
        ContactField.phoneNumber: phoneNumber,
        ContactField.time: createdTime.toIso8601String(),
      };
}
