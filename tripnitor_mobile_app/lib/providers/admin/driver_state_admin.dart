import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/auth_model.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/models/gas_model.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';

class DriverFormNotifier extends StateNotifier<Driver> {
  DriverFormNotifier()
      : super(
          Driver(
            user: User(
              id: '',
              username: '',
              email: '',
              name: '',
              phoneNumber: '',
              role: '',
            ), // Initial User
            licenseNumber: '',
            dateHired: DateTime.now(),
            van: Van(
              id: '',
              model: '',
              plateNumber: '',
              dateBought: DateTime.now(),
              registrationExpiryDate: DateTime.now(),
              maxPassengers: 0,
              gas: Gas(
                id: '',
                gasName: '',
                gasPrice: '',
              ),
            ), // Initial Van
          ),
        );
}
