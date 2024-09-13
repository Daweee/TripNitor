import 'location_model.dart';

class Leg {
  final int id;
  final int legNumber;
  final Location startLocation;
  final Location endLocation;
  final DateTime? departureTime;
  final DateTime? arrivalTime;

  Leg({
    required this.id,
    required this.legNumber,
    required this.startLocation,
    required this.endLocation,
    this.departureTime,
    this.arrivalTime,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      id: json['id'] as int,
      legNumber: json['leg_number'] as int,
      startLocation:
          Location.fromJson(json['start_location'] as Map<String, dynamic>),
      endLocation:
          Location.fromJson(json['end_location'] as Map<String, dynamic>),
      departureTime: json['departure_time'] != null
          ? DateTime.parse(json['departure_time'] as String)
          : null,
      arrivalTime: json['arrival_time'] != null
          ? DateTime.parse(json['arrival_time'] as String)
          : null,
    );
  }
}
