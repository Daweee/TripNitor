// ignore_for_file: constant_identifier_names
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';

class HTTPConstants {
//   static const String BASE_URL = 'http://192.168.254.161:8000/';
  static String? BASE_URL = dotenv.env['BASE_URL'];
}

class ColorConstants {
  static const int BACKGROUND_COLOR = 0xFFFFF2D9;
  static const int PRIMARY_COLOR = 0xFFC9963E;
  static const int SECONDARY_COLOR = 0xFFE7C17E;
  static const int TERTIARY_COLOR = 0xFFFFFBE8;
  static const int BOTTOM_PACKAGE_CARD_COLOR = 0xFFE5842A;
  static const int ACCENT_COLOR = 0xFFEEB85C;
  static const int ERROR_COLOR = 0xFFD32F2F;
  static const int SUCCESS_COLOR = 0xFF00B14F;
  static const int CANCEL_COLOR = 0xFFE67C73;
  static const int DISABLED_COLOR = 0xFFC5C5C5;
}

class GeoApifyConfig {
  static String? API_KEY = dotenv.env['API_KEY'];
  static String? REVERSE_GEOCODING_API_KEY =
      dotenv.env['REVERSE_GEOCODING_API_KEY'];
  static String? ROUTING_API_KEY = dotenv.env['ROUTING_API_KEY'];
  static const String BASE_URL = 'https://api.geoapify.com/v1';
}

class MapboxConfig {
  static String? API_KEY = dotenv.env['MAPBOX_API_KEY'];
  static const String SEARCH_BASE_URL =
      'https://api.mapbox.com/search/searchbox/v1';
  static const String TILES_BASE_URL =
      'https://api.mapbox.com/styles/v1/sndkngcs/cm3nalva000qm01r84blldnpe/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}';
}

class IsItWaterConfig {
  static String? API_KEY = dotenv.env['ISITWATER_API_KEY'];
  static const String ISITWATER_BASE_URL =
      'https://isitwater-com.p.rapidapi.com';
}

class CebuProvince {
  static const LatLng CEBU_SOUTHWEST_CORNER = LatLng(9.2399, 123.2473);
  static const LatLng CEBU_NORTHEAST_CORNER = LatLng(11.4215, 124.1614);

  static const LatLng CEBU_NORTH_SOUTHWEST_CORNER = LatLng(10.2833, 123.5044);
  static const LatLng CEBU_NORTH_NORTHEAST_CORNER = LatLng(11.3673, 124.1549);
  static const LatLng CEBU_NORTH_CENTER = LatLng(10.5916, 124.0181);

  static const LatLng CEBU_SOUTH_SOUTHWEST_CORNER = LatLng(9.4288, 123.3465);
  static const LatLng CEBU_SOUTH_NORTHEAST_CORNER = LatLng(10.3213, 123.7845);
  static const LatLng CEBU_SOUTH_CENTER = LatLng(9.8816, 123.6054);

  static const LatLng CEBU_CITY_SOUTHWEST_CORNER = LatLng(10.2688, 123.8159);
  static const LatLng CEBU_CITY_NORTHEAST_CORNER = LatLng(10.3914, 123.9515);
  static const LatLng CEBU_CITY_CENTER = LatLng(10.3301, 123.8837);
}

class SearchConfig {
  static const String LANGUAGE = 'en';
  static const String COUNTRY = 'ph';
  static const String CEBU_BOUNDING_BOX = '123.2473,9.2399,124.1614,11.4215';
  static const String PROXIMITY = '-73.990593,40.740121';
}

class MapConfig {
  static const double MIN_ZOOM = 4.0;
  static const double TOP_PADDING = 50.0;
  static const double SIDE_PADDING = 50.0;
  static const double BOTTOM_PADDING = 250.0;
}
