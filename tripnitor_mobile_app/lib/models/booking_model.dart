// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:tripnitor_mobile_app/models/preview_boking_model.dart';

import 'auth_model.dart';
import 'driver_model.dart';
import 'package_model.dart';

class Booking {
  final String id;
  final User user;
  final Package package;
  final List<Driver> drivers;
  final String status;
  final String totalPrice;
  final int numberOfPassengers;
  final String modeOfPayment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startDate;
  final DateTime endDate;

  Booking({
    required this.id,
    required this.user,
    required this.package,
    required this.drivers,
    required this.status,
    required this.totalPrice,
    required this.numberOfPassengers,
    required this.modeOfPayment,
    required this.createdAt,
    required this.updatedAt,
    required this.startDate,
    required this.endDate,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        user: User.fromJson(json["user"]),
        package: Package.fromJson(json["package"]),
        drivers:
            List<Driver>.from(json["drivers"].map((x) => Driver.fromJson(x))),
        status: json["status"],
        totalPrice: json["total_price"],
        numberOfPassengers: json["number_of_passengers"],
        modeOfPayment: json["mode_of_payment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
      );
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

  BookingCreationRequest({
    required this.user,
    required this.package,
    required this.assigned_drivers,
    required this.numberOfPassengers,
    required this.modeOfPayment,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
        "user": user,
        "package": package,
        "drivers": List<dynamic>.from(assigned_drivers.map((x) => x)),
        "number_of_passengers": numberOfPassengers,
        "mode_of_payment": modeOfPayment,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
      };
}
