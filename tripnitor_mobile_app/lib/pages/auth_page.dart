import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/user/home_page.dart';
import 'package:tripnitor_mobile_app/pages/registration_page.dart';
import '../providers/auth_provider.dart';
import 'admin/admin_driver_schedule_page.dart';
import 'driver/driver_homepage.dart';
import 'login_page.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.user == null) {
      return LoginPage();
    }

    switch (authState.user?.role) {
      case 'ADMIN':
        return DriverSchedulePage();
      case 'USER':
        return HomePage();
      case 'DRIVER':
        return DriverHomePage();
      default:
        return LoginPage();
    }
  }
}
