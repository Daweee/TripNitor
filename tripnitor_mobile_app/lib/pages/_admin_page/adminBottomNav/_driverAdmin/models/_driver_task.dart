import 'package:dio/dio.dart';

class DriverTask {
  final String title;
  final int age;
  final String gender;
  bool isCompleted;
  //
  // final String username;
  final String name;
  // final String email;
  // final String phone_number;
  // final String password;
  // final int license_number;
  // final DateTime date_hired;
  // final String van_id;

  DriverTask({
    required this.title,
    required this.age,
    required this.gender,
    required this.isCompleted,
    //
    // required this.username,
    required this.name,
    // required this.email,
    // required this.phone_number,
    // required this.password,
    // required this.license_number,
    // required this.date_hired,
    // required this.van_id,
  });

  void isDone() {
    isCompleted = !isCompleted;
  }
}


