import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_booking_details.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_booking_notifications.dart';
import 'package:tripnitor_mobile_app/providers/driver_provider.dart';

import '../../../providers/driver_assignment_provider.dart';

enum DateFilterOption {
  all,
  lastMonth,
  last3Months,
  last6Months,
  last12Months,
}

final driverDateFilterProvider =
    StateProvider<DateFilterOption>((ref) => DateFilterOption.all);
final driverStatusFilterProvider = StateProvider<String?>((ref) => null);

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

  List<dynamic> _getFilteredBookings(List<dynamic>? bookings) {
    if (bookings == null || bookings.isEmpty) {
      return [];
    }

    final currentDateFilter = ref.watch(driverDateFilterProvider);
    final statusFilter = ref.watch(driverStatusFilterProvider);

    List<dynamic> dateFiltered = bookings;
    if (currentDateFilter != DateFilterOption.all) {
      final now = DateTime.now();
      DateTime cutoffDate;

      switch (currentDateFilter) {
        case DateFilterOption.lastMonth:
          cutoffDate = DateTime(now.year, now.month - 1, now.day);
          break;
        case DateFilterOption.last3Months:
          cutoffDate = DateTime(now.year, now.month - 3, now.day);
          break;
        case DateFilterOption.last6Months:
          cutoffDate = DateTime(now.year, now.month - 6, now.day);
          break;
        case DateFilterOption.last12Months:
          cutoffDate = DateTime(now.year - 1, now.month, now.day);
          break;
        default:
          cutoffDate = DateTime(1900);
      }

      dateFiltered = bookings.where((driverBooking) {
        return driverBooking.booking.localCreatedAt != null &&
            driverBooking.booking.localCreatedAt!.isAfter(cutoffDate);
      }).toList();
    }

    if (statusFilter != null) {
      return dateFiltered
          .where((driverBooking) =>
              driverBooking.booking.status.toUpperCase() ==
              statusFilter.toUpperCase())
          .toList();
    }

    return dateFiltered;
  }

  Widget _buildFilters() {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.15,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
        color: Color(ColorConstants.BACKGROUND_COLOR),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xFF000000).withOpacity(.1),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: DropdownButtonFormField<DateFilterOption>(
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Date Range',
                    labelStyle: TextStyle(color: Colors.black.withOpacity(.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(ColorConstants.PRIMARY_COLOR),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(ColorConstants.SECONDARY_COLOR),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(ColorConstants.PRIMARY_COLOR),
                        width: 2,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: ref.watch(driverDateFilterProvider),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(driverDateFilterProvider.notifier).state = value;
                    }
                  },
                  items: [
                    DropdownMenuItem(
                        value: DateFilterOption.all, child: Text('All dates')),
                    DropdownMenuItem(
                        value: DateFilterOption.lastMonth,
                        child: Text('Last month')),
                    DropdownMenuItem(
                        value: DateFilterOption.last3Months,
                        child: Text('Last 3 months')),
                    DropdownMenuItem(
                        value: DateFilterOption.last6Months,
                        child: Text('Last 6 months')),
                    DropdownMenuItem(
                        value: DateFilterOption.last12Months,
                        child: Text('Last 12 months')),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  style: TextStyle(color: Colors.black87),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(ColorConstants.PRIMARY_COLOR),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(ColorConstants.SECONDARY_COLOR),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Color(ColorConstants.PRIMARY_COLOR),
                        width: 2,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: ref.watch(driverStatusFilterProvider),
                  onChanged: (value) => ref
                      .read(driverStatusFilterProvider.notifier)
                      .state = value,
                  items: ['PENDING', 'COMPLETED', null]
                      .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status ?? 'All Statuses',
                            style: TextStyle(
                                color: status != null
                                    ? _getStatusColor(status)
                                    : Colors.black.withOpacity(.5)),
                          )))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
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
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text('Bookings'),
      ),
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Color(ColorConstants.BACKGROUND_COLOR),
        backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
        child: _buildUI(context),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildFilters(),
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

    if (driverBookingState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final driverBookingList = driverBookingState.driverAssignmentList;
    final filteredBookings = _getFilteredBookings(driverBookingList);

    if (filteredBookings.isEmpty) {
      return Center(
          child: Text("No bookings found with the selected filters."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final driverBooking = filteredBookings[index];
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
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      driverBooking.booking.localCreatedAt != null
                          ? DateFormat('d MMM yyyy, h:mm a')
                              .format(driverBooking.booking.localCreatedAt!)
                          : "Date unavailable",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
                              _buildStatusTag(driverBooking.booking.status),
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

  Widget _buildStatusTag(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData? iconData;

    switch (status.toUpperCase()) {
      case 'PENDING':
        backgroundColor = Color(ColorConstants.ACCENT_COLOR);
        iconData = Icons.hourglass_empty;
        break;
      case 'CONFIRMED':
        backgroundColor = Color(ColorConstants.PRIMARY_COLOR);
        iconData = Icons.check_circle_outline;
        break;
      case 'ONGOING':
        backgroundColor = Color(ColorConstants.SUCCESS_COLOR);
        iconData = Icons.directions_car;
        break;
      case 'CANCELLED':
        backgroundColor = Color(ColorConstants.ERROR_COLOR);
        iconData = Icons.cancel_outlined;
        break;
      case 'COMPLETED':
        backgroundColor = Colors.green;
        iconData = Icons.task_alt;
        break;
      default:
        backgroundColor = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) ...[
            Icon(
              iconData,
              color: textColor,
              size: 10,
            ),
            SizedBox(width: 2),
          ],
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
