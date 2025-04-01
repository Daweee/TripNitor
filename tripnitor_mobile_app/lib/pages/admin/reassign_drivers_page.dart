import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/constant.dart';
import '../../models/booking_model.dart';
import '../../models/driver_assignment.dart';
import '../../models/driver_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/driver_assignment_provider.dart';

class ReassignDriversPage extends ConsumerStatefulWidget {
  const ReassignDriversPage({
    super.key,
  });

  @override
  ConsumerState<ReassignDriversPage> createState() =>
      _ReassignDriversPageState();
}

class _ReassignDriversPageState extends ConsumerState<ReassignDriversPage> {
  Driver? selectedCurrentDriver;
  Driver? selectedNewDriver;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAvailableDrivers();
    });
  }

  Future<void> _fetchAvailableDrivers() async {
    final booking = ref.read(bookingStateProvider).booking;
    if (booking != null) {
      final driverAssignmentNotifier =
          ref.read(driverAssignmentStateProvider.notifier);
      await driverAssignmentNotifier.getAvailableDriversForSwap(
        booking.id,
        booking.startDate,
        booking.endDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingStateProvider);
    final driverAssignment = ref.watch(driverAssignmentStateProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Reassign Drivers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
              thickness: 1,
              height: 1,
            ),
          ),
        ),
      ),
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: _buildBody(booking.booking, driverAssignment),
    );
  }

  Widget _buildBody(Booking? booking, DriverAssignmentState driverAssignment) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Current Drivers'),
                SizedBox(height: 12),
                if (booking != null)
                  ...booking.drivers.map((driver) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _individualDriverContainer(
                        driver,
                        isCurrentDriver: true,
                        isSelected: selectedCurrentDriver == driver,
                      ),
                    );
                  }).toList(),
                SizedBox(height: 24),
                _buildSectionHeader('Available Drivers for Swap'),
                SizedBox(height: 12),
                _buildAvailableDriversList(),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
        if (booking != null && booking.status == "PENDING")
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: selectedCurrentDriver != null &&
                        selectedNewDriver != null &&
                        !driverAssignment.isLoading
                    ? _confirmReassignment
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                  disabledBackgroundColor:
                      Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Confirm Reassignment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvailableDriversList() {
    final driverAssignmentState = ref.watch(driverAssignmentStateProvider);

    if (driverAssignmentState.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: CircularProgressIndicator(
            color: Color(ColorConstants.PRIMARY_COLOR),
          ),
        ),
      );
    }

    if (driverAssignmentState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            children: [
              Text(
                driverAssignmentState.error!,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchAvailableDrivers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (driverAssignmentState.availableDrivers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'No available drivers found for this time period',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Column(
      children: driverAssignmentState.availableDrivers.map((driver) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _individualDriverContainer(
            driver,
            isCurrentDriver: false,
            isSelected: selectedNewDriver == driver,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(ColorConstants.PRIMARY_COLOR),
      ),
    );
  }

  Widget _individualDriverContainer(
    Driver driver, {
    required bool isCurrentDriver,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isCurrentDriver) {
            if (isSelected) {
              selectedCurrentDriver = null;
            } else {
              selectedCurrentDriver = driver;
            }
          } else {
            if (isSelected) {
              selectedNewDriver = null;
            } else {
              selectedNewDriver = driver;
            }
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? Color(ColorConstants.PRIMARY_COLOR) : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _driverInfoSection(driver),
            Divider(),
            _driverActions(driver, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _driverInfoSection(Driver driver) {
    return Container(
      height: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driver.user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              '${driver.van.model} • ${driver.van.plateNumber}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverActions(Driver driver, bool isSelected) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSelected)
            Text(
              'Selected',
              style: TextStyle(
                color: Color(ColorConstants.PRIMARY_COLOR),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            SizedBox.shrink(),
          Row(
            children: [
              _actionButton(
                icon: FontAwesomeIcons.comments,
                onPressed: () {},
              ),
              SizedBox(width: 5),
              _actionButton(
                icon: FontAwesomeIcons.phone,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: IconButton(
          icon: FaIcon(
            icon,
            color: Colors.grey,
            size: 16.0,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Future<void> _confirmReassignment() async {
    if (selectedCurrentDriver == null || selectedNewDriver == null) {
      return;
    }

    try {
      final booking = ref.read(bookingStateProvider).booking;
      if (booking == null) {
        throw Exception('No active booking found');
      }

      final driverAssignmentState = ref.read(driverAssignmentStateProvider);

      DriverAssignment? currentDriverAssignment;

      if (driverAssignmentState.availableDrivers.isNotEmpty) {
        await ref
            .read(driverAssignmentStateProvider.notifier)
            .retrieveDriverAssignment(booking.id, selectedCurrentDriver!.id);

        if (driverAssignmentState.driverAssignment!.booking.id == booking.id &&
            driverAssignmentState.driverAssignment!.driver.id ==
                selectedCurrentDriver!.id) {
          currentDriverAssignment = driverAssignmentState.driverAssignment;
        } else {
          throw Exception('Current driver assignment not found');
        }

        final driverAssignmentId = currentDriverAssignment!.id;
        final oldDriverId = selectedCurrentDriver!.id;
        final newDriverId = selectedNewDriver!.id;

        await ref.read(driverAssignmentStateProvider.notifier).reassignDrivers(
            driverAssignmentId, booking.id, oldDriverId, newDriverId);

        await ref
            .read(bookingStateProvider.notifier)
            .getBookingDetails(booking.id);

        Navigator.pop(context);
      } else {
        throw Exception('Driver assignments not loaded');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reassign driver: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
