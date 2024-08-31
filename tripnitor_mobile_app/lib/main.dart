import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/home_page.dart';
import 'package:tripnitor_mobile_app/pages/login_page.dart';
import 'package:tripnitor_mobile_app/pages/package_page.dart';
import 'package:tripnitor_mobile_app/pages/registration_page.dart';
import 'pages/auth_page.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(ProviderScope(
      child: MyApp(),
    ),);
}

class MyApp extends ConsumerWidget  {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      // debugShowCheckedModeBanner: false,
    //   title: 'Login and User Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      // home: LoginPage(),
      home: RegistrationPage(),
      // home: authState.isAuthenticated ? AuthPage() : LoginPage(),
      //home: PackageTrips(),
      // home: HomePage(),


    );
  }
}
