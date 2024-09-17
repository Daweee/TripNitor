import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/models/auth_model.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/models/gas_model.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/driver_admin_profile.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/drivers_form.dart';

import '../../constants/constant.dart';
import 'admin_drawer.dart';

class DriverAdminPage extends StatefulWidget {
  const DriverAdminPage({super.key});

  @override
  State<DriverAdminPage> createState() => _DriverAdminPageState();
}

class _DriverAdminPageState extends State<DriverAdminPage> {
  @override
  Widget build(BuildContext context) {
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
      body: _DriverAdminList(context),
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

  Widget _DriverAdminList(BuildContext context) {
    final List<Driver> DriversList = [
      Driver(
        user: User(
          id: '0001',
          username: 'Ryan123',
          email: 'ryanpatalinghub@example.com',
          name: 'Ryan Patalinghug',
          phoneNumber: '09876543211',
          role: 'DRIVER',
        ),
        licenseNumber: '0001',
        dateHired: DateTime(2024, 1, 2), // yy-mm-dd
        van: Van(
          id: '0001',
          model: 'Toyota',
          plateNumber: '20-2024',
          dateBought: DateTime(2024, 1, 3),
          registrationExpiryDate: DateTime(2024, 1, 25),
          maxPassengers: 15,
          gas: Gas(
            id: '001',
            gasName: 'Diesel',
            gasPrice: '100',
          ),
        ),
      ),
      Driver(
        user: User(
          id: '0002',
          username: 'AJ',
          email: 'AJ@example.com',
          name: 'Alberto Anunciado',
          phoneNumber: '09876543211',
          role: 'DRIVER',
        ),
        licenseNumber: '0002a',
        dateHired: DateTime(2024, 2, 2), // yy-mm-dd
        van: Van(
          id: '0002',
          model: 'Isuzu',
          plateNumber: '20-2025',
          dateBought: DateTime(2024, 2, 3),
          registrationExpiryDate: DateTime(2024, 2, 25),
          maxPassengers: 15,
          gas: Gas(
            id: '002',
            gasName: 'Unleaded',
            gasPrice: '200',
          ),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 32),
          child: Row(
            children: [
              Text(
                "Driver'\s List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: DriversList.length,
              itemBuilder: (context, index) {
                return _DriverBuildCard(context, DriversList[index]);
              },
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: _DriverBuildCard(context),
        // ),
      ],
    );
  }

  Widget _DriverBuildCard(BuildContext context, Driver driver) {
    // , Driver driver
    // final Driver driver;

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
              Text(
                'Name: ${driver.user.name}',
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
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
                  SizedBox(
                    width: 16,
                  ),
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           DriverProfilePage(driver: driver)),
                          // );
                        },
                        icon: Icon(Icons.edit, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.delete, color: Colors.red),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
