import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_save_task.dart';
import 'package:tripnitor_mobile_app/pages/_admin_page/adminBottomNav/_driverAdmin/models/_driver_task.dart';
import 'package:tripnitor_mobile_app/pages/driver_homepage.dart';

class DriverList extends StatefulWidget {
  const DriverList({super.key});

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _header(),
          _subHeader(),
          //_DriverListBody(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .065,
      color: Color(ColorConstants.PRIMARY_COLOR),
      child: Center(
        child: Text(
          'Tripnitor Admin',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }

  Widget _subHeader() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Driver List:',
            style: TextStyle(fontSize: 16),
          ),
          GestureDetector(
            onTap: () {},
            child: Image(
              image: AssetImage(
                'assets/icons/carbon_add-filled.png',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // dynamically add list of drivers by admin; to be continued
  // Widget _DriverListBody() {
  //   return SingleChildScrollView(
  //     child: Consumer<DriverSaveTask>(
  //       builder: (context, DriverTask, child) {
  //         return ListView.builder(
  //           itemCount: DriverTask.fromDriverTask.length,
  //           itemBuilder: (BuildContext context, index) {},
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _DriverTask() {
    return Container();
  }
}
