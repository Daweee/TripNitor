class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final String phoneNumber;
  final String role;
  final String accessToken;
  final String refreshToken;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['data']['user'];
    final tokenData = json['data']['token'];
    return User(
      id: userData['id'],
      username: userData['username'],
      email: userData['email'],
      name: userData['name'],
      phoneNumber: userData['phone_number'],
      role: userData['role'],
      accessToken: tokenData['access'],
      refreshToken: tokenData['refresh'],
    );
  }
}

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;

  AuthState({
    this.user, 
    this.isAuthenticated = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}