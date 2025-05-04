import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/widgets/package_creation_widgets/itinerary_selection_page.dart';

import '../../core/constants/constant.dart';
import '../../helpers/location_transformation_help.dart';
import '../../models/leg_model.dart';
import '../../models/location_service_data_model.dart';
import 'location_selection_button.dart';
import 'search_location_page.dart';

class PackageStartFinalLocation extends StatefulWidget {
  final String packageType;
  final String packageVisibility;
  final String packageName;
  final String packageDescription;
  final bool isEditing;
  final LocationServiceData? initialStartLocation;
  final LocationServiceData? initialEndLocation;
  final List<Leg>? initialLegs;
  final String? packageId;
  final DateTime? startDate;
  final DateTime? endDate;

  const PackageStartFinalLocation({
    super.key,
    required this.packageType,
    required this.packageVisibility,
    required this.packageName,
    required this.packageDescription,
    this.isEditing = false,
    this.initialStartLocation,
    this.initialEndLocation,
    this.initialLegs,
    this.packageId,
    this.startDate,
    this.endDate,
  });

  @override
  State<PackageStartFinalLocation> createState() =>
      _PackageStartFinalLocationState();
}

class _PackageStartFinalLocationState extends State<PackageStartFinalLocation> {
  LocationServiceData? _startLocation;
  LocationServiceData? _endLocation;
  bool get _isFormValid => _startLocation != null && _endLocation != null;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _startLocation = widget.initialStartLocation;
      _endLocation = widget.initialEndLocation;

      //maybe do an api call for the package instance and extract Package legs from there?
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            widget.isEditing
                ? 'Edit Package Location'
                : '${widget.packageType} • ${widget.packageVisibility}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
              thickness: 1,
              height: 1,
            ),
          ),
        ),
      ),
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LocationSelectionButton(
              label: 'Starting Location',
              hint: (_startLocation?.name.trim().isNotEmpty == true)
                  ? _startLocation!.name
                  : (_startLocation?.address ?? 'Enter your starting point'),
              subtitle: (_startLocation?.address?.trim().isNotEmpty == true)
                  ? _startLocation?.address
                  : null,
              icon: FontAwesomeIcons.solidCircleDot,
              iconColor: Color(0xFFFB0000),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchLocationPage(
                      locationType: LocationType.start,
                      onLocationSelected: (location) {
                        setState(() {
                          _startLocation = location;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            LocationSelectionButton(
              label: 'Final Location',
              hint: (_endLocation?.name.trim().isNotEmpty == true)
                  ? _endLocation!.name
                  : (_endLocation?.address ?? 'Enter your destination point'),
              subtitle: (_endLocation?.name.trim().isNotEmpty == true)
                  ? _endLocation?.address
                  : null,
              icon: FontAwesomeIcons.locationDot,
              iconColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchLocationPage(
                      locationType: LocationType.end,
                      onLocationSelected: (location) {
                        setState(() {
                          _endLocation = location;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isFormValid
                  ? () {
                      List<LegCreate>? initialLegs;
                      if (widget.isEditing && widget.initialLegs != null) {
                        // Transform Leg to LegCreate
                        initialLegs = widget.initialLegs!.map((leg) {
                          return LegCreate(
                            legId: leg.id,
                            legNumber: leg.legNumber,
                            startLocation: LocationTransformations
                                .serviceDataToLocationCreate(
                                    LocationTransformations
                                        .locationToLocationServiceData(
                                            leg.startLocation)),
                            endLocation: LocationTransformations
                                .serviceDataToLocationCreate(
                                    LocationTransformations
                                        .locationToLocationServiceData(
                                            leg.endLocation)),
                          );
                        }).toList();
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItinerarySelectionPage(
                            packageId: widget.packageId,
                            packageType: widget.packageType,
                            packageVisibility: widget.packageVisibility,
                            packageName: widget.packageName,
                            packageDescription: widget.packageDescription,
                            startLocation: _startLocation!,
                            finalLocation: _endLocation!,
                            isEditing: widget.isEditing,
                            initialLegs: initialLegs,
                            startDate: widget.startDate,
                            endDate: widget.endDate,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                disabledBackgroundColor:
                    Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.5),
                disabledForegroundColor: Colors.white.withOpacity(0.5),
              ),
              child: Text(
                'Choose itineraries',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
