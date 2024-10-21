import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_booking.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_message.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_profile.dart';
import 'package:tripnitor_mobile_app/providers/auth_provider.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class DriverPage extends StatefulWidget {
  const DriverPage({Key? key}) : super(key: key);

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(currentPage),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
        currentIndex: currentPage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
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
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: "Booking",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.chat_bubble),
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: "Message",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return DriverHomepage();
      case 1:
        return DriverBookingPage();
      case 2:
        return DriverMessagePage();
      case 3:
        return DriverProfilePage();
      default:
        return DriverHomepage();
    }
  }
}

class DriverHomepage extends ConsumerStatefulWidget {
  const DriverHomepage({super.key});

  @override
  ConsumerState<DriverHomepage> createState() => _DriverHomepageState();
}

class _DriverHomepageState extends ConsumerState<DriverHomepage> {
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
      ],
    );
  }

  Widget _header(BuildContext context) {
    final authState = ref.watch(authProvider);
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
                        'Welcome ${authState.user?.name}',
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
                    child: Image.asset('assets/images/pana.png',
                        width: 80, height: 80, fit: BoxFit.fill),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
