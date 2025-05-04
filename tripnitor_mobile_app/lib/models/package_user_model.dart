import 'auth_model.dart';
import 'package_model.dart';

class PackageUser {
  final int id;
  final User user;
  final Package package;
  final int numberOfPassengers;
  final DateTime joinedAt;

  PackageUser({
    required this.id,
    required this.user,
    required this.package,
    required this.numberOfPassengers,
    required this.joinedAt,
  });

  DateTime? get localCreatedAt => joinedAt.toLocal();

  factory PackageUser.fromJson(Map<String, dynamic> json) {
    return PackageUser(
        id: json['id'],
        user: User.fromJson(json['user']),
        package: Package.fromJson(json['package']),
        numberOfPassengers: json['number_of_passengers'],
        joinedAt: DateTime.parse(json['joined_at']));
  }
}
