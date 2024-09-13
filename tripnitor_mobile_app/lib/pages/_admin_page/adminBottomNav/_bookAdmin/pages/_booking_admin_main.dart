import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/models/booking_model.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_bookAdmin/pages/_booking_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/admin_homepage.dart';

class BookingAdmin extends StatefulWidget {
  const BookingAdmin({super.key});

  @override
  State<BookingAdmin> createState() => _BookingAdminState();
}

class _BookingAdminState extends State<BookingAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerPage(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // here the desired height
        child: AppBar(
          backgroundColor: Colors.orange,
          title: Text('BOOKING PAGE'),
        ),
      ),
      body: BookingList(),
    );
  }
}
