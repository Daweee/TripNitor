import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:tripnitor_mobile_app/models/reverse_geocode_response_model_extension.dart';
import 'package:tripnitor_mobile_app/providers/geoapify_provider.dart';
import '../../constants/constant.dart';
import '../../helpers/cebu_bounding_box_helper.dart';
import '../../models/location_service_data_model.dart';
import '../../models/reverse_geocode_response_model.dart';
import '../../providers/geolocator_provider.dart';
import '../../providers/is_water_provider.dart';
import '../../services/location_service.dart';
import '../shimmer_reverse_geocoding_location.dart';
import 'search_location_page.dart';

class MapLocationPicker extends ConsumerStatefulWidget {
  final packageType;
  final LocationType locationType;
  final Function(LocationServiceData location) onLocationSelected;

  const MapLocationPicker({
    super.key,
    required this.packageType,
    required this.locationType,
    required this.onLocationSelected,
  });

  @override
  ConsumerState<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends ConsumerState<MapLocationPicker> {
  Timer? _debounceTimer;
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  late LatLng _currentLocation;
  final double _currentZoom = 15.0;
  bool _isMapReady = false;
  late final LatLngBounds _bounds;
  bool _isWithinBoundary = false;
  bool _showingDelayedShimmer = false;

  String get _getTitle {
    switch (widget.locationType) {
      case LocationType.start:
        return 'Pick Starting Point';
      case LocationType.stop:
        return 'Pick Stop Location';
      case LocationType.end:
        return 'Pick Destination';
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _debounceMapPosition() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer =
        Timer(const Duration(milliseconds: 500), _onMapPositionChanged);
  }

  @override
  void initState() {
    super.initState();

    _currentLocation = LatLng(10.3157, 123.8854);

    if (widget.locationType == LocationType.stop) {
      final boundingBox = CebuBoundsHelper.getBoundsForLocation(
        locationType: widget.locationType,
        packageType: widget.packageType,
      );

      _bounds = LatLngBounds(
        boundingBox['southwest']!,
        boundingBox['northeast']!,
      );

      final initialCenter = CebuBoundsHelper.getCenterPoint(
        locationType: widget.locationType,
        packageType: widget.packageType,
      );

      setState(() {
        _currentLocation = initialCenter;
      });
    } else {
      _bounds = LatLngBounds(
        NoBounds.WORLD_SOUTHWEST_CORNER,
        NoBounds.WORLD_NORTHEAST_CORNER,
      );

      _initializeUserLocation();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });

        final initialLocation = widget.locationType == LocationType.stop
            ? _currentLocation
            : await _getInitialLocation();

        final isWithinBoundary =
            await _locationService.isWithinBoundary(initialLocation);

        if (mounted) {
          setState(() {
            _isWithinBoundary = isWithinBoundary;
          });

          if (isWithinBoundary) {
            await Future.wait([
              ref
                  .read(geoapifyStateProvider.notifier)
                  .getAddressFromLatLng(initialLocation),
              ref.read(isWaterProvider.notifier).checkLocation(initialLocation)
            ]);

            _mapController.move(initialLocation, _currentZoom);
          }
        }
      }
    });
  }

  Future<void> _initializeUserLocation() async {
    try {
      await ref.read(geolocatorStateProvider.notifier).getCurrentLocation();
      final position = ref.read(geolocatorStateProvider).position;

      if (position != null && mounted) {
        final userLocation = LatLng(position.latitude, position.longitude);
        if (CebuBoundsHelper.isWithinProvince(userLocation)) {
          setState(() {
            _currentLocation = userLocation;
          });
        }
      }
    } catch (_) {}
  }

  Future<LatLng> _getInitialLocation() async {
    try {
      await ref.read(geolocatorStateProvider.notifier).getCurrentLocation();
      final position = ref.read(geolocatorStateProvider).position;
      return position != null
          ? LatLng(position.latitude, position.longitude)
          : _currentLocation;
    } catch (_) {
      return _currentLocation;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      await ref.read(geolocatorStateProvider.notifier).getCurrentLocation();

      if (!mounted) return;

      final geolocatorState = ref.watch(geolocatorStateProvider);

      if (geolocatorState.position != null) {
        final newLocation = LatLng(
          geolocatorState.position!.latitude,
          geolocatorState.position!.longitude,
        );

        final isWithinBoundary =
            await _locationService.isWithinBoundary(newLocation);

        if (!mounted) return;

        setState(() {
          _currentLocation = newLocation;
          _isWithinBoundary = isWithinBoundary;
        });

        if (isWithinBoundary) {
          _mapController.move(_currentLocation, _currentZoom);

          await ref.read(isWaterProvider.notifier).checkLocation(newLocation);

          final waterState = ref.read(isWaterProvider);

          if (waterState.isWater != null && !waterState.isWater!) {
            await ref
                .read(geoapifyStateProvider.notifier)
                .getAddressFromLatLng(newLocation);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Selected location is outside the service area')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _onMapPositionChanged() async {
    if (!mounted) return;
    LatLng center = _mapController.camera.center;

    setState(() {
      _showingDelayedShimmer = true;
    });

    if (widget.locationType == LocationType.stop) {
      if (!CebuBoundsHelper.isWithinRegion(center, widget.packageType)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Please select a location within ${widget.packageType} Cebu')),
        );
        return;
      }
    }

    final bool isWithinBoundary =
        await _locationService.isWithinBoundary(center);

    if (mounted) {
      setState(() {
        _isWithinBoundary = isWithinBoundary;
      });
    }

    if (mounted && isWithinBoundary) {
      await ref.read(isWaterProvider.notifier).checkLocation(center);

      final waterState = ref.read(isWaterProvider);

      if (waterState.isWater != null && !waterState.isWater!) {
        await ref
            .read(geoapifyStateProvider.notifier)
            .getAddressFromLatLng(center);
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _showingDelayedShimmer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final geoapifyState = ref.watch(geoapifyStateProvider);
    final waterState = ref.watch(isWaterProvider);

    final bool isLoading = geoapifyState.isLoading ||
        waterState.isLoading ||
        _showingDelayedShimmer;

    final bool isLocationValid = !isLoading &&
        geoapifyState.reverseGeocodeResponse != null &&
        waterState.isWater == false &&
        _isWithinBoundary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle,
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
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              keepAlive: true,
              minZoom: MapConfig.MIN_ZOOM,
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
              cameraConstraint: CameraConstraint.contain(bounds: _bounds),
              initialCenter: _currentLocation,
              initialZoom: _currentZoom,
              onMapEvent: (event) {
                if (_isMapReady && event.source == MapEventSource.onDrag) {
                  _debounceMapPosition();
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
            ],
          ),
          if (!_isMapReady)
            Center(
              child: CircularProgressIndicator(
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: FaIcon(
                FontAwesomeIcons.locationDot,
                color: Color(ColorConstants.PRIMARY_COLOR),
                size: 40,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isLoading)
                    Center(
                      child: ShimmerReverseGeocodingLocation(),
                    )
                  else if (waterState.isWater == true ||
                      _isWithinBoundary == false)
                    Text(
                      'This location is unserviceable',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else
                    Text(
                      [
                        geoapifyState.reverseGeocodeResponse?.name,
                        geoapifyState.reverseGeocodeResponse?.address,
                      ].where((e) => e != null && e.isNotEmpty).join(', '),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLocationValid
                        ? () {
                            final geocodeResponse =
                                geoapifyState.reverseGeocodeResponse!;
                            widget.onLocationSelected(
                              geocodeResponse.toLocationServiceData(),
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.5),
                      backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(ColorConstants.PRIMARY_COLOR),
                              ),
                            ),
                          )
                        : Text(
                            'Confirm Location',
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
          ),
          if (widget.locationType != LocationType.stop)
            Positioned(
              right: 16,
              bottom: 180,
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                backgroundColor: Colors.white,
                child: FaIcon(
                  FontAwesomeIcons.locationCrosshairs,
                  color: Color(ColorConstants.PRIMARY_COLOR),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
