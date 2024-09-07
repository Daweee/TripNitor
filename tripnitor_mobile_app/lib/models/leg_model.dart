import 'location_model.dart';

class Leg {
  final int id;
  final int legNumber;
  final Location startLocation;
  final Location endLocation;
  final DateTime departureTime;
  final DateTime arrivalTime;

  Leg({
    required this.id,
    required this.legNumber,
    required this.startLocation,
    required this.endLocation,
    required this.departureTime,
    required this.arrivalTime,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      id: json['id'],
      legNumber: json['leg_number'],
      startLocation: Location.fromJson(json['start_location']),
      endLocation: Location.fromJson(json['end_location']),
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
    );
  }
}