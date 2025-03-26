import 'location_model.dart';
import 'location_service_data_model.dart';

class BookingLeg {
  final int id;
  final int legNumber;
  final Location startLocation;
  final Location endLocation;
  final bool isActive;
  final bool isCompleted;
  final DateTime? departureTime;
  final DateTime? arrivalTime;

  BookingLeg(
      {required this.id,
      required this.legNumber,
      required this.startLocation,
      required this.endLocation,
      required this.isActive,
      required this.isCompleted,
      this.departureTime,
      this.arrivalTime});

  DateTime? get localDepartureTime => departureTime?.toLocal();
  DateTime? get localArrivalTime => arrivalTime?.toLocal();

  factory BookingLeg.fromJson(Map<String, dynamic> json) {
    return BookingLeg(
      id: json['id'] as int,
      legNumber: json['leg_number'] as int,
      startLocation:
          Location.fromJson(json['start_location'] as Map<String, dynamic>),
      endLocation:
          Location.fromJson(json['end_location'] as Map<String, dynamic>),
      isActive: json['is_active'] as bool,
      isCompleted: json['is_completed'] as bool,
      departureTime: json['departure_time'] != null
          ? DateTime.parse(json['departure_time'])
          : null,
      arrivalTime: json['arrival_time'] != null
          ? DateTime.parse(json['arrival_time'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leg_number': legNumber,
      'start_location': startLocation.toJson(),
      'end_location': endLocation.toJson(),
    };
  }
}

class BookingLegState {
  final int? status;
  final BookingLeg? bookingLeg;
  final List<BookingLeg>? bookingLegList;
  final String? message;
  final bool isLoading;
  final String? error;

  BookingLegState({
    this.status,
    this.bookingLeg,
    this.bookingLegList,
    this.message,
    this.isLoading = false,
    this.error,
  });

  BookingLegState copyWith({
    int? status,
    BookingLeg? bookingLeg,
    List<BookingLeg>? bookingLegList,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return BookingLegState(
      status: status ?? this.status,
      bookingLeg: bookingLeg ?? this.bookingLeg,
      bookingLegList: bookingLegList ?? this.bookingLegList,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
