import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';
import 'package:tripnitor_mobile_app/pages/admin/forms/van_form.dart';

import '../van_admin_page.dart';

class VanAdminProfile extends StatelessWidget {
  final Van van;

  const VanAdminProfile({
    super.key,
    required this.van,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft, color: Colors.black),
          onPressed: () => Navigator.of(context).popUntil((route) =>
              route.isFirst || route is MaterialPageRoute<VanAdminPage>),
        ),
        title: Text(
          'Van Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
            thickness: 1,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            SizedBox(height: 24),
            _buildVanInfoSection(context, dateFormat, screenWidth),
            SizedBox(height: 24),
            _buildGasInfoSection(context, screenWidth),
            SizedBox(height: 40),
            _buildActionButtons(context),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(ColorConstants.BACKGROUND_COLOR),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor:
                Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
            child: Icon(
              Icons.directions_car,
              size: 70,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 16),
          Text(
            van.model,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.numbers,
                size: 16,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
              SizedBox(width: 4),
              Text(
                van.plateNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_gas_station,
                  color: Color(ColorConstants.PRIMARY_COLOR),
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '${van.gas?.gasName ?? "N/A"} - ₱${van.gas?.gasPrice ?? "0"}/liter',
                  style: TextStyle(
                    color: Color(ColorConstants.PRIMARY_COLOR),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVanInfoSection(
      BuildContext context, DateFormat dateFormat, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Van Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Color(ColorConstants.TERTIARY_COLOR),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.badge,
                    label: 'Van ID',
                    value: van.id,
                    screenWidth: screenWidth,
                  ),
                  Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.calendar_month,
                    label: 'Date Purchased',
                    value: dateFormat.format(van.dateBought),
                    screenWidth: screenWidth,
                  ),
                  Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.event_available,
                    label: 'Registration Expiry',
                    value: dateFormat.format(van.registrationExpiryDate),
                    screenWidth: screenWidth,
                  ),
                  Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.airline_seat_recline_normal,
                    label: 'Max Capacity',
                    value: '${van.maxPassengers} passengers',
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGasInfoSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Gas Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Color(ColorConstants.TERTIARY_COLOR),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.local_gas_station,
                    label: 'Gas Type',
                    value: van.gas?.gasName ?? 'N/A',
                    screenWidth: screenWidth,
                  ),
                  Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.attach_money,
                    label: 'Gas Price',
                    value: '₱${van.gas?.gasPrice ?? "0"}/liter',
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double screenWidth,
  }) {
    final bool isSmallScreen = screenWidth < 360;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(ColorConstants.PRIMARY_COLOR),
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        isSmallScreen
            ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'Edit Van',
              icon: Icons.edit,
              color: Color(ColorConstants.PRIMARY_COLOR),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VanForm(
                      van: van,
                      isEditMode: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
