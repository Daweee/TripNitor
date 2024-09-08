import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/package_model.dart';
import '../services/package_service.dart';

class PackageNotifier extends StateNotifier<PackageState> {
    final PackageService _packageService;

    PackageNotifier(this._packageService) : super(PackageState());

    Future<void> getAllPackages() async {
        state = state.copyWith(isLoading: true);
        try {
            final response = await _packageService.getAllPackages();
            state = state.copyWith(
                packages: response,
                isLoading: false,
                error: null,
            );
    } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
        }
    }   

    Future<void> getPackageDetails(String packageId) async {
        state = state.copyWith(isLoading: true);
        try {
            final response = await _packageService.fetchPackageDetails(packageId);
            state = state.copyWith(
                selectedPackage: Package.fromJson(response),
                isLoading: false,
                error: null
            );
        } catch (e) {
            state = state.copyWith(isLoading: false, error: e.toString());
        }
    }
}

final packageProvider = StateNotifierProvider<PackageNotifier, PackageState>((ref) {
    final packageService = ref.watch(packageServiceProvider);
    return PackageNotifier(packageService);
});

final packageServiceProvider = Provider<PackageService>((ref) => PackageService());

final packageTypeFilterProvider = StateProvider<String?>((ref) => null);
final visibilityFilterProvider = StateProvider<String?>((ref) => null);

final filteredPackagesProvider = Provider<List<Package>>((ref) {
  final packageState = ref.watch(packageProvider);
  final typeFilter = ref.watch(packageTypeFilterProvider);
  final visibilityFilter = ref.watch(visibilityFilterProvider);

  final filteredPackages = packageState.packages.where((package) {
    final matchesType = typeFilter == null || package.packageType == typeFilter;
    final matchesVisibility = visibilityFilter == null || package.visibility == visibilityFilter;
    return matchesType && matchesVisibility;
  }).toList();
  
  return filteredPackages;
});
