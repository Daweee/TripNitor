import '../models/leg_model.dart';
import '../models/location_model.dart';
import '../models/location_service_data_model.dart';

class LocationTransformations {
  static LocationCreate serviceDataToLocationCreate(LocationServiceData data) {
    return LocationCreate(
      name: data.name,
      address: data.address ?? '',
      latitude: data.latitude!,
      longitude: data.longitude!,
    );
  }

  static LegCreate createLegFromLocations({
    required int legNumber,
    required LocationServiceData startLoc,
    required LocationServiceData endLoc,
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) {
    return LegCreate(
      legNumber: legNumber,
      startLocation: serviceDataToLocationCreate(startLoc),
      endLocation: serviceDataToLocationCreate(endLoc),
      departureTime: departureTime,
      arrivalTime: arrivalTime,
    );
  }

  static List<LegCreate> createLegsFromStops({
    required LocationServiceData startLocation,
    required List<LocationServiceData> stops,
    required LocationServiceData finalLocation,
  }) {
    List<LegCreate> legs = [];

    if (stops.isEmpty) {
      legs.add(createLegFromLocations(
        legNumber: 1,
        startLoc: startLocation,
        endLoc: finalLocation,
      ));
      return legs;
    }

    legs.add(createLegFromLocations(
      legNumber: 1,
      startLoc: startLocation,
      endLoc: stops.first,
    ));

    for (int i = 0; i < stops.length - 1; i++) {
      legs.add(createLegFromLocations(
        legNumber: i + 2,
        startLoc: stops[i],
        endLoc: stops[i + 1],
      ));
    }

    legs.add(createLegFromLocations(
      legNumber: stops.length + 1,
      startLoc: stops.last,
      endLoc: finalLocation,
    ));

    return legs;
  }
}
