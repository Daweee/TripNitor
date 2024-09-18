import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';

class DriverAdminProfile extends StatelessWidget {
  final Driver driver;

  DriverAdminProfile({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32.0,
                      right: 16,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/Unknown_person.jpg'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Name: ${driver.user.name} ', // ${driver.user.name}
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            'Email: ${driver.user.email}'), // ${driver.user.email}
                        Text(
                            'Phone Number: ${driver.user.phoneNumber}'), // ${driver.user.username}
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 48, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username: ${driver.user.username}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Role: ${driver.user.role}'),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Driver\'s ID: ${driver.id}'),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Driver\'s License: ${driver.licenseNumber}', // ${driver.user.name}
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Date Hired: ${dateFormat.format(driver.dateHired)}'), // ${driver.user.email}
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 32),
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Delete'),
                      ),
                    ),
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
