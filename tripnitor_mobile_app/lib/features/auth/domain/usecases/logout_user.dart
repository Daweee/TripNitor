import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LogoutUser {
    final AuthRepository repository;

    LogoutUser(this.repository);
    
    Future<Either<Failure, AuthResponse>> call(LogoutParams params) async {
    return await repository.logoutUser(
        token: params.token,
    );
  }
}

class LogoutParams {
  final String token;

  LogoutParams({required this.token});
}