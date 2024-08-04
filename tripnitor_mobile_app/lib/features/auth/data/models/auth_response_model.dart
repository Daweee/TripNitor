import '../../domain/entities/auth_response.dart';
import 'auth_token_model.dart';
import 'auth_user_model.dart';

class AuthResponseModel extends AuthResponse {
    const AuthResponseModel({
        required int status,
        required AuthUserModel user,
        required AuthTokenModel token,
        required String message,
    }) : super(
            status: status,
            user: user,
            token: token,
            message: message,
        );

    factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
        return AuthResponseModel(
            status: json['status'],
            user: AuthUserModel.fromJson(json['user']),
            token: AuthTokenModel.fromJson(json['token']),
            message: json['message'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'status': status,
            'data': {
                'user': (user as AuthUserModel).toJson(),
                'token': (token as AuthTokenModel).toJson(),
            },
            'message': message,
        };
    }
}
