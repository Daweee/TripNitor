import 'package:intl/intl.dart';

import 'gas_model.dart';

class Van {
  final String id;
  final String model;
  final String plateNumber;
  final DateTime dateBought;
  final DateTime registrationExpiryDate;
  final int maxPassengers;
  final Gas gas;

  Van({
    required this.id,
    required this.model,
    required this.plateNumber,
    required this.dateBought,
    required this.registrationExpiryDate,
    required this.maxPassengers,
    required this.gas,
  });
  factory Van.fromJson(Map<String, dynamic> json) {
    return Van(
      id: json['id'],
      model: json['model'],
      plateNumber: json['plate_number'],
      dateBought: DateTime.parse(json['date_bought']),
      registrationExpiryDate: DateTime.parse(json['registration_expiry_date']),
      maxPassengers: json['max_passengers'],
      gas: Gas.fromJson(json['gas']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'model': model,
        'plate_number': plateNumber,
        'date_bought': dateBought.toIso8601String(),
        'registration_expiry_date': registrationExpiryDate.toIso8601String(),
        'max_passengers': maxPassengers,
        'gas': gas.toJson(),
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
