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
      van: Van.fromJson(json['van_details']),
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

class DriverCreationResponse {
  String username;
  String name;
  String email;
  String phoneNumber;
  String licenseNumber;
  DateTime dateHired;
  String vanId;

  DriverCreationResponse({
    required this.username,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.dateHired,
    required this.vanId,
  });

  factory DriverCreationResponse.fromJson(Map<String, dynamic> json) =>
      DriverCreationResponse(
        username: json["username"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        licenseNumber: json["license_number"],
        dateHired: DateTime.parse(json["date_hired"]),
        vanId: json["van_id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "license_number": licenseNumber,
        "date_hired":
            "${dateHired.year.toString().padLeft(4, '0')}-${dateHired.month.toString().padLeft(2, '0')}-${dateHired.day.toString().padLeft(2, '0')}",
        "van_id": vanId,
      };
}

class DriverPatch {
  UserPatch? user;
  String? licenseNumber;
  String? dateHired;
  String? vanId;

  DriverPatch({
    this.user,
    this.licenseNumber,
    this.dateHired,
    this.vanId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'license_number': licenseNumber,
      'date_hired': dateHired,
      'van': vanId,
    };
  }
}

class DriverState {
  final int? status;
  final Driver? driver;
  DriverCreationResponse? driverCreationResponse;
  final List<Driver>? driverList;
  final String? message;
  final bool isLoading;
  final String? error;

  DriverState({
    this.status,
    this.driver,
    this.driverCreationResponse,
    this.driverList = const [],
    this.message,
    this.isLoading = false,
    this.error,
  });

  DriverState copyWith({
    int? status,
    Driver? driver,
    DriverCreationResponse? driverCreationResponse,
    List<Driver>? driverList,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return DriverState(
        status: status ?? this.status,
        driver: driver ?? this.driver,
        driverCreationResponse:
            driverCreationResponse ?? this.driverCreationResponse,
        driverList: driverList ?? this.driverList,
        message: message ?? this.message,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }
}
