part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
    const AuthEvent();

     @override
    List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {
    const CheckAuthStatus();
}

class LoginRequested extends AuthEvent {
    final String username;
    final String password;

    const LoginRequested({required this.username, required this.password});
}

class RegisterRequested extends AuthEvent {
    final String username;
    final String password;
    final String email;
    final String name;
    final String phoneNumber;

    const RegisterRequested({
        required this.username,
        required this.password,
        required this.email,
        required this.name,
        required this.phoneNumber});
}

class LogoutRequested extends AuthEvent {
    final String token;

    const LogoutRequested({required this.token});
}
