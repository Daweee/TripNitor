import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_booking/driver_booking_details.dart';
import 'package:tripnitor_mobile_app/pages/driver/driverBottomNav/driver_booking/driver_booking_notifications.dart';
import 'package:tripnitor_mobile_app/providers/driver_provider.dart';

import '../../../../providers/driver_assignment_provider.dart';

class DriverBookingPage extends ConsumerStatefulWidget {
  const DriverBookingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DriverBookingPage> createState() => _DriverBookingPageState();
}

class _DriverBookingPageState extends ConsumerState<DriverBookingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverStateProvider.notifier).getUserDriverDetail();
      ref.read(driverAssignmentStateProvider.notifier).getDriverBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
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
    return SingleChildScrollView(
      child: Column(
        children: [
          //_header(context),
          _driverTaskList(context),
        ],
      ),
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
    final driverBookingState = ref.watch(driverAssignmentStateProvider);
    final driverBookingList = driverBookingState.driverAssignmentList;

    if (driverBookingList == null || driverBookingList.isEmpty) {
      return Center(child: Text("No bookings available"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: driverBookingList.length,
      itemBuilder: (context, index) {
        final driverBooking = driverBookingList[index];
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 20),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        driverBooking.booking.package.startLocation.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Icon(Icons.swap_vert, color: Colors.black, size: 20),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.black, size: 20),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        driverBooking.booking.package.finalDestination.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
                                '${driverBooking.booking.id}',
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DriverBookingDetails(),
                            ),
                          );
                        },
                        child: Text(
                          'Show Task',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
