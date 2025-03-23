import 'location_model.dart';
import 'leg_model.dart';
import 'location_service_data_model.dart';

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

  DateTime? get locatStartDate => startDate?.toLocal();
  DateTime? get localEndDate => endDate?.toLocal();

  factory Package.fromJson(Map<String, dynamic> json) {
    int? maxParticipants;
    if (json['max_participants'] != null) {
      if (json['max_participants'] is String) {
        maxParticipants = int.tryParse(json['max_participants']);
      } else {
        maxParticipants = json['max_participants'] as int;
      }
    }

    int? currentParticipants;
    if (json['current_participants'] != null) {
      if (json['current_participants'] is String) {
        currentParticipants = int.tryParse(json['current_participants']);
      } else {
        currentParticipants = json['current_participants'] as int;
      }
    }

    return Package(
      id: json['id'],
      packageName: json['package_name'],
      description: json['description'],
      basePrice: json['base_price'],
      packageType: json['package_type'],
      visibility: json['visibility'],
      startLocation: Location.fromJson(json['start_location']),
      finalDestination: Location.fromJson(json['final_destination']),
      legs: json['legs'] != null
          ? List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x)))
          : [],
      maxParticipants: maxParticipants,
      currentParticipants: currentParticipants,
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
      'start_date': startDate?.toUtc().toIso8601String(),
      'end_date': endDate?.toUtc().toIso8601String(),
      "total_distance": totalDistance,
    };
  }
}

class PackageCreate {
  final String packageName;
  final String description;
  final String? basePrice;
  final String packageType;
  final String visibility;
  final LocationCreate startLocation;
  final LocationCreate finalDestination;
  final List<LegCreate> legs;
  final int? maxParticipants;
  final int? currentParticipants;
  final DateTime? startDate;
  final DateTime? endDate;
  final num totalDistance;

  PackageCreate({
    required this.packageName,
    required this.description,
    this.basePrice,
    required this.packageType,
    required this.visibility,
    required this.startLocation,
    required this.finalDestination,
    required this.legs,
    this.maxParticipants,
    this.currentParticipants,
    this.startDate,
    this.endDate,
    required this.totalDistance,
  });

  Map<String, dynamic> toJson() {
    // Ensure numeric fields are properly formatted
    final Map<String, dynamic> json = {
      'package_name': packageName,
      'description': description,
      'base_price': basePrice,
      'package_type': packageType,
      'visibility': visibility,
      'start_location': startLocation.toJson(),
      'final_destination': finalDestination.toJson(),
      'legs': List<dynamic>.from(legs.map((x) => x.toJson())),
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'total_distance': totalDistance,
    };

    // Only include participants if they are not null
    if (maxParticipants != null) {
      json['max_participants'] = maxParticipants;
    }
    if (currentParticipants != null) {
      json['current_participants'] = currentParticipants;
    }

    return json;
  }

  PackageCreate copyWith({
    String? packageName,
    String? description,
    String? basePrice,
    String? packageType,
    String? visibility,
    LocationCreate? startLocation,
    LocationCreate? finalDestination,
    List<LegCreate>? legs,
    int? maxParticipants,
    int? currentParticipants,
    DateTime? startDate,
    DateTime? endDate,
    num? totalDistance,
  }) {
    return PackageCreate(
      packageName: packageName ?? this.packageName,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      packageType: packageType ?? this.packageType,
      visibility: visibility ?? this.visibility,
      startLocation: startLocation ?? this.startLocation,
      finalDestination: finalDestination ?? this.finalDestination,
      legs: legs ?? this.legs,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDistance: totalDistance ?? this.totalDistance,
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

class PackageFareCalculationState {
  final double? calculatedPackageFare;
  final bool isLoading;
  final String? error;
  final PackageCreate? updatedPackage;

  PackageFareCalculationState({
    this.calculatedPackageFare,
    this.isLoading = false,
    this.error,
    this.updatedPackage,
  });

  PackageFareCalculationState copyWith({
    double? calculatedPackageFare,
    bool? isLoading,
    String? error,
    PackageCreate? updatedPackage,
  }) {
    return PackageFareCalculationState(
      calculatedPackageFare:
          calculatedPackageFare ?? this.calculatedPackageFare,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      updatedPackage: updatedPackage ?? this.updatedPackage,
    );
  }
}
