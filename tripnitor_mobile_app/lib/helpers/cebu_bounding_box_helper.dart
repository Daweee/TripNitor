import 'package:latlong2/latlong.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import '../widgets/package_creation_widgets/search_location_page.dart';

class CebuBoundsHelper {
  static const Map<String, LatLng> regionalCenters = {
    'NORTH': CebuProvince.CEBU_NORTH_CENTER,
    'SOUTH': CebuProvince.CEBU_SOUTH_CENTER,
    'CITY': CebuProvince.CEBU_CITY_CENTER,
  };

  static const LatLng provincialCenter = LatLng(10.3157, 123.8854);

  static const Map<String, LatLng> cebuProvince = {
    'southwest': CebuProvince.CEBU_SOUTHWEST_CORNER,
    'northeast': CebuProvince.CEBU_NORTHEAST_CORNER,
  };

  static const Map<String, Map<String, LatLng>> regionalBounds = {
    'NORTH': {
      'southwest': CebuProvince.CEBU_NORTH_SOUTHWEST_CORNER,
      'northeast': CebuProvince.CEBU_NORTH_NORTHEAST_CORNER,
    },
    'SOUTH': {
      'southwest': CebuProvince.CEBU_SOUTH_SOUTHWEST_CORNER,
      'northeast': CebuProvince.CEBU_SOUTH_NORTHEAST_CORNER,
    },
    'CITY': {
      'southwest': CebuProvince.CEBU_CITY_SOUTHWEST_CORNER,
      'northeast': CebuProvince.CEBU_CITY_NORTHEAST_CORNER,
    },
  };

  static bool isWithinProvince(LatLng point) {
    return _isWithinBounds(
        point, cebuProvince['southwest']!, cebuProvince['northeast']!);
  }

  static bool isWithinRegion(LatLng point, String region) {
    if (!regionalBounds.containsKey(region)) return false;

    final bounds = regionalBounds[region]!;
    return _isWithinBounds(point, bounds['southwest']!, bounds['northeast']!);
  }

  static bool _isWithinBounds(LatLng point, LatLng sw, LatLng ne) {
    return point.latitude >= sw.latitude &&
        point.latitude <= ne.latitude &&
        point.longitude >= sw.longitude &&
        point.longitude <= ne.longitude;
  }

  static Map<String, LatLng> getBoundsForLocation({
    required LocationType locationType,
    String? packageType,
  }) {
    if (locationType == LocationType.start ||
        locationType == LocationType.end) {
      return cebuProvince;
    }

    if (locationType == LocationType.stop && packageType != null) {
      return regionalBounds[packageType] ?? cebuProvince;
    }

    return cebuProvince;
  }

  static LatLng getCenterPoint({
    required LocationType locationType,
    String? packageType,
  }) {
    if (locationType == LocationType.stop && packageType != null) {
      return regionalCenters[packageType] ?? provincialCenter;
    }

    return provincialCenter;
  }

  static String formatRegionalBounds(String region) {
    if (!regionalBounds.containsKey(region)) {
      throw ArgumentError('Invalid region: $region');
    }

    final bounds = regionalBounds[region]!;
    final southwest = bounds['southwest']!;
    final northeast = bounds['northeast']!;

    return '${southwest.longitude},${southwest.latitude},'
        '${northeast.longitude},${northeast.latitude}';
  }
}
