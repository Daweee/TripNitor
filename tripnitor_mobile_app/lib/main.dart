import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/_driver_admin_mainPage.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/admin_homepage.dart';
import 'package:tripnitor_mobile_app/pages/home_page.dart';
import 'package:tripnitor_mobile_app/pages/login_page.dart';
import 'package:tripnitor_mobile_app/pages/package_page.dart';
import 'package:tripnitor_mobile_app/pages/registration_page.dart';
import 'pages/auth_page.dart';
import 'providers/auth_provider.dart';
import 'constants/constant.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      //   title: 'Login and User Registration',
        theme: ThemeData(
          //primarySwatch: ColorConstants.BACKGROUND_COLOR,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(ColorConstants.BACKGROUND_COLOR)),
          useMaterial3: true,
        ),
      // home: LoginPage(),
      //   home: RegistrationPage(),
      // home: authState.isAuthenticated ? AuthPage() : LoginPage(),
      // home: PackageTrips(),
      // home: HomePage(),
      home: AdminPage(),
      // home: DriverAdmin(),
      initialRoute: '/',
      
    );
  }
}
