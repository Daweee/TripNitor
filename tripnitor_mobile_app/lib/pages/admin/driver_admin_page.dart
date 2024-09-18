import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/driver_admin_profile.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/drivers_form.dart';
import 'package:tripnitor_mobile_app/providers/driver_provider.dart';
import '../../constants/constant.dart';
import 'admin_drawer.dart';

class DriverAdminPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<DriverAdminPage> createState() => _DriverAdminPageState();
}

class _DriverAdminPageState extends ConsumerState<DriverAdminPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverStateProvider.notifier).getDriverList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final driverState = ref.watch(driverStateProvider);
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Drivers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
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
      drawer: const AdminDrawer(),
      body: _DriverAdminList(driverState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriversForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
    );
  }

  Widget _DriverAdminList(driverState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 32),
          child: Row(
            children: [
              Text(
                "Driver's List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: driverState.driverList?.length ?? 0,
              itemBuilder: (context, index) {
                return _DriverBuildCard(
                    context, driverState.driverList![index]);
              },
            ),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _DriverBuildCard(BuildContext context, Driver driver) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverAdminProfile(driver: driver),
          ),
        );
      },
      child: Card(
        color: Color(ColorConstants.TERTIARY_COLOR),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${driver.user.name}',
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      'Username: ${driver.user.username}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Email: ${driver.user.email}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DriversForm(
                                  driver: driver), // Pass the driver object
                            ),
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Driver"),
                                content: Text(
                                    "Are you sure you want to delete this driver?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (result == true) {
                            await ref
                                .read(driverStateProvider.notifier)
                                .deleteDriver(driver.id);
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
