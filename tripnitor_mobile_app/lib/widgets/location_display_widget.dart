import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import '../models/location_service_data_model.dart';

class LocationDisplayWidget extends StatelessWidget {
  final LocationServiceData startLocation;
  final LocationServiceData finalLocation;

  const LocationDisplayWidget({
    Key? key,
    required this.startLocation,
    required this.finalLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: FontAwesomeIcons.solidCircleDot,
            iconColor: Color(0xFFFB0000),
            location: startLocation,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          _buildLocationRow(
            icon: FontAwesomeIcons.locationDot,
            iconColor: Colors.black,
            location: finalLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required LocationServiceData location,
  }) {
    final bool isNameEmpty = location.name.trim().isEmpty;

    return Row(
      children: [
        FaIcon(
          icon,
          color: iconColor,
          size: 16.0,
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isNameEmpty ? (location.address ?? '') : location.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (!isNameEmpty && location.address != null) ...[
                SizedBox(height: 4.0),
                Text(
                  location.address!,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.0,
                  ),
                ),
              ],
              if (isNameEmpty) SizedBox(height: 6.0),
            ],
          ),
        ),
      ],
    );
  }
}
