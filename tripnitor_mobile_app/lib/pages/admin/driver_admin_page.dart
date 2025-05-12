import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/driver_admin_profile.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/drivers_form.dart';
import 'package:tripnitor_mobile_app/providers/driver_provider.dart';
import '../../core/constants/constant.dart';
import 'admin_drawer.dart';

class CustomModalDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final Color? color;
  final String buttonText;

  const CustomModalDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.color,
    this.buttonText = 'OK',
  });

  @override
  Widget build(BuildContext context) {
    final dialogColor = color ?? Theme.of(context).colorScheme.primary;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      child: contentBox(context, dialogColor),
    );
  }

  Widget contentBox(BuildContext context, Color dialogColor) {
    return Container(
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
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: dialogColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            content,
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
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dialogColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  buttonText,
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
    );
  }
}

class DriverAdminPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<DriverAdminPage> createState() => _DriverAdminPageState();
}

class _DriverAdminPageState extends ConsumerState<DriverAdminPage> {
  bool _isLoading = true;
  String?
      _activeFilter; // null = all, 'active' = only active, 'inactive' = only inactive

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDrivers();
    });
  }

  Future<void> _loadDrivers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ref.read(driverStateProvider.notifier).getDriverList();
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to load drivers: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
    final driverState = ref.watch(driverStateProvider);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: _buildAppBar(),
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          _buildFilterContainer(screenHeight),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(ColorConstants.PRIMARY_COLOR),
                    ),
                  )
                : _buildDriverList(driverState),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 1),
      child: AppBar(
        title: Text(
          'Drivers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        elevation: 0,
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
    );
  }

  Widget _buildFilterContainer(double screenHeight) {
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
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Driver Status',
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
                  value: _activeFilter,
                  onChanged: (value) {
                    setState(() {
                      _activeFilter = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        'All Drivers',
                        style: TextStyle(color: Colors.black.withOpacity(.5)),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'active',
                      child: Text(
                        'Active Only',
                        style: TextStyle(color: Colors.black.withOpacity(.5)),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'inactive',
                      child: Text(
                        'Inactive Only',
                        style: TextStyle(color: Colors.black.withOpacity(.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriversForm(),
          ),
        ).then((_) => _loadDrivers());
      },
      child: Icon(
        Icons.add,
        color: Color(ColorConstants.BACKGROUND_COLOR),
      ),
      backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildDriverList(driverState) {
    // Check if the list is empty
    if (driverState.driverList == null || driverState.driverList!.isEmpty) {
      return _buildEmptyState();
    }

    // Filter the driver list based on the active filter
    final filteredList = _activeFilter == null
        ? driverState.driverList!
        : driverState.driverList!
            .where((driver) =>
                (_activeFilter == 'active' && driver.user.isActive) ||
                (_activeFilter == 'inactive' && !driver.user.isActive))
            .toList();

    // Check if filtered list is empty
    if (filteredList.isEmpty) {
      return _buildFilteredEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadDrivers,
      color: Color(ColorConstants.PRIMARY_COLOR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            child: Text(
              "Driver's List",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return _buildDriverCard(context, filteredList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 80,
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No drivers found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add a new driver using the + button',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadDrivers,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
              foregroundColor: Color(ColorConstants.BACKGROUND_COLOR),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _activeFilter == 'active' ? Icons.person_off : Icons.person,
            size: 80,
            color: _activeFilter == 'active'
                ? Colors.green.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No ${_activeFilter == 'active' ? 'active' : 'inactive'} drivers found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _activeFilter == 'active'
                ? 'Try changing the filter to see all drivers'
                : 'No drivers are currently inactive',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _activeFilter = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
              foregroundColor: Color(ColorConstants.BACKGROUND_COLOR),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Show All Drivers'),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, Driver driver) {
    final bool isActive = driver.user.isActive;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(ColorConstants.TERTIARY_COLOR),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
        border:
            isActive ? null : Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DriverAdminProfile(driver: driver),
              ),
            ).then((_) => _loadDrivers());
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isActive
                          ? Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.2)
                          : Colors.grey[300],
                      radius: 24,
                      child: Text(
                        driver.user.name.isNotEmpty
                            ? driver.user.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: isActive
                              ? Color(ColorConstants.PRIMARY_COLOR)
                              : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  driver.user.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isActive
                                        ? Colors.black
                                        : Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8),
                              _buildStatusTag(isActive),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'License: ${driver.licenseNumber}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      icon: Icons.visibility,
                      color: Colors.blue,
                      label: 'View',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DriverAdminProfile(driver: driver),
                          ),
                        ).then((_) => _loadDrivers());
                      },
                    ),
                    SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.edit,
                      color: Colors.green,
                      label: 'Edit',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DriversForm(driver: driver),
                          ),
                        ).then((_) => _loadDrivers());
                      },
                    ),
                    SizedBox(width: 8),
                    _buildActionButton(
                      icon: isActive ? Icons.person_off : Icons.person,
                      color: isActive
                          ? Color(ColorConstants.CANCEL_COLOR)
                          : Color(ColorConstants.PRIMARY_COLOR),
                      label: isActive ? 'Deactivate' : 'Activate',
                      onTap: () => _showStatusChangeConfirmation(driver),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStatusChangeConfirmation(Driver driver) async {
    final bool isActive = driver.user.isActive;
    final String action = isActive ? 'deactivate' : 'activate';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModalDialog(
          title:
              "${action.substring(0, 1).toUpperCase()}${action.substring(1)} Driver",
          content: "Are you sure you want to $action ${driver.user.name}?",
          buttonText:
              action.substring(0, 1).toUpperCase() + action.substring(1),
          color: isActive
              ? Color(ColorConstants.CANCEL_COLOR)
              : Color(ColorConstants.PRIMARY_COLOR),
          onConfirm: () async {
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
              _loadDrivers();
            } catch (error) {
              _showSnackBar(
                  'Failed to ${action} driver. Please try again later.',
                  isError: true);
            }
          },
        );
      },
    );
  }
}
