import '../models/leg_model.dart';
import '../models/location_model.dart';
import '../models/location_service_data_model.dart';

class LocationTransformations {
  static LocationServiceData locationToLocationServiceData(Location data) {
    return LocationServiceData(
      mapboxId: '',
      name: data.name,
      address: data.address,
      latitude: data.latitude,
      longitude: data.longitude,
    );
  }

  static LocationCreate serviceDataToLocationCreate(LocationServiceData data) {
    final String name =
        data.name?.trim().isEmpty ?? true ? data.address ?? '' : data.name!;

    return LocationCreate(
      name: name,
      address: data.address ?? '',
      latitude: data.latitude!,
      longitude: data.longitude!,
    );
  }

  static LegCreate createLegFromLocations({
    int? legId,
    required int legNumber,
    required LocationServiceData startLoc,
    required LocationServiceData endLoc,
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) {
    return LegCreate(
      legId: legId,
      legNumber: legNumber,
      startLocation: serviceDataToLocationCreate(startLoc),
      endLocation: serviceDataToLocationCreate(endLoc),
    );
  }

  static List<LegCreate> createLegsFromStops({
    required LocationServiceData startLocation,
    required List<LocationServiceData> stops,
    required LocationServiceData finalLocation,
    List<LegCreate>? initialLegs,
  }) {
    List<LegCreate> legs = [];

    if (stops.isEmpty) {
      legs.add(createLegFromLocations(
        legNumber: 1,
        startLoc: startLocation,
        endLoc: finalLocation,
        legId: initialLegs?.firstOrNull?.legId,
      ));
      return legs;
    }

    legs.add(createLegFromLocations(
      legNumber: 1,
      startLoc: startLocation,
      endLoc: stops.first,
      legId: initialLegs?.firstOrNull?.legId,
    ));

    for (int i = 0; i < stops.length - 1; i++) {
      legs.add(createLegFromLocations(
        legNumber: i + 2,
        startLoc: stops[i],
        endLoc: stops[i + 1],
        legId: initialLegs?.elementAtOrNull(i + 1)?.legId,
      ));
    }

    legs.add(createLegFromLocations(
      legNumber: stops.length + 1,
      startLoc: stops.last,
      endLoc: finalLocation,
      legId: initialLegs?.lastOrNull?.legId,
    ));

    return legs;
  }
}
