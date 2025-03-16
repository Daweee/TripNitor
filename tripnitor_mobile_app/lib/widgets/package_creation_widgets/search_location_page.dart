import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/helpers/cebu_bounding_box_helper.dart';
import '../../core/constants/constant.dart';
import '../../models/location_service_data_model.dart';
import '../../providers/map_provider.dart';
import '../location_tile_shimmer.dart';
import 'map_location_picker.dart';

enum LocationType { start, stop, end }

class SearchLocationPage extends ConsumerStatefulWidget {
  final packageType;
  final LocationType locationType;
  final Function(LocationServiceData locationData) onLocationSelected;

  const SearchLocationPage({
    super.key,
    this.packageType,
    required this.locationType,
    required this.onLocationSelected,
  });

  @override
  ConsumerState<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends ConsumerState<SearchLocationPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  void performSearch(String query) async {
    if (query.isEmpty) {
      ref.read(mapStateProvider.notifier).clearSearchResults();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        if (widget.locationType != LocationType.stop) {
          ref.read(mapStateProvider.notifier).searchLocations(
                query,
                SearchConfig.LANGUAGE,
                SearchConfig.COUNTRY,
                SearchConfig.PROXIMITY,
                SearchConfig.CEBU_BOUNDING_BOX,
              );
        }
        if (widget.packageType != null) {
          ref.read(mapStateProvider.notifier).searchLocations(
                query,
                SearchConfig.LANGUAGE,
                SearchConfig.COUNTRY,
                SearchConfig.PROXIMITY,
                CebuBoundsHelper.formatRegionalBounds(widget.packageType),
              );
        }
      } catch (e) {
        _handleError(e);
      }
    });
  }

  void _handleError(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error searching for locations: ${error.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _getTitle() {
    switch (widget.locationType) {
      case LocationType.start:
        return 'Select Starting Point';
      case LocationType.stop:
        return 'Add Locations';
      case LocationType.end:
        return 'Select Destination';
    }
  }

  Widget _buildLocationTile(
      String mapboxId, String location, String? address, IconData icon) {
    return ListTile(
      leading:
          FaIcon(icon, size: 16, color: Color(ColorConstants.PRIMARY_COLOR)),
      title: Text(location),
      subtitle: Text(
        address ?? '',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      onTap: () {
        widget.onLocationSelected(
          LocationServiceData(
              mapboxId: mapboxId, name: location, address: address),
        );
        ref.read(mapStateProvider.notifier).clearSearchResults();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapStateProvider);
    print(widget.packageType);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(),
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
          onPressed: () {
            ref.read(mapStateProvider.notifier).clearSearchResults();
            Navigator.pop(context);
          },
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
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search location',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          performSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: performSearch,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mapState.isLoading) ...[
                    LocationTileShimmer(count: 5)
                  ] else if (_searchController.text.isNotEmpty &&
                      mapState.locationServiceList.isNotEmpty) ...[
                    ...mapState.locationServiceList.map(
                      (location) => _buildLocationTile(
                          location.mapboxId,
                          location.name,
                          location.address,
                          FontAwesomeIcons.locationDot),
                    ),
                  ] else if (_searchController.text.isNotEmpty &&
                      mapState.locationServiceList.isEmpty) ...[
                    Center(
                      child: Text('No results found.'),
                    ),
                  ] else if (widget.packageType != null) ...[
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Results will show places within ',
                          children: <TextSpan>[
                            TextSpan(
                                text: '${widget.packageType}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: ' only.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapLocationPicker(
                        packageType: widget.packageType,
                        locationType: widget.locationType,
                        onLocationSelected: widget.onLocationSelected,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.locationCrosshairs,
                        size: 16,
                        color: Color(ColorConstants.PRIMARY_COLOR),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Choose on Map',
                        style: TextStyle(
                          color: Color(ColorConstants.PRIMARY_COLOR),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
