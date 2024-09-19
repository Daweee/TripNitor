import 'package:flutter/material.dart';

class DriverBookingPage extends StatefulWidget {
  const DriverBookingPage({super.key});

  @override
  State<DriverBookingPage> createState() => _DriverBookingPageState();
}

class _DriverBookingPageState extends State<DriverBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Drivers Booking Page"),
      ),
    );
  }
}
