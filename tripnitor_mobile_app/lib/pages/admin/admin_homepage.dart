import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tripnitor_mobile_app/providers/driver_assignment_provider.dart';
import '../../constants/constant.dart';
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
          Expanded(
            child: SfDateRangePicker(
              controller: _datePickerController,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.multiRange,
              monthViewSettings: DateRangePickerMonthViewSettings(
                showTrailingAndLeadingDates: true,
              ),
              showNavigationArrow: true,
              enablePastDates: true,
              allowViewNavigation: false,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                _datePickerController.selectedRanges =
                    _datePickerController.selectedRanges;
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
          _buildBookingsList(driverAssignmentState.driverAssignmentList),
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
      height: MediaQuery.of(context).size.height * 0.10,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<Driver>(
        decoration: InputDecoration(
          labelText: "Select Driver",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        value: drivers != null && drivers.contains(_selectedDriver)
            ? _selectedDriver
            : null,
        items: drivers?.map<DropdownMenuItem<Driver>>((Driver driver) {
              return DropdownMenuItem<Driver>(
                value: driver,
                child: Text(driver.user.name),
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
            ref.read(driverAssignmentStateProvider.notifier).clearBookings();
          }
        },
      ),
    );
  }

  Widget _buildBookingsList(List<DriverAssignment>? bookings) {
    return Expanded(
      child: bookings == null || bookings.isEmpty
          ? Center(child: Text('No bookings available for this driver'))
          : ListView.separated(
              itemCount: bookings.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return ListTile(
                  title: Text('Booking id:${booking.booking.id}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Start: ${booking.startDate.toString().substring(0, 10)}'),
                      Text(
                          'End: ${booking.endDate.toString().substring(0, 10)}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingAdminProfile(booking: booking.booking),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
