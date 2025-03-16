import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';

import '../van_admin_page.dart';

class VanAdminProfile extends StatelessWidget {
  final Van van;

  VanAdminProfile({
    super.key,
    required this.van,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => VanAdminPage()),
              (route) => false,
            );
          },
        ),
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
                        Text('Van Model: ${van.model}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Van\'s Plate No. : ${van.plateNumber}'),
                        Text('Type of Gas: ${van.gas?.gasName}'),
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
                      'Van ID: ${van.id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                        'Date of Purchase: ${dateFormat.format(van.dateBought)}'),
                    SizedBox(height: 8),
                    Text(
                        'Date of Expiration: ${dateFormat.format(van.registrationExpiryDate)}'),
                    SizedBox(height: 8),
                    Text(
                      'Van\'s Maximum Capacity: ${van.maxPassengers}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Price of Gas: ₱${van.gas?.gasPrice}/liter'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
