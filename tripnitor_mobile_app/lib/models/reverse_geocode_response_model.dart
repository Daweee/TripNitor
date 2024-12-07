class ReverseGeocodeResponseModel {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  ReverseGeocodeResponseModel({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory ReverseGeocodeResponseModel.fromJson(Map<String, dynamic> json) {
    return ReverseGeocodeResponseModel(
      name: json['name'] ?? '',
      address: json['address_line2'] ?? '',
      latitude: json['lat']?.toDouble() ?? 0.0,
      longitude: json['lon']?.toDouble() ?? 0.0,
    );
  }
}

class ReverseGeocodeResponseState {
  final ReverseGeocodeResponseModel? reverseGeocodeResponse;
  final bool isLoading;

  ReverseGeocodeResponseState(
      {this.reverseGeocodeResponse, this.isLoading = false});

  ReverseGeocodeResponseState copyWith(
      {ReverseGeocodeResponseModel? reverseGeocodeResponse, bool? isLoading}) {
    return ReverseGeocodeResponseState(
      reverseGeocodeResponse:
          reverseGeocodeResponse ?? this.reverseGeocodeResponse,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
