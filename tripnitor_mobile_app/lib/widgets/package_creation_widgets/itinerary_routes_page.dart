import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/location_service_data_model.dart';
import 'package:tripnitor_mobile_app/models/package_model.dart';
import 'package:tripnitor_mobile_app/providers/route_polyline_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helpers/location_transformation_help.dart';
import '../../models/leg_model.dart';
import '../../models/location_model.dart';
import '../custom_marker.dart';

import 'package_confirmation_page.dart';

class ItineraryRoutesPage extends ConsumerStatefulWidget {
  final String packageType;
  final String packageVisibility;
  final String packageName;
  final String packageDescription;
  final LocationServiceData startLocation;
  final LocationServiceData finalLocation;
  final List<LegCreate> itineraries;

  const ItineraryRoutesPage({
    super.key,
    required this.packageType,
    required this.packageVisibility,
    required this.packageName,
    required this.packageDescription,
    required this.startLocation,
    required this.finalLocation,
    required this.itineraries,
  });

  @override
  ConsumerState<ItineraryRoutesPage> createState() =>
      _ItineraryRoutesPageState();
}

class _ItineraryRoutesPageState extends ConsumerState<ItineraryRoutesPage>
    with SingleTickerProviderStateMixin {
  DraggableScrollableController? _dragController;
  final MapController _mapController = MapController();
  late List<LatLng> markerCoordinates;
  bool isLoadingRoute = false;
  List<LatLng> _animatedPoints = [];
  final LatLng _currentLocation = LatLng(10.3119, 123.8854);
  late AnimationController _animationController;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animationController.addListener(() {
      if (!mounted) return;
      final routeState = ref.read(routeStateProvider);
      if (routeState.route?.coordinates != null && mounted) {
        setState(() {
          _animatedPoints =
              _calculateAnimatedPoints(_animationController.value);
        });
      }
    });

    markerCoordinates = [];

    if (widget.startLocation.latitude != null &&
        widget.startLocation.longitude != null) {
      markerCoordinates.add(LatLng(
        widget.startLocation.latitude!,
        widget.startLocation.longitude!,
      ));
    }

    for (var leg in widget.itineraries) {
      markerCoordinates
          .add(LatLng(leg.endLocation.latitude!, leg.endLocation.longitude!));
    }

    Future.microtask(() => _fetchRoute());
  }

  List<LatLng> _calculateAnimatedPoints(double progress) {
    final routeState = ref.read(routeStateProvider);
    if (routeState.route?.coordinates == null) return [];
    if (progress == 0) return [routeState.route!.coordinates[0][0]];

    List<LatLng> points = [];
    int totalPoints = routeState.route!.coordinates
        .fold(0, (sum, segment) => sum + segment.length);
    int targetPoints = (totalPoints * progress).round();
    int currentCount = 0;

    for (var segment in routeState.route!.coordinates) {
      if (currentCount >= targetPoints) break;

      int segmentPoints = min(segment.length, targetPoints - currentCount);
      points.addAll(segment.sublist(0, segmentPoints));
      currentCount += segmentPoints;
    }

    return points;
  }

  String _getLocationName(int index) {
    if (index == 0) return widget.startLocation.name;
    if (index == markerCoordinates.length - 1) return widget.finalLocation.name;
    return widget.itineraries[index - 1].endLocation.name;
  }

  String _getLocationAddress(int index) {
    if (index == 0) return widget.startLocation.address ?? 'No address';
    if (index == markerCoordinates.length - 1) {
      return widget.finalLocation.address ?? 'No address';
    }
    return widget.itineraries[index - 1].endLocation.address ?? 'No address';
  }

  void _createPackage() {
    final routeState = ref.read(routeStateProvider);

    final LocationCreate startLocation =
        LocationTransformations.serviceDataToLocationCreate(
            widget.startLocation);
    final LocationCreate finalLocation =
        LocationTransformations.serviceDataToLocationCreate(
            widget.finalLocation);

    final package = PackageCreate(
      packageName: widget.packageName,
      description: widget.packageDescription,
      packageType: widget.packageType,
      visibility: widget.packageVisibility,
      startLocation: startLocation,
      finalDestination: finalLocation,
      legs: widget.itineraries,
      totalDistance: routeState.totalDistance?.toStringAsFixed(2),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageConfirmationPage(
          package: package,
        ),
      ),
    );
  }

  Future<void> _fetchRoute() async {
    if (markerCoordinates.length < 2) return;
    if (!mounted) return;

    _animationController.reset();
    _animatedPoints = [];

    await ref.read(routeStateProvider.notifier).getRoute(markerCoordinates);

    if (!mounted) return;

    final routeState = ref.read(routeStateProvider);
    if (routeState.route != null) {
      _fitCameraToRoute();
      if (_mapReady && mounted) {
        _animationController.forward(from: 0);
      }
    }
  }

  void _fitCameraToRoute() {
    final routeState = ref.read(routeStateProvider);
    if (routeState.route?.coordinates == null ||
        routeState.route!.coordinates.isEmpty) {
      _fitCameraToMarkers();
      return;
    }

    List<LatLng> allPoints = [...markerCoordinates];
    for (var segment in routeState.route!.coordinates) {
      allPoints.addAll(segment);
    }

    final bounds = LatLngBounds.fromPoints(allPoints);

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(
          MapConfig.SIDE_PADDING,
          MapConfig.TOP_PADDING,
          MapConfig.SIDE_PADDING,
          MapConfig.BOTTOM_PADDING,
        ),
      ),
    );
  }

  void _fitCameraToMarkers() {
    if (markerCoordinates.isEmpty) return;

    if (markerCoordinates.length == 1) {
      _mapController.move(markerCoordinates.first, 13.0);
      return;
    }

    final bounds = LatLngBounds.fromPoints(markerCoordinates);

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.fromLTRB(
          MapConfig.SIDE_PADDING,
          MapConfig.TOP_PADDING,
          MapConfig.SIDE_PADDING,
          MapConfig.BOTTOM_PADDING,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animatedPoints = [];
    _animationController.dispose();
    _dragController?.dispose();
    super.dispose();
  }

  List<Marker> _buildMarkers() {
    return markerCoordinates.asMap().entries.map((entry) {
      final int index = entry.key;
      final bool isItineraryLocation =
          index > 0 && index < markerCoordinates.length - 1;

      return CustomMarker(
        point: entry.value,
        index: index,
        isItineraryLocation: isItineraryLocation,
      ).buildMarker();
    }).toList();
  }

  Widget _locationPoint({
    required String name,
    required String address,
    required IconData iconData,
    required Color iconColor,
    required double iconSize,
    required bool isMiniStop,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMiniStop ? 30.0 : 40.0,
            height: isMiniStop ? 30.0 : 40.0,
            decoration: BoxDecoration(
              color: isMiniStop
                  ? const Color(ColorConstants.PRIMARY_COLOR)
                  : (index == 0
                      ? const Color(ColorConstants.PRIMARY_COLOR)
                      : Colors.red),
              shape: BoxShape.circle,
              border: Border.all(
                color: isMiniStop
                    ? Colors.white
                    : (index == 0
                        ? const Color(0xFFB38428)
                        : Colors.red.shade900),
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
              child: isMiniStop
                  ? Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  : const FaIcon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.white,
                      size: 16,
                    ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.trim().isNotEmpty ? name : address,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isMiniStop ? null : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name.trim().isNotEmpty ? address : '',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDashLines() {
    return Row(
      children: [
        Container(
          width: 23,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0, left: 8.0),
            child: Dash(
              direction: Axis.vertical,
              length: 15,
              dashLength: 5,
              dashColor: Colors.black.withOpacity(.5),
              dashGap: 5,
              dashThickness: 2,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  List<Widget> _buildItineraryList() {
    List<Widget> itineraryWidgets = [];

    itineraryWidgets.add(
      _locationPoint(
        name: _getLocationName(0),
        address: _getLocationAddress(0),
        isMiniStop: false,
        iconData: FontAwesomeIcons.solidCircleDot,
        iconColor: const Color(0xFFFB0000),
        iconSize: 25.0,
        index: 0,
      ),
    );

    itineraryWidgets.add(_verticalDashLines());

    for (int i = 1; i < markerCoordinates.length - 1; i++) {
      itineraryWidgets.add(
        _locationPoint(
          name: _getLocationName(i),
          address: _getLocationAddress(i),
          isMiniStop: true,
          iconData: FontAwesomeIcons.solidCircleDot,
          iconColor: const Color(ColorConstants.PRIMARY_COLOR),
          iconSize: 15.0,
          index: i,
        ),
      );
      itineraryWidgets.add(_verticalDashLines());
    }

    itineraryWidgets.add(
      _locationPoint(
        name: _getLocationName(markerCoordinates.length - 1),
        address: _getLocationAddress(markerCoordinates.length - 1),
        isMiniStop: false,
        iconData: FontAwesomeIcons.locationDot,
        iconColor: Colors.black,
        iconSize: 28.0,
        index: markerCoordinates.length - 1,
      ),
    );

    return itineraryWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final routeState = ref.watch(routeStateProvider);

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              minZoom: MapConfig.MIN_ZOOM,
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
              onMapReady: () {
                _fitCameraToMarkers();
                _mapReady = true;
                if (routeState.route != null) {
                  _animationController.reset();
                  _animationController.forward(from: 0);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: MapboxConfig.TILES_BASE_URL,
                additionalOptions: {
                  'access_token': '${MapboxConfig.API_KEY}',
                },
                minZoom: MapConfig.MIN_ZOOM,
              ),
              PolylineLayer<Object>(
                polylines: routeState.route == null
                    ? []
                    : [
                        Polyline(
                          points: _animatedPoints,
                          color: const Color(ColorConstants.PRIMARY_COLOR),
                          strokeWidth: 8.0,
                          borderStrokeWidth: 2.0,
                          borderColor: Color(0xFF9D7212),
                        ),
                      ],
              ),
              MarkerLayer(
                markers: _buildMarkers(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.25,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: RichAttributionWidget(
                    permanentHeight: 20,
                    showFlutterMapAttribution: false,
                    alignment: AttributionAlignment.bottomLeft,
                    animationConfig: const ScaleRAWA(),
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright'),
                        ),
                      ),
                      TextSourceAttribution(
                        'Mapbox',
                        onTap: () => launchUrl(
                          Uri.parse('https://www.mapbox.com/about/maps/'),
                        ),
                      ),
                      TextSourceAttribution(
                        prependCopyright: false,
                        'Improve this map',
                        onTap: () => launchUrl(
                          Uri.parse('https://www.mapbox.com/map-feedback/'),
                        ),
                      ),
                      LogoSourceAttribution(
                        Image.asset('assets/images/mapbox-logo-black.png'),
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(routeStateProvider);
              if (state.isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(ColorConstants.PRIMARY_COLOR),
                    ),
                  ),
                );
              }
              if (state.error != null) {
                return Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.error!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _fetchRoute,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 5,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Color(ColorConstants.BACKGROUND_COLOR),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: const FaIcon(
                      FontAwesomeIcons.angleLeft,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            controller: _dragController,
            initialChildSize: 0.25,
            minChildSize: 0.25,
            maxChildSize: 0.8,
            snap: true,
            snapAnimationDuration: const Duration(milliseconds: 300),
            snapSizes: const [0.25],
            builder: (context, scrollController) {
              final state = ref.watch(routeStateProvider);
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (_dragController!.size < 0.8) {
                    return true;
                  }
                  return false;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                controller: scrollController,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Itinerary details',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            if (markerCoordinates.length >
                                                2) ...[
                                              TextSpan(
                                                text:
                                                    '${markerCoordinates.length - 2} ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              TextSpan(
                                                text: markerCoordinates.length -
                                                            2 ==
                                                        1
                                                    ? 'stop'
                                                    : 'stops',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' • ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                            if (state.totalDistance != null)
                                              TextSpan(
                                                text:
                                                    '${state.totalDistance!.toStringAsFixed(2)} km',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ..._buildItineraryList(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: SafeArea(
                                child: ElevatedButton(
                                  onPressed: _createPackage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        ColorConstants.PRIMARY_COLOR),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Proceed',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
