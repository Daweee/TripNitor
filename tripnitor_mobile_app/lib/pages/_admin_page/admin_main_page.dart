import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_bookAdmin/_booking_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/_driver_list.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/messageAdmin/_message_admin.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_packageAdmin/_package_admin.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_vanAdmin/_van_list.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: _buildPage(currentPage), //_buildUI(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
                BoxShadow(
                color: Colors.grey.withOpacity(1),
                offset: Offset(0, -4),
                blurRadius: 5,
              ),
            ]
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          currentIndex: currentPage,
          type: BottomNavigationBarType.fixed, // .fixed; .shifting;
          selectedItemColor: Colors.black, // backgroundColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: (value) {
            setState(
              () {
                currentPage = value;
              },
            );
          },
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.people),
              icon: Icon(Icons.people_outline), // 0
              label: "Drivers",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.directions_car),
              icon: Icon(Icons.directions_car_outlined), // 1
              label: "Van",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.shopping_bag),
              icon: Icon(Icons.shopping_bag_outlined), // 2
              label: "Booking",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.chat_bubble),
              icon: Icon(Icons.chat_bubble_outline_rounded), // 2
              label: "Message",
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.book_rounded), // subject to change
              icon: Icon(Icons.book_outlined), // 3
              label: 'Package',
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return DriverList(); // 0
      case 1:
        return VanList();  // 1
      case 2:
        return BookingList(); // 2
      case 3:
        return MessageAdmin(); // 3
      case 4: 
        return PackageAdmin(); // 4
      default:
        return DriverList();
    }
  }

}
