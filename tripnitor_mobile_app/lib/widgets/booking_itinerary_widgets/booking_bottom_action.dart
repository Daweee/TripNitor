import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/models/booking_model.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/providers/booking_provider.dart';
import '../../core/constants/constant.dart';
import '../../services/url_launcher_service.dart';

class BookingBottomAction extends ConsumerWidget {
  const BookingBottomAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingStateProvider);
    final booking = bookingState.booking;

    if (booking == null ||
        booking.status == "COMPLETED" ||
        booking.status == "CANCELLED" ||
        booking.status == "PENDING") {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(ColorConstants.BACKGROUND_COLOR),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {
            _showDriverContactOptions(context, booking);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.userGroup,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Contact Drivers',
                style: TextStyle(
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

  void _showDriverContactOptions(BuildContext context, Booking booking) {
    final drivers = booking.drivers;

    if (drivers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No drivers assigned to this booking yet.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'Assigned Drivers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    final name = driver.user.name;
                    final phoneNumber = driver.user.phoneNumber;
                    final vehicleInfo = driver.van.model;
                    final licensePlate = driver.van.plateNumber;

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(ColorConstants.PRIMARY_COLOR)
                                .withOpacity(0.1),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'D',
                              style: TextStyle(
                                color: Color(ColorConstants.PRIMARY_COLOR),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(name),
                          subtitle: Row(
                            children: [
                              Text(vehicleInfo),
                              if (licensePlate.isNotEmpty) ...[
                                SizedBox(width: 8),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(licensePlate),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (phoneNumber.isNotEmpty)
                                IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(ColorConstants.PRIMARY_COLOR)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.phone,
                                      color:
                                          Color(ColorConstants.PRIMARY_COLOR),
                                      size: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    UrlLauncherService.makePhoneCall(
                                        phoneNumber);
                                  },
                                ),
                              if (phoneNumber.isNotEmpty)
                                IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(ColorConstants.PRIMARY_COLOR)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.commentSms,
                                      color:
                                          Color(ColorConstants.PRIMARY_COLOR),
                                      size: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    UrlLauncherService.sendSMS(phoneNumber);
                                  },
                                ),
                            ],
                          ),
                          onTap: () {
                            _showDriverDetailsAndOptions(context, driver);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDriverDetailsAndOptions(BuildContext context, Driver driver) {
    final name = driver.user.name;
    final phoneNumber = driver.user.phoneNumber;
    final email = driver.user.email;
    final vehicleInfo = driver.van.model;
    final licensePlate = driver.van.plateNumber;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.7,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(ColorConstants.PRIMARY_COLOR)
                              .withOpacity(0.1),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'D',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(ColorConstants.PRIMARY_COLOR),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Driver',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  if (vehicleInfo.isNotEmpty || licensePlate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vehicle Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (vehicleInfo.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.car,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 8),
                                  Text(vehicleInfo),
                                ],
                              ),
                            ),
                          if (licensePlate.isNotEmpty)
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.idCard,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 8),
                                Text('License: $licensePlate'),
                              ],
                            ),
                        ],
                      ),
                    ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Options',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        if (phoneNumber.isNotEmpty)
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.PRIMARY_COLOR)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.phone,
                                color: Color(ColorConstants.PRIMARY_COLOR),
                                size: 20,
                              ),
                            ),
                            title: Text('Call Driver'),
                            subtitle: Text(phoneNumber),
                            onTap: () {
                              Navigator.pop(context);
                              UrlLauncherService.makePhoneCall(phoneNumber);
                            },
                          ),
                        if (phoneNumber.isNotEmpty)
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.PRIMARY_COLOR)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.commentSms,
                                color: Color(ColorConstants.PRIMARY_COLOR),
                                size: 20,
                              ),
                            ),
                            title: Text('Send SMS'),
                            subtitle: Text(phoneNumber),
                            onTap: () {
                              Navigator.pop(context);
                              UrlLauncherService.sendSMS(phoneNumber);
                            },
                          ),
                        if (email.isNotEmpty)
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.PRIMARY_COLOR)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.envelope,
                                color: Color(ColorConstants.PRIMARY_COLOR),
                                size: 20,
                              ),
                            ),
                            title: Text('Email Driver'),
                            subtitle: Text(email),
                            onTap: () {
                              Navigator.pop(context);
                              UrlLauncherService.launchEmail(
                                email,
                                subject: 'Regarding Your Trip',
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
