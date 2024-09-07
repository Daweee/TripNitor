import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/models/_van_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/admin_homepage.dart';

class VanAdmin extends StatefulWidget {
  const VanAdmin({super.key});

  @override
  State<VanAdmin> createState() => _VanAdminState();
}

class _VanAdminState extends State<VanAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerPage(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // here the desired height
        child: AppBar(
          backgroundColor: Colors.orange,
          title: Text('APP BAR FROM Van ADMIN PAGE'),
        ),
        
      ),
      body:VanList(),
      
      
    );
  }
}