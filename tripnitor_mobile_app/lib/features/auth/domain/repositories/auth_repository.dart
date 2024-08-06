import 'package:dartz/dartz.dart';
import 'package:tripnitor_mobile_app/core/error/failures.dart';
import '../../data/models/auth_token_model.dart';
import '../../data/models/auth_user_model.dart';
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

    /// Retrieves the locally stored authentication token.
    /// 
    /// Returns an [AuthTokenModel] on success, or a [Failure] on error.
    Future<Either<Failure, AuthTokenModel>> getLocalToken();

    /// Retrieves the locally stored user information.
    /// 
    /// Returns an [AuthUserModel] on success, or a [Failure] on error.
    Future<Either<Failure, AuthUserModel>> getLocalUser();
}