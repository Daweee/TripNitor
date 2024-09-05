import 'package:dio/dio.dart';

class VanTask {
  final String title;
  bool isCompleted;

  VanTask({
    required this.title,
    required this.isCompleted,
  });
  void isDone() {
    isCompleted = !isCompleted;
  }
}
