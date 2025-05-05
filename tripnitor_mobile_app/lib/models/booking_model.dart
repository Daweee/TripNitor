import 'package:tripnitor_mobile_app/models/preview_boking_model.dart';
import 'auth_model.dart';
import 'booking_leg_model.dart';
import 'driver_model.dart';
import 'location_model.dart';
import 'package_model.dart';

class Booking {
  final String id;
  final User user;
  final Package package;
  final List<BookingLeg> bookingLeg;
  final Location? startLocation;
  final Location? finalDestination;
  final List<Driver> drivers;
  final String status;
  final dynamic baseFare;
  final String updatedPackageFare;
  final int numberOfNights;
  final String totalPrice;
  final int numberOfPassengers;
  final String modeOfPayment;
  final bool isRated;
  final int? ratings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime endDate;

  Booking({
    required this.id,
    required this.user,
    required this.package,
    required this.bookingLeg,
    this.startLocation,
    this.finalDestination,
    required this.drivers,
    required this.status,
    required this.baseFare,
    required this.updatedPackageFare,
    required this.numberOfNights,
    required this.totalPrice,
    required this.numberOfPassengers,
    required this.modeOfPayment,
    required this.isRated,
    this.ratings,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    required this.endDate,
  });

  DateTime? get localCreatedAt => createdAt.toLocal();

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        user: User.fromJson(json["user"]),
        package: Package.fromJson(json["package"]),
        bookingLeg: json['booking_legs'] != null
            ? List<BookingLeg>.from(
                json["booking_legs"].map((x) => BookingLeg.fromJson(x)))
            : [],
        startLocation: json['start_location'] != null
            ? Location.fromJson(json['start_location'])
            : null,
        finalDestination: json['final_destination'] != null
            ? Location.fromJson(json['final_destination'])
            : null,
        status: json["status"],
        baseFare: json["base_fare"],
        updatedPackageFare: json["updated_package_fare"],
        numberOfNights: json["number_of_nights"],
        totalPrice: json["total_price"],
        numberOfPassengers: json["number_of_passengers"],
        modeOfPayment: json["mode_of_payment"],
        isRated: json["is_rated"],
        ratings: json["ratings"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        drivers:
            List<Driver>.from(json["drivers"].map((x) => Driver.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "package": package.toJson(),
        "drivers": List<dynamic>.from(drivers.map((x) => x.toJson())),
        "status": status,
        "base_fare": baseFare,
        "updated_package_fare": updatedPackageFare,
        "number_of_nights": numberOfNights,
        "total_price": totalPrice,
        "number_of_passengers": numberOfPassengers,
        "mode_of_payment": modeOfPayment,
        "is_rated": isRated,
        "ratings": ratings,
        "created_at": createdAt.toUtc().toIso8601String(),
        "updated_at": updatedAt.toUtc().toIso8601String(),
        "start_date": startDate.toUtc().toIso8601String(),
        "end_date": endDate.toUtc().toIso8601String(),
      };
}

class BookingState {
  final BookingPreview? previewBooking;
  final Booking? booking;
  final List<Booking> bookingList;
  final bool isLoading;
  final String? error;
  final int? status;
  final String? message;

  BookingState({
    this.previewBooking,
    this.booking,
    this.bookingList = const [],
    this.isLoading = false,
    this.error,
    this.status,
    this.message,
  });

  BookingState copyWith({
    BookingPreview? previewBooking,
    Booking? booking,
    List<Booking>? bookingList,
    bool? isLoading,
    String? error,
    int? status,
    String? message,
  }) {
    return BookingState(
      previewBooking: previewBooking ?? this.previewBooking,
      booking: booking ?? this.booking,
      bookingList: bookingList ?? this.bookingList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class BookingCreationRequest {
  final String user;
  final String package;
  final List<String> assigned_drivers;
  final int numberOfPassengers;
  final String modeOfPayment;
  final DateTime startDate;
  final DateTime endDate;
  final double updatedPackageFare;
  final double totalPrice;

  BookingCreationRequest({
    required this.user,
    required this.package,
    required this.assigned_drivers,
    required this.numberOfPassengers,
    required this.modeOfPayment,
    required this.startDate,
    required this.endDate,
    required this.updatedPackageFare,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
        "user": user,
        "package": package,
        "drivers": List<dynamic>.from(assigned_drivers.map((x) => x)),
        "number_of_passengers": numberOfPassengers,
        "mode_of_payment": modeOfPayment,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "updated_package_fare": updatedPackageFare,
        "total_price": totalPrice,
      };
}
