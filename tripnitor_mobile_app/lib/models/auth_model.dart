import 'token_model.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final String phoneNumber;
  final String role;
  final Token? token;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        role: json["role"],
        token: json["token"] != null ? Token.fromJson(json["token"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "role": role,
      };
}

class UserPatch {
  String? name;
  String? email;
  String? phoneNumber;
  String? role;
  String? password;

  UserPatch({
    this.name,
    this.email,
    this.phoneNumber,
    this.role,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'phone_number': phoneNumber,
    };

    if (email != null) json['email'] = email;
    if (role != null) json['role'] = role;
    if (password != null) json['password'] = password;

    return json;
  }
}

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AdminState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AdminState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AdminState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AdminState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
