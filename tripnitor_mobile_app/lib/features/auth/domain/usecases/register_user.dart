import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
    final AuthRepository repository;

    RegisterUser(this.repository);

    Future<Either<Failure, AuthResponse>> call(RegisterParams params) async {
        return await repository.registerUser(
        username: params.username,
        email: params.email,
        password: params.password,
        name: params.name,
        phoneNumber: params.phoneNumber,
        );
    }
}

class RegisterParams {
    final String username;
    final String email;
    final String password;
    final String name;
    final String phoneNumber;

    RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    });
}