import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_bookAdmin/_booking_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/_driver_admin_mainPage.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_add.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/_van_admin_mainPage.dart';
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
      // floatingActionButton: FloatingActionButton(
      //   //backgroundColor: Color(Colors.white),
      //   onPressed: () {
      //     // Navigator.of(context).pushNamed(AddDriver());
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => AddDriver()));
      //   },
      //   child: const Icon(Icons.add, color: Color(ColorConstants.ACCENT_COLOR)),
      // ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(boxShadow: <BoxShadow>[
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(1),
      //       offset: Offset(0, -4),
      //       blurRadius: 5,
      //     ),
      //   ]),
      //   child: BottomNavigationBar(
      //     backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      //     currentIndex: currentPage, // 0
      //     type: BottomNavigationBarType.fixed, // .fixed; .shifting;
      //     selectedItemColor: Colors.black, // backgroundColor: Colors.black,
      //     unselectedItemColor: Colors.black,
      //     onTap: (value) {
      //       setState(
      //         () {
      //           currentPage = value;
      //         },
      //       );
      //     },
      //     items: const [
      //       BottomNavigationBarItem(
      //         activeIcon: Icon(Icons.people),
      //         icon: Icon(Icons.people_outline), // 0
      //         label: "Drivers",
      //       ),
      //       BottomNavigationBarItem(
      //         activeIcon: Icon(Icons.directions_car),
      //         icon: Icon(Icons.directions_car_outlined), // 1
      //         label: "Van",
      //       ),
      //       BottomNavigationBarItem(
      //         activeIcon: Icon(Icons.shopping_bag),
      //         icon: Icon(Icons.shopping_bag_outlined), // 2
      //         label: "Booking",
      //       ),
      //       BottomNavigationBarItem(
      //         activeIcon: Icon(Icons.chat_bubble),
      //         icon: Icon(Icons.chat_bubble_outline_rounded), // 2
      //         label: "Message",
      //       ),
      //       // BottomNavigationBarItem(
      //       //   activeIcon: Icon(Icons.book_rounded), // subject to change
      //       //   icon: Icon(Icons.book_outlined), // 3
      //       //   label: 'Package',
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }

  // Widget _buildPage(int index) {
  //   switch (index) {
  //     case 0:
  //       return DriverAdmin(); // 0
  //     case 1:
  //       return VanAdmin(); // 1
  //     case 2:
  //       return BookingList(); // 2
  //     case 3:
  //       return MessageAdmin(); // 3
  //     // case 4:
  //     //   return PackageAdmin(); // 4
  //     default:
  //       return DriverAdmin();
  //   }
  // }
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
                    
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message_sharp),
                  title: Text('Message'),
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
