part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
    final AuthResponse response;

    Authenticated({required this.response});

    List<Object> get props => [response];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
    final String message;

    AuthError(this.message);

    List<Object?> get props => [message];
}

class AuthenticatedWithNullableToken extends AuthState {
  final AuthUserModel user;
  final AuthTokenModel? token;

  AuthenticatedWithNullableToken({required this.user, this.token});

  @override
  List<Object?> get props => [user, token];
}