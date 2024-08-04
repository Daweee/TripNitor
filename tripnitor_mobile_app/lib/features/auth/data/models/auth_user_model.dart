import '../../domain/entities/auth_user.dart';

class AuthUserModel extends User {
    const AuthUserModel({
        required String username,
        required String name,
        required String email,
        required String phoneNumber,
    }) : super(
            username: username,
            name: name,
            email: email,
            phoneNumber: phoneNumber,
            );
    
    factory AuthUserModel.fromJson(Map<String, dynamic> json) {
        return AuthUserModel(
        username: json['username'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        );
    }
    
    Map<String, dynamic> toJson() {
        return {
        'username': username,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        };
    }
}