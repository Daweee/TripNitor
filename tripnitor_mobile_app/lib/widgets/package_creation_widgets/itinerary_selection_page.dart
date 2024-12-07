import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../../constants/constant.dart';
import '../../helpers/location_transformation_help.dart';
import '../../models/location_service_data_model.dart';
import '../../services/map_service.dart';
import '../location_display_widget.dart';
import 'search_location_page.dart';
import 'itinerary_routes_page.dart';

class ItinerarySelectionPage extends StatefulWidget {
  final String packageType;
  final String packageVisibility;
  final String packageName;
  final String packageDescription;
  LocationServiceData startLocation;
  LocationServiceData finalLocation;

  ItinerarySelectionPage({
    super.key,
    required this.packageType,
    required this.packageVisibility,
    required this.packageName,
    required this.packageDescription,
    required this.startLocation,
    required this.finalLocation,
  });

  @override
  State<ItinerarySelectionPage> createState() => _ItinerarySelectionPageState();
}

class _ItinerarySelectionPageState extends State<ItinerarySelectionPage> {
  final MapService _mapService = MapService();
  final List<LocationServiceData?> stops = [null];
  static const int maxStops = 5;
  int get remainingStops => maxStops - stops.length;
  bool _isLoading = false;

  bool _shouldFetchLocationData(LocationServiceData location) {
    return location.mapboxId.isNotEmpty &&
        (location.latitude == null || location.longitude == null);
  }

  void addStop() {
    if (stops.length < maxStops) {
      setState(() {
        stops.add(null);
      });
    }
  }

  void removeStop(int index) {
    setState(() {
      stops.removeAt(index);
    });
  }

  void updateStop(int index, LocationServiceData location) {
    setState(() {
      stops[index] = location;
      if (stops.length < maxStops && index == stops.length - 1) {
        stops.add(null);
      }
    });
  }

  void _proceedToNextScreen() async {
    setState(() => _isLoading = true);

    try {
      if (_shouldFetchLocationData(widget.startLocation)) {
        widget.startLocation = await _mapService.getLocationData(
          widget.startLocation.mapboxId,
        );
      }

      if (_shouldFetchLocationData(widget.finalLocation)) {
        widget.finalLocation = await _mapService.getLocationData(
          widget.finalLocation.mapboxId,
        );
      }

      List<LocationServiceData> validStops = [];
      for (var stop in stops.where((s) => s != null)) {
        if (_shouldFetchLocationData(stop!)) {
          validStops.add(await _mapService.getLocationData(stop.mapboxId));
        } else {
          validStops.add(stop);
        }
      }

      final legs = LocationTransformations.createLegsFromStops(
        startLocation: widget.startLocation,
        stops: validStops,
        finalLocation: widget.finalLocation,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItineraryRoutesPage(
              packageType: widget.packageType,
              packageVisibility: widget.packageVisibility,
              packageName: widget.packageName,
              packageDescription: widget.packageDescription,
              startLocation: widget.startLocation,
              finalLocation: widget.finalLocation,
              itineraries: legs,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching location data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(stops.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add your itinerary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft,
              color: Colors.black, size: 20.0),
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
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LocationDisplayWidget(
              startLocation: widget.startLocation,
              finalLocation: widget.finalLocation,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: stops.length,
              itemBuilder: (context, index) {
                final bool showAddButton = index == stops.length - 1 &&
                    stops.length < maxStops &&
                    stops[index] != null;

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.PRIMARY_COLOR),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchLocationPage(
                                    packageType: widget.packageType,
                                    locationType: LocationType.stop,
                                    onLocationSelected: (location) =>
                                        updateStop(index, location),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (stops[index]?.name.trim().isNotEmpty ==
                                            true)
                                        ? stops[index]!.name
                                        : (stops[index]?.address ??
                                            'Add itinerary location'),
                                    style: TextStyle(
                                      color: stops[index] != null
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  if (stops[index]?.name.trim().isNotEmpty ==
                                      true) ...[
                                    SizedBox(height: 4),
                                    Text(
                                      stops[index]?.address ?? '',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (showAddButton) ...[
                        SizedBox(width: 12),
                        IconButton(
                          icon: Icon(Icons.add_circle,
                              color: Color(ColorConstants.PRIMARY_COLOR)),
                          onPressed: addStop,
                        ),
                      ],
                      if (stops.length > 1) ...[
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.grey),
                          onPressed: () => removeStop(index),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          if (remainingStops + 1 == maxStops) ...[
            Text(
              'You can add up to $remainingStops more places',
            ),
          ] else if (remainingStops > 0) ...[
            Text(
              'You can add $remainingStops ${remainingStops == 1 ? 'place' : 'more places'}',
            ),
          ] else
            ...[],
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToNextScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
