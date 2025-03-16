import 'location_model.dart';
import 'location_service_data_model.dart';

class Leg {
  final int id;
  final int legNumber;
  final Location startLocation;
  final Location endLocation;

  Leg({
    required this.id,
    required this.legNumber,
    required this.startLocation,
    required this.endLocation,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      id: json['id'] as int,
      legNumber: json['leg_number'] as int,
      startLocation:
          Location.fromJson(json['start_location'] as Map<String, dynamic>),
      endLocation:
          Location.fromJson(json['end_location'] as Map<String, dynamic>),
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

class LegCreate {
  final int? legId;
  final int legNumber;
  final LocationCreate startLocation;
  final LocationCreate endLocation;

  LegCreate({
    this.legId,
    required this.legNumber,
    required this.startLocation,
    required this.endLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      if (legId != null) 'id': legId,
      'leg_number': legNumber,
      'start_location': startLocation.toJson(),
      'end_location': endLocation.toJson(),
    };
  }
}
