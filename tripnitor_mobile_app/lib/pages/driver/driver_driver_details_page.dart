import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/constant.dart';
import '../../models/driver_model.dart';

class DriverDriverDetailsPage extends StatefulWidget {
  final List<Driver> driverList;
  DriverDriverDetailsPage({super.key, required this.driverList});

  @override
  State<DriverDriverDetailsPage> createState() =>
      _DriverDriverDetailsPageState();
}

class _DriverDriverDetailsPageState extends State<DriverDriverDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Drivers Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
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
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: widget.driverList.map((driver) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _individualDriverContainer(driver),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _individualDriverContainer(Driver driver) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _driverInfoSection(driver),
        ],
      ),
    );
  }

  Widget _driverInfoSection(Driver driver) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driver.user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            driver.user.phoneNumber,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            driver.licenseNumber,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            '${driver.van.model} • ${driver.van.plateNumber}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
