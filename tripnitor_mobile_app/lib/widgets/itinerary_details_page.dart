import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/providers/booking_provider.dart';
import '../models/booking_leg_model.dart';

class ItineraryDetailsPage extends ConsumerStatefulWidget {
  const ItineraryDetailsPage({super.key});

  @override
  ConsumerState<ItineraryDetailsPage> createState() =>
      _ItineraryDetailsPageState();
}

class _ItineraryDetailsPageState extends ConsumerState<ItineraryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: const Text(
            'Itinerary Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
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
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            _totalDistanceText(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItineraryList() {
    final bookingState = ref.watch(bookingStateProvider);
    List<Widget> itineraryWidgets = [];

    itineraryWidgets.add(
      _locationPoint(
        locationName: bookingState.booking!.bookingLeg.first.startLocation.name,
        locationAddress:
            bookingState.booking!.bookingLeg.first.startLocation.address ?? '',
        isMiniStop: false,
        iconData: FontAwesomeIcons.locationDot,
        iconColor: const Color(ColorConstants.PRIMARY_COLOR),
        iconSize: 16.0,
        isStartPoint: true,
      ),
    );

    itineraryWidgets.add(_verticalDashLines());

    for (int i = 0; i < bookingState.booking!.bookingLeg.length; i++) {
      BookingLeg leg = bookingState.booking!.bookingLeg[i];

      if (i > 0) {
        itineraryWidgets.add(
          _locationPoint(
            locationName: leg.startLocation.name,
            locationAddress: leg.startLocation.address ?? '',
            isMiniStop: true,
            iconData: FontAwesomeIcons.locationDot,
            iconColor: const Color(ColorConstants.PRIMARY_COLOR),
            iconSize: 16.0,
            stopIndex: i,
          ),
        );

        itineraryWidgets.add(_verticalDashLines());
      }
    }

    itineraryWidgets.add(
      _locationPoint(
        locationName: bookingState.booking!.bookingLeg.last.endLocation.name,
        locationAddress:
            bookingState.booking!.bookingLeg.last.endLocation.address ?? '',
        isMiniStop: false,
        iconData: FontAwesomeIcons.locationDot,
        iconColor: Colors.red,
        iconSize: 16.0,
        isFinalPoint: true,
      ),
    );

    return itineraryWidgets;
  }

  Widget _locationPoint({
    required String locationName,
    required String locationAddress,
    required IconData iconData,
    required Color iconColor,
    required double iconSize,
    required bool isMiniStop,
    bool isStartPoint = false,
    bool isFinalPoint = false,
    int? stopIndex,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isStartPoint
                ? const Color(ColorConstants.PRIMARY_COLOR)
                : (isFinalPoint
                    ? Colors.red
                    : const Color(ColorConstants.PRIMARY_COLOR)),
            shape: BoxShape.circle,
            border: Border.all(
              color: isStartPoint
                  ? const Color(0xFFB38428)
                  : (isFinalPoint ? Colors.red.shade900 : Colors.white),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: isMiniStop && stopIndex != null
                ? Text(
                    '$stopIndex',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                : FaIcon(
                    iconData,
                    color: Colors.white,
                    size: iconSize,
                  ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locationName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isMiniStop ? FontWeight.w500 : FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                locationAddress,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _totalDistanceText() {
    final bookingState = ref.watch(bookingStateProvider);
    final totalDistance = bookingState.booking?.package.totalDistance ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: 'Total Distance: ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '$totalDistance km',
                style: const TextStyle(
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
          width: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
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
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
