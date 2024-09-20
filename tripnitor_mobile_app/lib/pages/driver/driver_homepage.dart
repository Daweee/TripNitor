import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/auth_model.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_booking/driver_booking.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_message.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_notification.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_profile.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_booking/driver_booking_details.dart';
import 'package:tripnitor_mobile_app/providers/auth_provider.dart';

final currentIndexProvider =
    StateProvider<int>((ref) => 0); // riverpod variable

class DriverHomePage extends ConsumerWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage =
        ref.watch(currentIndexProvider); // listens to riverpod variable

    final authState = ref.watch(authProvider);
    return Scaffold(
      // body: // _buildUI(context),
      body: _buildPage(context, currentPage),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
        currentIndex: currentPage,
        type: BottomNavigationBarType.fixed, // .fixed; .shifting;
        selectedItemColor: Colors.black, // backgroundColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (value) {
          // setState(
          //   () {
          //     currentPage = value;
          //   },
          // );
          ref.read(currentIndexProvider.notifier).state =
              value; // riverpod setState
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined), // 0
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined), // 1
            label: "Booking",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.chat_bubble),
            icon: Icon(Icons.chat_bubble_outline_rounded), // 2
            label: "Message",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined), // 3
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        //return HomePage();
        return DriverDashboard();
      case 1:
        return DriverBookingPage();
      case 2:
        return DriverMessagePage();
      case 3:
        return DriverProfilePage();
      default:
        return DriverDashboard();
    }
  }
}

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: _buildUI(context),
    ));
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        _header(context),
        _driverDashBoardList(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Color(ColorConstants.PRIMARY_COLOR),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome null', // ${authState.user?.username}
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Your hard work drives our success. Keep moving forward!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: Image.asset(
                        'assets/images/pana.png', // Replace with the path to your image asset
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _driverDashBoardList(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Driver\'s Dashboard'),
      ),
    );
  }
}
