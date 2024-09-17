import 'auth_model.dart';
import 'van_model.dart';

class Driver {
  final String id;
  final User user;
  final String licenseNumber;
  final DateTime dateHired;
  final Van van;

  Driver({
    required this.id,
    required this.user,
    required this.licenseNumber,
    required this.dateHired,
    required this.van,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json["id"],
      user: User.fromJson(json['user']),
      licenseNumber: json['license_number'],
      dateHired: DateTime.parse(json['date_hired']),
      van: Van.fromJson(json['van']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "license_number": licenseNumber,
        "date_hired":
            "${dateHired.year.toString().padLeft(4, '0')}-${dateHired.month.toString().padLeft(2, '0')}-${dateHired.day.toString().padLeft(2, '0')}",
        "van": van.toJson(),
      };
}

class DriverState {
  final int? status;
  final Driver? driver;
  final List<Driver>? driverList;
  final String? message;
  final bool isLoading;
  final String? error;

  DriverState({
    this.status,
    this.driver,
    this.driverList = const [],
    this.message,
    this.isLoading = false,
    this.error,
  });

  DriverState copyWith({
    int? status,
    Driver? driver,
    List<Driver>? driverList,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return DriverState(
        status: status ?? this.status,
        driver: driver ?? this.driver,
        driverList: driverList ?? this.driverList,
        message: message ?? this.message,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }
}
