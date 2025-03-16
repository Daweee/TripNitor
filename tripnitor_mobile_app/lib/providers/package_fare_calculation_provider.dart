import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/package_model.dart';
import '../services/package_service.dart';

class PackageFareCalculationProvider
    extends StateNotifier<PackageFareCalculationState> {
  final PackageService _packageService;

  PackageFareCalculationProvider(this._packageService)
      : super(PackageFareCalculationState());

  Future<void> calculatePackageFare(
      double totalDistance, PackageCreate package) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final calculatedPackageFare = await _packageService
          .calculatePackageFare(double.parse(totalDistance.toStringAsFixed(2)));

      print(calculatedPackageFare);
      final updatedPackage = package.copyWith(
        basePrice: calculatedPackageFare.toStringAsFixed(2),
      );

      state = state.copyWith(
        calculatedPackageFare: calculatedPackageFare,
        isLoading: false,
        error: null,
        updatedPackage: updatedPackage,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        calculatedPackageFare: null,
      );
    }
  }
}

final packageServiceProvider = Provider<PackageService>((ref) {
  return PackageService();
});

final packageFareCalculationProvider = StateNotifierProvider<
    PackageFareCalculationProvider, PackageFareCalculationState>((ref) {
  final service = ref.watch(packageServiceProvider);
  return PackageFareCalculationProvider(service);
});
