import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/admin_homepage.dart';

class DriverAdmin extends StatefulWidget {
  const DriverAdmin({super.key});

  @override
  State<DriverAdmin> createState() => _DriverAdminState();
}

class _DriverAdminState extends State<DriverAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerPage(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90), // here the desired height
        child: AppBar(
          backgroundColor: Colors.orange,
          title: Text('APP BAR FROM DRIVER ADMIN PAGE'),
        ),
        
      ),
      body: DriverList(),
      
      
    );
  }


  
}
