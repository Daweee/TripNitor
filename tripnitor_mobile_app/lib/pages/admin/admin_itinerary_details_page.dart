import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/models/leg_model.dart';
import 'package:tripnitor_mobile_app/models/package_model.dart';
import '../../constants/constant.dart';

class AdminItineraryDetailsPage extends StatefulWidget {
  final Package package;

  const AdminItineraryDetailsPage({super.key, required this.package});

  @override
  State<AdminItineraryDetailsPage> createState() =>
      _AdminItineraryDetailsPageState();
}

class _AdminItineraryDetailsPageState extends State<AdminItineraryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Itinerary Details',
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
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildItineraryList(),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            _totalDistanceText(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItineraryList() {
    List<Widget> itineraryWidgets = [];

    itineraryWidgets.add(
      _locationPoint(
        locationName: widget.package.startLocation.name,
        isMiniStop: false,
        iconData: FontAwesomeIcons.solidCircleDot,
        iconColor: Color(0xFFFB0000),
        iconSize: 25.0,
      ),
    );

    itineraryWidgets.add(_verticalDashLines());

    for (int i = 0; i < widget.package.legs.length; i++) {
      Leg leg = widget.package.legs[i];

      if (i > 0) {
        itineraryWidgets.add(
          _locationPoint(
            locationName: leg.startLocation.name,
            isMiniStop: true,
            iconData: FontAwesomeIcons.solidCircleDot,
            iconColor: Color(ColorConstants.PRIMARY_COLOR),
            iconSize: 15.0,
            departureTime: leg.departureTime,
            arrivalTime: leg.arrivalTime,
          ),
        );
        itineraryWidgets.add(_verticalDashLines());
      }
    }

    itineraryWidgets.add(
      _locationPoint(
        locationName: widget.package.finalDestination.name,
        isMiniStop: false,
        iconData: FontAwesomeIcons.locationDot,
        iconColor: Colors.black,
        iconSize: 28.0,
      ),
    );

    return itineraryWidgets;
  }

  Widget _locationPoint({
    required String locationName,
    required IconData iconData,
    required Color iconColor,
    required double iconSize,
    required bool isMiniStop,
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) {
    double horizontalPadding = isMiniStop ? 3.0 : 0.0;

    return Container(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: FaIcon(
                iconData,
                size: iconSize,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: 40),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isMiniStop ? null : FontWeight.bold,
                  ),
                ),
                if (departureTime != null || arrivalTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        if (departureTime != null)
                          Text(
                            'Departure: ${_formatDateTime(departureTime)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        if (departureTime != null && arrivalTime != null)
                          Text(' • '),
                        if (arrivalTime != null)
                          Text(
                            'Arrival: ${_formatDateTime(arrivalTime)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _totalDistanceText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Total Distance: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '${widget.package.totalDistance} km',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _verticalDashLines() {
    return Row(
      children: [
        Container(
          width: 23,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Dash(
              direction: Axis.vertical,
              length: 35,
              dashLength: 5,
              dashColor: Colors.black.withOpacity(.5),
              dashGap: 5,
              dashThickness: 2,
            ),
          ),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
