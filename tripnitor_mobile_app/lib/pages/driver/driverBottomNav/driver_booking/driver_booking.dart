import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_booking/driver_booking_details.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_booking/driver_booking_notifications.dart';

class DriverBookingPage extends ConsumerWidget {
  const DriverBookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        title: Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Center(
            child: Text('Booking '),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Soon will not implement materiaPageRoute rather just slide 2 screen in one frame. Temporary screen
                    builder: (context) => DriverBookingNotifications(),
                  ),
                );
              },
              child: Icon(
                Icons.notifications,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        //_header(context),
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
                      fit: BoxFit.fill,
                    ),
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
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Assign Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
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
        padding: const EdgeInsets.all(16),
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
            Icon(Icons.swap_vert, color: Colors.black, size: 20),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.black,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Medellien Aisle, Medillen Cebu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 20),
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
                              Text('Route: ', style: TextStyle(fontSize: 12)),
                              Text(
                                'Round Trip',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Est. Destination: ',
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
