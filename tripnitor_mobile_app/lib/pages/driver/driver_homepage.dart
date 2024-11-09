import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_booking.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_message.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_profile.dart';
import 'package:tripnitor_mobile_app/providers/auth_provider.dart';

import '../../models/driver_assignment.dart';
import '../../providers/driver_assignment_provider.dart';
import '../../providers/driver_provider.dart';
import 'driver_booking_details.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(driverAssignmentStateProvider.notifier)
          .getActiveDriverBookingsList();
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
    await ref
        .read(driverAssignmentStateProvider.notifier)
        .getActiveDriverBookingsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        _header(context),
        Expanded(
          child: _body(),
        ),
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
                    child: Image.asset(
                      'assets/images/pana.png',
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

  Widget _body() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        color: Color(ColorConstants.BACKGROUND_COLOR),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSection(
                title: 'Ongoing Bookings',
                child: _buildOngoingBookingList(),
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Confirmed Bookings',
                child: _buildConfirmedBookingList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildOngoingBookingList() {
    final driverBookingState = ref.watch(driverAssignmentStateProvider);
    final driverOngoingBookingList = driverBookingState.driverAssignmentList
        ?.where((booking) => booking.booking.status == 'ONGOING')
        .toList();

    if (driverOngoingBookingList == null || driverOngoingBookingList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: const Center(child: Text("No Ongoing bookings available")),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: driverOngoingBookingList.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(driverOngoingBookingList[index]);
        },
      ),
    );
  }

  Widget _buildConfirmedBookingList() {
    final driverBookingState = ref.watch(driverAssignmentStateProvider);
    final driverConfirmedBookingList = driverBookingState.driverAssignmentList
        ?.where((booking) => booking.booking.status == "CONFIRMED")
        .toList();

    if (driverConfirmedBookingList == null ||
        driverConfirmedBookingList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: const Center(child: Text("No Ongoing bookings available")),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: driverConfirmedBookingList.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(driverConfirmedBookingList[index]);
        },
      ),
    );
  }

  Widget _buildBookingCard(DriverAssignment driverBooking) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationRow(
              icon: Icons.location_on,
              iconColor: Colors.red,
              text: driverBooking.booking.package.startLocation.name,
            ),
            const SizedBox(height: 5),
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
            const SizedBox(height: 5),
            _buildLocationRow(
              icon: Icons.location_on,
              iconColor: Colors.black,
              text: driverBooking.booking.package.finalDestination.name,
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Booking ID: ', driverBooking.booking.id),
                      _buildStatusRow('Status: ', driverBooking.booking.status),
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
                    child: const Text(
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
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: _getStatusColor(status),
          ),
        ),
      ],
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
