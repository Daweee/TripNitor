import 'package:equatable/equatable.dart';
import 'auth_user.dart';
import 'auth_token.dart';

class AuthResponse extends Equatable {
    final int status;
    final User user;
    final Token token;
    final String message;

    const AuthResponse({
        required this.status,
        required this.user,
        required this.token,
        required this.message,
    });

    @override
    List<Object> get props => [status, user, token, message];
}