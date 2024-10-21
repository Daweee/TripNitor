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
  final String? totalDistance;

  Package(
      {required this.id,
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
      this.totalDistance});

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
      legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
      maxParticipants: json['max_participants'],
      currentParticipants: json['current_participants'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      totalDistance: json["total_distance"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'package_name': packageName,
      'description': description,
      'base_price': basePrice,
      'package_type': packageType,
      'visibility': visibility,
      'start_location': startLocation.toJson(),
      'final_destination': finalDestination.toJson(),
      'legs': List<dynamic>.from(legs.map((x) => x.toJson())),
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      "total_distance": totalDistance,
    };
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
      packages: (json['data']['packages'] as List)
          .map((packageJson) => Package.fromJson(packageJson))
          .toList(),
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
