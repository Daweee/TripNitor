import 'location_model.dart';
import 'leg_model.dart';

class Package {
  final String id;
  final String packageName;
  final String description;
  final String basePrice;
  final String packageType;
  final String visibility;
  final Location startLocation;
  final Location finalDestination;
  final List<Leg> legs;
  final int? maxParticipants;
  final int? currentParticipants;
  final DateTime? startDate;
  final DateTime? endDate;

  Package({
    required this.id,
    required this.packageName,
    required this.description,
    required this.basePrice,
    required this.packageType,
    required this.visibility,
    required this.startLocation,
    required this.finalDestination,
    required this.legs,
    this.maxParticipants,
    this.currentParticipants,
    this.startDate,
    this.endDate,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      packageName: json['package_name'],
      description: json['description'],
      basePrice: json['base_price'],
      packageType: json['package_type'],
      visibility: json['visibility'],
      startLocation: Location.fromJson(json['start_location']),
      finalDestination: Location.fromJson(json['final_destination']),
      legs: (json['legs'] as List).map((leg) => Leg.fromJson(leg)).toList(),
      maxParticipants: json['max_participants'],
      currentParticipants: json['current_participants'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }
}

class PackageState {
  final List<Package> packages;
  final Package? selectedPackage;
  final bool isLoading;
  final String? error;
  final int? status;
  final String? message;

  PackageState({
    this.packages = const [],
    this.selectedPackage,
    this.isLoading = false,
    this.error,
    this.status,
    this.message,
  });

  PackageState copyWith({
    List<Package>? packages,
    Package? selectedPackage,
    bool? isLoading,
    String? error,
    int? status,
    String? message,
  }) {
    return PackageState(
      packages: packages ?? this.packages,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  factory PackageState.fromJson(Map<String, dynamic> json) {
    return PackageState(
      status: json['status'],
      message: json['message'],
      packages: (json['data']['packages'] as List).map((packageJson) => Package.fromJson(packageJson)).toList(),
      isLoading: false,
      error: null,
    );
  }

  factory PackageState.fromJsonSingle(Map<String, dynamic> json) {
    return PackageState(
      status: json['status'],
      message: json['message'],
      selectedPackage: Package.fromJson(json['data']),
      isLoading: false,
      error: null,
    );
  }
}