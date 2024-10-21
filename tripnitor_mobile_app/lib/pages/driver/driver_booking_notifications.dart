import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';

class DriverBookingNotifications extends StatefulWidget {
  const DriverBookingNotifications({super.key});

  @override
  State<DriverBookingNotifications> createState() =>
      _DriverBookingNotificationsState();
}

class _DriverBookingNotificationsState
    extends State<DriverBookingNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        title: Text('Notifications'),
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    // return Column(
    //   children: [
    //     _notificationList(),
    //   ],
    // );
    return _notificationList();
  }

  Widget _notificationList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return _listViewItem(index);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: 15, // Sample length for UI
    );
    // return ListView.builder(
    //   itemCount: 15,
    //   itemBuilder: (context, index) {
    //     return _listViewItem(index);
    //   },
    // );
  }

  Widget _listViewItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _prefixIcon(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _notificationAlert(index),
                  _timeAndDate(index),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prefixIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(ColorConstants.SECONDARY_COLOR),
      ),
      child: Icon(
        Icons.notifications,
        size: 25,
        color: Color(ColorConstants.PRIMARY_COLOR),
      ),
    );
  }

  Widget _notificationAlert(int index) {
    double textSize = 14;
    return Container(
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: 'Notification ',
          style: TextStyle(
            fontSize: textSize,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: 'Notification Messsage',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationMessage(int index) {
    double textSize = 14;
    return Container(
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: 'Notification ',
          style: TextStyle(
            fontSize: textSize,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: 'Notification Messsage',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeAndDate(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '2024-9-20',
            style: TextStyle(fontSize: 10),
          ),
          Text(
            '7:10 am',
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
