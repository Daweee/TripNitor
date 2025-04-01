import 'booking_model.dart';
import 'driver_model.dart';

class DriverAssignment {
  int id;
  Booking booking;
  Driver driver;
  DateTime assignedAt;
  DateTime startDate;
  DateTime endDate;

  DriverAssignment({
    required this.id,
    required this.booking,
    required this.driver,
    required this.assignedAt,
    required this.startDate,
    required this.endDate,
  });

  factory DriverAssignment.fromJson(Map<String, dynamic> json) {
    try {
      return DriverAssignment(
        id: json["id"],
        booking: Booking.fromJson(json["booking"]),
        driver: Driver.fromJson(json["driver"]),
        assignedAt: DateTime.parse(json["assigned_at"]),
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
      );
    } catch (e) {
      throw FormatException('Error parsing DriverAssignment: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking": booking.toJson(),
        "driver": driver.toJson(),
        "assigned_at": assignedAt.toIso8601String(),
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
      };
}

class DriverAssignmentState {
  final int? status;
  final DriverAssignment? driverAssignment;
  final List<DriverAssignment>? driverAssignmentList;
  final List<Driver> availableDrivers;
  final String? message;
  final bool isLoading;
  final String? error;

  DriverAssignmentState({
    this.status,
    this.driverAssignment,
    this.driverAssignmentList,
    this.availableDrivers = const [],
    this.message,
    this.isLoading = false,
    this.error,
  });

  DriverAssignmentState copyWith({
    int? status,
    DriverAssignment? driverAssignment,
    List<DriverAssignment>? driverAssignmentList,
    List<Driver>? availableDrivers,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return DriverAssignmentState(
      status: status ?? this.status,
      driverAssignment: driverAssignment ?? this.driverAssignment,
      driverAssignmentList: driverAssignmentList ?? this.driverAssignmentList,
      availableDrivers: availableDrivers ?? this.availableDrivers,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'DriverAssignmentState(status: $status, driverAssignment: ${driverAssignment != null}, driverAssignmentList: ${driverAssignmentList?.length}, message: $message, isLoading: $isLoading, error: $error)';
  }
}
