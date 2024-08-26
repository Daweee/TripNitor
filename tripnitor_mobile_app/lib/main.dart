import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/home_page.dart';
import 'package:tripnitor_mobile_app/pages/login_page.dart';
import 'package:tripnitor_mobile_app/pages/package_page.dart';
import 'package:tripnitor_mobile_app/pages/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Login and User Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      // home: LoginPage(),
      //home: RegistrationPage(),
      home: HomePage(),
      //home: PackageTrips(),
    );
  }
}
