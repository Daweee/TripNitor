import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/models/gas_model.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/van_form.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/gas_admin_profile.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/van_admin_profile.dart';

import '../../constants/constant.dart';
import 'admin_drawer.dart';

class VanAdminPage extends StatefulWidget {
  const VanAdminPage({super.key});

  @override
  State<VanAdminPage> createState() => _VanAdminPageState();
}

class _VanAdminPageState extends State<VanAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Vans',
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
      body: _vanAdminList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VanForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
    );
  }

  Widget _vanAdminList(BuildContext context) {
    final List<Van> VanList = [
      Van(
        id: '0001',
        model: 'Toyota',
        plateNumber: 'AB-1234',
        dateBought: DateTime(2024 - 1 - 2),
        registrationExpiryDate: DateTime(2024 - 1 - 25),
        maxPassengers: 15,
        gas: Gas(
          id: '0001',
          gasName: 'Unleaded',
          gasPrice: '\$1.5',
        ),
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 32),
          child: Row(
            children: [
              Text(
                "Van'\s List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: VanList.length,
              itemBuilder: (context, index) {
                return _vanBuildCard(context, VanList[index]);
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

  Widget _vanBuildCard(BuildContext context, Van van) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VanAdminProfile(van: van),
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
                'Van Model: ${van.model}',
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type of Gas: ${van.gas.gasName}',
                    overflow: TextOverflow.ellipsis,
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
