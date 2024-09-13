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
