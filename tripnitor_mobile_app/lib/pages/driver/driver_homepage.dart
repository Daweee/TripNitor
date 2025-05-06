import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_booking.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_bottom_nav/driver_profile.dart';
import 'package:tripnitor_mobile_app/providers/auth_provider.dart';
import 'package:tripnitor_mobile_app/models/driver_assignment.dart';
import 'package:tripnitor_mobile_app/providers/driver_assignment_provider.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_booking_details.dart';

final driverNavIndexProvider = StateProvider<int>((ref) => 0);

void resetToDriverHomePage(WidgetRef ref) {
  ref.read(driverNavIndexProvider.notifier).state = 0;
}

class DriverHomePage extends ConsumerStatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends ConsumerState<DriverHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetToDriverHomePage(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(driverNavIndexProvider);

    return Scaffold(
      body: _buildPage(currentPage),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
        currentIndex: currentPage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (value) {
          ref.read(driverNavIndexProvider.notifier).state = value;
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
    return Container(
      color: Color(ColorConstants.BACKGROUND_COLOR),
      child: Column(
        children: [
          _header(context),
          Expanded(
            child: _body(),
          ),
        ],
      ),
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
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
        child: const Center(child: Text("No Confirmed bookings available")),
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
    final isJoinerPackage =
        driverBooking.booking.package.visibility == "JOINER";
    final packageId = driverBooking.booking.package.id;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isJoinerPackage) _buildJoinerBadge(packageId),
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
                      Row(
                        children: [
                          Text(
                            'Status:  ',
                            style: const TextStyle(fontSize: 12),
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

  Widget _buildJoinerBadge(String packageId) {
    final displayId =
        packageId.length > 10 ? '${packageId.substring(0, 12)}...' : packageId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Color(ColorConstants.PRIMARY_COLOR),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group,
              size: 14,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
            const SizedBox(width: 4),
            Text(
              'JOINER PKG: $displayId',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
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
