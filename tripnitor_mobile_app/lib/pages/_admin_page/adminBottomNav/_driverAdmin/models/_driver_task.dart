import 'package:dio/dio.dart';

class DriverTask {
  final String title;
  bool isCompleted;

  DriverTask({
    required this.title,
    required this.isCompleted,
  });
  void isDone() {
    isCompleted = !isCompleted;
  }
}

class DriverProfile {
  final String name;
  final int age;
  final String gender;

  DriverProfile({
    required this.name,
    required this.age,
    required this.gender,
  });
}
