import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/drivers_form.dart';

import '../../../providers/driver_provider.dart';

class DriverAdminProfile extends ConsumerStatefulWidget {
  final Driver driver;

  const DriverAdminProfile({
    super.key,
    required this.driver,
  });

  @override
  ConsumerState<DriverAdminProfile> createState() => _DriverAdminProfileState();
}

class _DriverAdminProfileState extends ConsumerState<DriverAdminProfile> {
  late Driver driver;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    driver = widget.driver;
  }

  Future<void> _refreshDriverDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      await ref.read(driverStateProvider.notifier).getDriverDetail(driver.id);
      final driverState = ref.read(driverStateProvider);

      if (driverState.driver != null) {
        setState(() {
          driver = driverState.driver!;
        });
      }

      if (driverState.error != null) {
        _showSnackBar(driverState.error!, isError: true);
      }
    } catch (e) {
      _showSnackBar('Failed to refresh driver details: ${e.toString()}',
          isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(15),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isActive = driver.user.isActive;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Driver Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
            thickness: 1,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, isActive),
            SizedBox(height: 24),
            _buildInfoSection(context, dateFormat, screenWidth),
            SizedBox(height: 40),
            _buildActionButtons(context),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isActive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(ColorConstants.BACKGROUND_COLOR),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: isActive
                    ? Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1)
                    : Colors.grey[200],
                child: Text(
                  driver.user.name.isNotEmpty
                      ? driver.user.name[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? Color(ColorConstants.PRIMARY_COLOR)
                        : Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            driver.user.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone,
                size: 16,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
              SizedBox(width: 4),
              Text(
                driver.user.phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                size: 16,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
              SizedBox(width: 4),
              Text(
                driver.user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, DateFormat dateFormat, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Driver Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Color(ColorConstants.TERTIARY_COLOR),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.person,
                    label: 'Username',
                    value: driver.user.username,
                    screenWidth: screenWidth,
                  ),
                  Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.badge,
                    label: 'Driver ID',
                    value: driver.id,
                    screenWidth: screenWidth,
                  ),
                  Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.credit_card,
                    label: 'License Number',
                    value: driver.licenseNumber,
                    screenWidth: screenWidth,
                  ),
                  Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Date Hired',
                    value: dateFormat.format(driver.dateHired),
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double screenWidth,
  }) {
    final bool isSmallScreen = screenWidth < 360;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(ColorConstants.PRIMARY_COLOR),
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        isSmallScreen
            ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'Edit Profile',
              icon: Icons.edit,
              color: Color(ColorConstants.PRIMARY_COLOR),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriversForm(driver: driver),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              label: driver.user.isActive ? 'Deactivate' : 'Activate',
              icon: driver.user.isActive ? Icons.person_off : Icons.person,
              color: driver.user.isActive
                  ? Color(ColorConstants.CANCEL_COLOR)
                  : Colors.green,
              onTap: () {
                _showStatusChangeConfirmation(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusChangeConfirmation(BuildContext context) {
    final bool isActive = driver.user.isActive;
    final String action = isActive ? 'deactivate' : 'activate';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(ColorConstants.BACKGROUND_COLOR),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${action.substring(0, 1).toUpperCase()}${action.substring(1)} Driver",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? Color(ColorConstants.CANCEL_COLOR)
                        : Color(ColorConstants.PRIMARY_COLOR),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "Are you sure you want to $action ${driver.user.name}?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();

                        setState(() {
                          isLoading = true;
                        });

                        try {
                          if (isActive) {
                            await ref
                                .read(driverStateProvider.notifier)
                                .deactivateDriver(driver.id);
                          } else {
                            await ref
                                .read(driverStateProvider.notifier)
                                .reactivateDriver(driver.id);
                          }

                          final currentState = ref.read(driverStateProvider);
                          if (currentState.error != null) {
                            throw Exception(currentState.error);
                          }

                          _showSnackBar(currentState.message ??
                              'Driver ${isActive ? 'deactivated' : 'activated'} successfully');

                          await _refreshDriverDetails();
                        } catch (error) {
                          _showSnackBar(
                              'Failed to ${action} driver: ${error.toString()}',
                              isError: true);

                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isActive
                            ? Color(ColorConstants.CANCEL_COLOR)
                            : Color(ColorConstants.PRIMARY_COLOR),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        action.substring(0, 1).toUpperCase() +
                            action.substring(1),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
