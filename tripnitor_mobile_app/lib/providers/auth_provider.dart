import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
        final response = await _authService.login(username, password);
        final user = User.fromJson(response);
        state = AuthState(user: user, isAuthenticated: true, isLoading: false);
    } catch (e) {
        state = AuthState(isAuthenticated: false, isLoading: false);
    }
  }

  Future<void> register(String username, String name, String email, String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _authService.register(username, name, email, phoneNumber, password);
      final user = User.fromJson(response);
      state = AuthState(user: user, isAuthenticated: true, isLoading: false, error: '');
    } catch (e) {
      state = AuthState(isAuthenticated: false, isLoading: false, error: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});
