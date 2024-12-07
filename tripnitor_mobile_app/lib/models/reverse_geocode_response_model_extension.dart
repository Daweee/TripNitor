import 'location_service_data_model.dart';
import 'reverse_geocode_response_model.dart';

extension ReverseGeocodeResponseModelExtension on ReverseGeocodeResponseModel {
  LocationServiceData toLocationServiceData() {
    return LocationServiceData(
      mapboxId: '',
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
