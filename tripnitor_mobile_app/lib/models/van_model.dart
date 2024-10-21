import 'package:intl/intl.dart';

import 'gas_model.dart';

class Van {
  final String id;
  final String model;
  final String plateNumber;
  final DateTime dateBought;
  final DateTime registrationExpiryDate;
  final int maxPassengers;
  final Gas? gas;

  Van({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.dateBought,
    required this.registrationExpiryDate,
    required this.maxPassengers,
    this.gas,
  });

  factory Van.fromJson(Map<String, dynamic> json) {
    return Van(
      id: json['id'] as String? ?? '',
      model: json['model'] as String? ?? '',
      plateNumber: json['plate_number'] as String? ?? '',
      dateBought: DateTime.parse(json['date_bought'] as String),
      registrationExpiryDate:
          DateTime.parse(json['registration_expiry_date'] as String),
      maxPassengers: json['max_passengers'] as int? ?? 0,
      gas: json['gas'] != null ? Gas.fromJson(json['gas']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'model': model,
        'plate_number': plateNumber,
        'date_bought': dateBought.toIso8601String(),
        'registration_expiry_date': registrationExpiryDate.toIso8601String(),
        'max_passengers': maxPassengers,
        'gas': gas?.toJson(), // Safely handle the nullable gas
      };
}

class VanPatch {
  String? model;
  String? plateNumber;
  DateTime dateBought;
  DateTime registrationExpiryDate;
  int? maxPassengers;
  String? gasId;

  VanPatch({
    this.model,
    this.plateNumber,
    required this.dateBought,
    required this.registrationExpiryDate,
    this.maxPassengers,
    this.gasId,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'plate_number': plateNumber,
        'date_bought': DateFormat('yyyy-MM-dd').format(dateBought),
        'registration_expiry_date':
            DateFormat('yyyy-MM-dd').format(registrationExpiryDate),
        'max_passengers': maxPassengers,
        'gas_id': gasId,
      };
}

class VanState {
  final int? status;
  final Van? van;
  final List<Van>? vanList;
  final String? message;
  final bool isLoading;
  final String? error;

  VanState({
    this.status,
    this.van,
    this.vanList,
    this.message,
    this.isLoading = false,
    this.error,
  });

  VanState copyWith({
    int? status,
    Van? van,
    List<Van>? vanList,
    String? message,
    bool? isLoading,
    String? error,
  }) {
    return VanState(
      status: status ?? this.status,
      van: van ?? this.van,
      vanList: vanList ?? this.vanList,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
