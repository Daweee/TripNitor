import 'dart:ui_web';

import 'package:flutter/material.dart';
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
                      right: 16.0,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/Unknown_person.jpg'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${driver.user.name} ', // ${driver.user.name}
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Email: ${driver.user.email}'), // ${driver.user.email}
                      Text(
                          'Username: ${driver.user.username}'), // ${driver.user.username}
                    ],
                  ),
                ],
              ),

              Text('Name: sdasd', // ${driver.user.name}
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Age: asdasdds'), // ${driver.user.email}
              Text('Gender: asdasdasd'), // ${driver.user.username}
              Text('Name: sdasd', // ${driver.user.name}
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Age: asdasdds'), // ${driver.user.email}
              Text('Gender: asdasdasd'), // ${driver.user.username}
            ],
          ),
        ),
      ),
    );
  }
}
