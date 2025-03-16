import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tripnitor_mobile_app/providers/driver_assignment_provider.dart';
import '../../core/constants/constant.dart';
import '../../models/driver_assignment.dart';
import '../../models/driver_model.dart';
import '../../providers/driver_provider.dart';
import 'admin_drawer.dart';
import 'profile/booking_admin_profile.dart';

class DriverSchedulePage extends ConsumerStatefulWidget {
  const DriverSchedulePage({super.key});

  @override
  ConsumerState<DriverSchedulePage> createState() => _DriverSchedulePageState();
}

class _DriverSchedulePageState extends ConsumerState<DriverSchedulePage> {
  Driver? _selectedDriver;
  final DateRangePickerController _datePickerController =
      DateRangePickerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(driverStateProvider.notifier).getDriverList();
    });
  }

  Future<void> _fetchDriverBookings(String driverId) async {
    await ref
        .read(driverAssignmentStateProvider.notifier)
        .getAllSpecificDriverBookings(driverId);
  }

  @override
  Widget build(BuildContext context) {
    final driverState = ref.watch(driverStateProvider);
    final driverAssignmentState = ref.watch(driverAssignmentStateProvider);
    final List<Driver>? drivers = driverState.driverList;
    final DateFormat dateTimeFormat = DateFormat('d MMM yyyy, h:mm a');

    final List<PickerDateRange> bookingDateRanges = driverAssignmentState
            .driverAssignmentList
            ?.map((booking) =>
                PickerDateRange(booking.startDate, booking.endDate))
            .toList() ??
        [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _datePickerController.selectedRanges = bookingDateRanges;
    });

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: _buildAppBar(),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildDriverDropdown(drivers),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.black.withOpacity(.5),
                ),
                onPressed: () {
                  DateTime currentDate = _datePickerController.displayDate!;
                  _datePickerController.displayDate = DateTime(
                    currentDate.year,
                    currentDate.month - 1,
                    currentDate.day,
                  );
                },
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.angleRight,
                  color: Colors.black.withOpacity(.5),
                ),
                onPressed: () {
                  DateTime currentDate = _datePickerController.displayDate!;
                  _datePickerController.displayDate = DateTime(
                    currentDate.year,
                    currentDate.month + 1,
                    currentDate.day,
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: IgnorePointer(
              ignoring: true,
              child: SfDateRangePicker(
                controller: _datePickerController,
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.multiRange,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  enableSwipeSelection: false,
                  showTrailingAndLeadingDates: true,
                ),
                showNavigationArrow: false,
                enablePastDates: true,
                allowViewNavigation: false,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  return;
                },
                selectionTextStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                rangeTextStyle: TextStyle(
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    fontWeight: FontWeight.bold),
                startRangeSelectionColor: Color(ColorConstants.PRIMARY_COLOR),
                endRangeSelectionColor: Color(ColorConstants.PRIMARY_COLOR),
                rangeSelectionColor:
                    Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
                backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
                  textStyle: TextStyle(color: Colors.black),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  todayTextStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
          _buildBookingsList(
              driverAssignmentState.driverAssignmentList, dateTimeFormat),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 1),
      child: AppBar(
        title: const Text(
          'Driver Schedules',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
            thickness: 1,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildDriverDropdown(List<Driver>? drivers) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      padding: const EdgeInsets.all(16),
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
      child: DropdownButtonFormField<Driver>(
        style: TextStyle(
          color: Colors.black87,
        ),
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Select Driver',
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
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        value: drivers != null && drivers.contains(_selectedDriver)
            ? _selectedDriver
            : null,
        items: drivers?.map<DropdownMenuItem<Driver>>((Driver driver) {
              return DropdownMenuItem<Driver>(
                value: driver,
                child: Text(
                  driver.user.name,
                  style: TextStyle(color: Colors.black.withOpacity(.5)),
                ),
              );
            }).toList() ??
            [],
        onChanged: (Driver? newValue) async {
          setState(() {
            _selectedDriver = newValue;
          });
          if (newValue != null) {
            await _fetchDriverBookings(newValue.id);
          } else {
            ref.read(driverAssignmentStateProvider.notifier).clearState();
          }
        },
      ),
    );
  }

  Widget _buildBookingsList(
      List<DriverAssignment>? bookings, DateFormat dateTimeFormat) {
    return Expanded(
      child: bookings == null || bookings.isEmpty
          ? Center(child: Text('No bookings available for this driver'))
          : ListView.separated(
              itemCount: bookings.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(text: 'Booking id: '),
                        TextSpan(
                          text: '${booking.booking.id} • ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: booking.booking.status,
                          style: TextStyle(
                            color: _getStatusColor(booking.booking.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            const TextSpan(text: 'Start: '),
                            TextSpan(
                              text: dateTimeFormat.format(booking.startDate),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            const TextSpan(text: 'End: '),
                            TextSpan(
                              text: dateTimeFormat.format(booking.endDate),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingAdminProfile(bookingId: booking.booking.id),
                      ),
                    );
                  },
                );
              },
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
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
