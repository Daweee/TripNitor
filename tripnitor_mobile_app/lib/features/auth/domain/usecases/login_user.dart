import 'package:dartz/dartz.dart';
import 'package:tripnitor_mobile_app/core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginUser implements Usecase<AuthResponse, LoginParams> {
    final AuthRepository repository;

    LoginUser(this.repository);

    @override
    Future<Either<Failure, AuthResponse>> call(LoginParams params) async {
        return await repository.loginUser(
        username: params.username,
        password: params.password,
        );
    }
}

class LoginParams {
    final String username;
    final String password;

    LoginParams({required this.username, required this.password});
}