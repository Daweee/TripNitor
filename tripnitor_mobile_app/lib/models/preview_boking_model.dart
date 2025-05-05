class BookingPreview {
  final String package;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPassengers;
  final int baseFare;
  final int numberOfNights;
  final double basePackagePrice;
  final double totalPrice;
  final List<AssignedDriver> assignedDrivers;

  BookingPreview({
    required this.package,
    required this.startDate,
    required this.endDate,
    required this.numberOfPassengers,
    required this.baseFare,
    required this.numberOfNights,
    required this.basePackagePrice,
    required this.totalPrice,
    required this.assignedDrivers,
  });

  factory BookingPreview.fromJson(Map<String, dynamic> json) => BookingPreview(
        package: json["package"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        numberOfPassengers: json["number_of_passengers"],
        baseFare: (json["base_fare"] as num).toInt(),
        numberOfNights: json["number_of_nights"],
        basePackagePrice: json["base_package_price"],
        totalPrice: json["total_price"],
        assignedDrivers: List<AssignedDriver>.from(
            json["assigned_drivers"].map((x) => AssignedDriver.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "package": package,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "number_of_passengers": numberOfPassengers,
        "base_fare": baseFare,
        "number_of_nights": numberOfNights,
        "base_package_price": basePackagePrice,
        "total_price": totalPrice,
        "assigned_drivers":
            List<dynamic>.from(assignedDrivers.map((x) => x.toJson())),
      };
}

class PreviewBookingRequest {
  final String package;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPassengers;
  final String? assignedDriver;

  PreviewBookingRequest({
    required this.package,
    required this.startDate,
    required this.endDate,
    required this.numberOfPassengers,
    this.assignedDriver,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'package': package,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'number_of_passengers': numberOfPassengers,
    };

    if (assignedDriver != null) {
      data['assigned_driver'] = assignedDriver;
    }

    return data;
  }

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
      bookingPreview: BookingPreview.fromJson(json['data']),
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
  final String id;
  final String name;
  final String phoneNumber;
  final String vanModel;
  final String vanPlateNumber;

  AssignedDriver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.vanModel,
    required this.vanPlateNumber,
  });

  factory AssignedDriver.fromJson(Map<String, dynamic> json) {
    return AssignedDriver(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      vanModel: json['van_model'],
      vanPlateNumber: json['van_plate_number'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone_number': phoneNumber,
        'van_model': vanModel,
        'van_plate_number': vanPlateNumber,
      };
}
