import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String name;
  final String email;
  final String phoneNumber;

  const User({
    required this.username,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [username, name, email, phoneNumber];
}