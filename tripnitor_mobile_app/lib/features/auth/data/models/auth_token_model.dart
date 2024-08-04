import '../../domain/entities/auth_token.dart';

class AuthTokenModel extends Token {
    const AuthTokenModel({
        required String access,
        required String refresh,
        }) : super(
                access: access,
                refresh: refresh,
            );

    factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
        return AuthTokenModel(
            access: json['access'],
            refresh: json['refresh'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'access': access,
            'refresh': refresh,
        };
    }
}