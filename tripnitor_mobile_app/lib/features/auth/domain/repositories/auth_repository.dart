import 'package:dartz/dartz.dart';
import 'package:tripnitor_mobile_app/core/error/failures.dart';
import '../entities/auth_response.dart';

abstract class AuthRepository {
    /// Attempts to log in a user with the provided credentials.
    /// 
    /// Returns an [AuthResponse] on success, or a [Failure] on error.
    Future<Either<Failure, AuthResponse>> loginUser({required String username, required String password,});

    /// Attempts to register a new user with the provided information.
    /// 
    /// Returns an [AuthResponse] on success, or a [Failure] on error.
    Future<Either<Failure, AuthResponse>> registerUser({
        required String username,
        required String email,
        required String password,
        required String name,
        required String phoneNumber,
    });

    /// Logs out the currently authenticated user.
    /// 
    /// Returns an [AuthResponse] on success, or a [Failure] on error.
    Future<Either<Failure, AuthResponse>> logoutUser({required String token});
}