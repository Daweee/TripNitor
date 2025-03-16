import 'location_model.dart';
import 'location_service_data_model.dart';

class BookingLeg {
  final int id;
  final int legNumber;
  final Location startLocation;
  final Location endLocation;
  final DateTime? departureTime;
  final DateTime? arrivalTime;

  BookingLeg(
      {required this.id,
      required this.legNumber,
      required this.startLocation,
      required this.endLocation,
      this.departureTime,
      this.arrivalTime});

  factory BookingLeg.fromJson(Map<String, dynamic> json) {
    return BookingLeg(
        id: json['id'] as int,
        legNumber: json['leg_number'] as int,
        startLocation:
            Location.fromJson(json['start_location'] as Map<String, dynamic>),
        endLocation:
            Location.fromJson(json['end_location'] as Map<String, dynamic>),
        departureTime: json['departure_time'],
        arrivalTime: json['arrival_time']);
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
