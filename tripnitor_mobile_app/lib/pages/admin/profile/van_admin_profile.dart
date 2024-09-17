import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';

class VanAdminProfile extends StatelessWidget {
  final Van van;

  VanAdminProfile({
    super.key,
    required this.van,
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
                        Text('Van Model: ${van.model} ', // ${driver.user.name}
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            'Van\'s Plate No. : ${van.plateNumber}'), // ${driver.user.email}
                        Text(
                            'Type of Gas: ${van.gas.gasName}'), // ${driver.user.username}
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
                    SizedBox(
                      height: 8,
                    ),
                    Text('Date of Purchase: ${van.dateBought}'),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Data of Expiration: ${van.registrationExpiryDate}'),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Van\'s Maximum Capacity: ${van.maxPassengers}', // ${driver.user.name}
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'Price of Gas: ${van.gas.gasPrice}'), // ${driver.user.email}
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
