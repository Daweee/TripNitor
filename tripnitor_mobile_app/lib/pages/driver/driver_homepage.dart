import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/auth_model.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_message.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_notification.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_profile.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_booking_details.dart';
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
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
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
            activeIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_outlined), // 1
            label: "Notification",
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
        return MyDriverHomePage();
      case 1:
        return DriverNotificationPage();
      case 2:
        return DriverMessagePage();
      case 3:
        return DriverProfilePage();
      default:
        return MyDriverHomePage();
    }
  }
}

class MyDriverHomePage extends ConsumerWidget {
  const MyDriverHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        _header(context),
        _driverTaskList(context),
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

  Widget _driverTaskList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Assign Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          _buildTaskCard(context),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 20),
                SizedBox(width: 5),
                Text(
                  'Prime Tourist Liloan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Icon(Icons.swap_vert, color: Colors.black, size: 20),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.black, size: 20),
                SizedBox(width: 5),
                Text(
                  'Medellien Aisle, Medillen Cebu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Booking ID:  ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                '#0001',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('North: ', style: TextStyle(fontSize: 12)),
                              Text(
                                '#0001',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Round Trip: ',
                                  style: TextStyle(fontSize: 12)),
                              Text(
                                '25.76 km',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Text('Confirmed',
                    //       style: TextStyle(color: Colors.white, fontSize: 12)),
                    // ),
                    SizedBox(height: 5),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => DriverBookingDetails()),
                    //     );
                    //   },
                    //   child: Text('Show task'),
                    //   style: ElevatedButton.styleFrom(
                    //     iconColor: Colors.amber,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .3,
                      height: MediaQuery.sizeOf(context).height * .06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DriverBookingDetails()),
                          );
                        },
                        child: Text(
                          'Show Task',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
