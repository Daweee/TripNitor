class LocationServiceData {
  final String mapboxId;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;

  LocationServiceData({
    required this.mapboxId,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory LocationServiceData.fromJson(Map<String, dynamic> json) {
    var coordinates = json['coordinates'] as Map<String, dynamic>?;
    return LocationServiceData(
      mapboxId: json['mapbox_id'] as String,
      name: json['name'] as String,
      address: json['full_address'] as String?,
      latitude: coordinates?['latitude'] as double?,
      longitude: coordinates?['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'full_address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class LocationServiceState {
  final int? status;
  final LocationServiceData? locationService;
  final List<LocationServiceData> locationServiceList;
  final String? message;
  final bool isLoading;
  final String? error;

  LocationServiceState({
    this.status,
    this.locationService,
    required this.locationServiceList,
    this.message,
    this.isLoading = false,
    this.error,
  });

  LocationServiceState copyWith({
    int? status,
    LocationServiceData? locationService,
    List<LocationServiceData>? locationServiceList,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return LocationServiceState(
      status: status ?? this.status,
      locationService: locationService ?? this.locationService,
      locationServiceList: locationServiceList ?? this.locationServiceList,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
