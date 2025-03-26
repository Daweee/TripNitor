import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

class AdminDetailsNotifier extends StateNotifier<AdminState> {
  final AuthService _authService;

  AdminDetailsNotifier(this._authService) : super(AdminState());

  Future<void> fetchAdminDetails() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.fetchAdminDetails();

      final admin = User.fromJson(response);
      state = AdminState(
        user: admin,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearAuthState() {
    state = AdminState();
  }
}

final adminDetailsProvider =
    StateNotifierProvider<AdminDetailsNotifier, AdminState>((ref) {
  return AdminDetailsNotifier(AuthService());
});
