import 'auth_model.dart';
import 'van_model.dart';

class Driver {
  final User user;
  final String licenseNumber;
  final DateTime dateHired;
  final Van van;

  Driver({
    required this.user,
    required this.licenseNumber,
    required this.dateHired,
    required this.van,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      user: User.fromJson(json['user']),
      licenseNumber: json['license_number'],
      dateHired: DateTime.parse(json['date_hired']),
      van: Van.fromJson(json['van']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': {
          'id': user.id,
          'username': user.username,
          'email': user.email,
          'name': user.name,
          'phone_number': user.phoneNumber,
          'role': user.role,
        },
        'license_number': licenseNumber,
        'date_hired': dateHired.toIso8601String(),
        'van': van.toJson(),
      };
}
