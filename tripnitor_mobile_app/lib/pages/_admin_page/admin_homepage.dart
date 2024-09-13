import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_bookAdmin/pages/_booking_admin_main.dart';
import 'package:tripnitor_mobile_app/models/booking_model.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/_driver_admin_main.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_add.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/_van_admin_main.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/messageAdmin/_message_admin.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_packageAdmin/_package_admin.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/models/_van_list.dart';

final drawerProvider = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      key: _scaffoldKey, // Assign GlobalKey to Scaffold
      drawer: NavigationDrawerPage(), // _drawerHeader(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: DriverAdmin(), //DriverAdmin(), _buildPage(currentPage),
            ),
          ],
        ),
      ), //_buildUI(),
      
}

class NavigationDrawerPage extends StatelessWidget {
  const NavigationDrawerPage({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Wrap(
              runSpacing: 16,
              children: [
                Container(
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          maxRadius: 44,
                        ),
                        SizedBox(height: 36),
                        Text('Sample name'),
                      ],
                    ),
                  ),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Icon(Icons.drive_eta_rounded),
                  title: Text('Driver'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DriverAdmin()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.car_rental),
                  title: Text('Van'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VanAdmin()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag_rounded),
                  title: Text('Booking'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BookingAdmin()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.gas_meter),
                  title: Text('Gas'),
                  onTap: () {
                    
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book_online_rounded),
                  title: Text('Package'),
                  onTap: () {
                    
                  },
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {},
                ),
                
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Log out'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );
}
