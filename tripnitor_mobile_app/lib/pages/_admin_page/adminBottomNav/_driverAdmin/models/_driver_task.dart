import 'package:dio/dio.dart';

class DriverTask {
  final String title;
  // final String name; // sample properties
  // final int age;
  // final String gender;
  bool isCompleted;

  DriverTask({
    required this.title,
    // required this.name,
    // required this.age,
    // required this.gender,
    required this.isCompleted,
  });
  void isDone() {
    isCompleted = !isCompleted;
  }
}
