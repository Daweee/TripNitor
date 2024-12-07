import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constant.dart';

class CustomMarker {
  final LatLng point;
  final int index;
  final bool isItineraryLocation;

  const CustomMarker({
    required this.point,
    required this.index,
    required this.isItineraryLocation,
  });

  Marker buildMarker() {
    if (isItineraryLocation) {
      return Marker(
        width: 30.0,
        height: 30.0,
        point: point,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(ColorConstants.PRIMARY_COLOR),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    } else {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: point,
        child: Container(
          decoration: BoxDecoration(
            color:
                index == 0 ? Color(ColorConstants.PRIMARY_COLOR) : Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: index == 0 ? Color(0xFFB38428) : Colors.red.shade900,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.locationDot,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      );
    }
  }
}
