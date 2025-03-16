import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_booking_details.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_booking_notifications.dart';
import 'package:tripnitor_mobile_app/providers/driver_provider.dart';

import '../../../providers/driver_assignment_provider.dart';

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
      ref.read(driverAssignmentStateProvider.notifier).getDriverBookings();
    });
  }

  Future<void> _navigateToDetails(String bookingId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverBookingDetails(bookingId: bookingId),
      ),
    );

    if (result == true || result == null) {
      await _refreshData();
    }
  }

  Future<void> _refreshData() async {
    await ref.read(driverAssignmentStateProvider.notifier).getDriverBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text('Bookings'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildUI(context),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _driverTaskList(context),
        ],
      ),
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
                "My Bookings",
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
    final driverBookingList = driverBookingState.driverAssignmentList
        ?.where((booking) =>
            booking.booking.status != "CONFIRMED" &&
            booking.booking.status != "ONGOING")
        .toList();

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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Dash(
                    direction: Axis.vertical,
                    length: 30,
                    dashLength: 5,
                    dashColor: Colors.black.withOpacity(.5),
                    dashGap: 5,
                    dashThickness: 2,
                  ),
                ),
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
                                driverBooking.booking.id,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Status:  ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                driverBooking.booking.status,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: _getStatusColor(
                                        driverBooking.booking.status)),
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
                        onPressed: () =>
                            _navigateToDetails(driverBooking.booking.id),
                        child: Text(
                          'Details',
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

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Color(ColorConstants.ACCENT_COLOR);
      case 'CONFIRMED':
        return Color(ColorConstants.PRIMARY_COLOR);
      case 'ONGOING':
        return Color(ColorConstants.SUCCESS_COLOR);
      case 'CANCELLED':
        return Color(ColorConstants.ERROR_COLOR);
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
