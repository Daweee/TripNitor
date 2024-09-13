class BookingPreview {
  final String package;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPassengers;
  final double baseFare;
  final double totalPrice;
  final List<AssignedDriver> assignedDrivers;

  BookingPreview({
    required this.package,
    required this.startDate,
    required this.endDate,
    required this.numberOfPassengers,
    required this.baseFare,
    required this.totalPrice,
    required this.assignedDrivers,
  });

  factory BookingPreview.fromJson(Map<String, dynamic> json) {
    return BookingPreview(
      package: json['package'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      numberOfPassengers: json['number_of_passengers'],
      baseFare: json['base_fare'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
      assignedDrivers: (json['assigned_drivers'] as List)
          .map((driver) => AssignedDriver.fromJson(driver))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'package': package,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'number_of_passengers': numberOfPassengers,
        'base_fare': baseFare,
        'total_price': totalPrice,
        'assigned_drivers':
            assignedDrivers.map((driver) => driver.toJson()).toList(),
      };
}

class PreviewBookingRequest {
  final String package;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPassengers;

  PreviewBookingRequest({
    required this.package,
    required this.startDate,
    required this.endDate,
    required this.numberOfPassengers,
  });

  Map<String, dynamic> toJson() => {
        'package': package,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'number_of_passengers': numberOfPassengers,
      };

  factory PreviewBookingRequest.fromJson(Map<String, dynamic> json) {
    return PreviewBookingRequest(
      package: json['package'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      numberOfPassengers: json['number_of_passengers'],
    );
  }
}

class PreviewBookingResponse {
  final int status;
  final BookingPreview bookingPreview;
  final String message;

  PreviewBookingResponse({
    required this.status,
    required this.bookingPreview,
    required this.message,
  });

  factory PreviewBookingResponse.fromJson(Map<String, dynamic> json) {
    return PreviewBookingResponse(
      status: json['status'],
      bookingPreview: BookingPreview.fromJson(json['data']['booking_preview']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': {'booking_preview': bookingPreview.toJson()},
        'message': message,
      };
}

class AssignedDriver {
  final String name;
  final String phoneNumber;
  final String vanModel;
  final String vanPlateNumber;

  AssignedDriver({
    required this.name,
    required this.phoneNumber,
    required this.vanModel,
    required this.vanPlateNumber,
  });

  factory AssignedDriver.fromJson(Map<String, dynamic> json) {
    return AssignedDriver(
      name: json['name'],
      phoneNumber: json['phone_number'],
      vanModel: json['van_model'],
      vanPlateNumber: json['van_plate_number'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone_number': phoneNumber,
        'van_model': vanModel,
        'van_plate_number': vanPlateNumber,
      };
}
