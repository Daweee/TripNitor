import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';

import '../../../../models/booking_model.dart';

class DriverBookingDetails extends StatefulWidget {
  final Booking booking;
  DriverBookingDetails({super.key, required this.booking});

  @override
  State<DriverBookingDetails> createState() => _DriverBookingDetailsState();
}

class _DriverBookingDetailsState extends State<DriverBookingDetails> {
  @override
  Widget build(BuildContext context) {
    bool isBookingPending = widget.booking.status.toUpperCase() == 'PENDING';

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        title: Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: Text('Task'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Booking ID: ",
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Text(widget.booking.id,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booking Status: "),
                  Text(widget.booking.status,
                      style: TextStyle(
                          color: Color(ColorConstants.ACCENT_COLOR),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booked By: "),
                  Text(widget.booking.user.name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Starting Location: "),
                  Text(widget.booking.package.startLocation.name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Final Location: "),
                  Text(widget.booking.package.finalDestination.name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booking Date:"),
                  Text(
                      DateFormat('MMMM dd yyyy')
                          .format(widget.booking.createdAt),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Number of Passengers: "),
                  Text("${widget.booking.numberOfPassengers}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Distance: "),
                  Text("${widget.booking.package.totalDistance} km",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Base Fare: "),
                  Text('₱${widget.booking.baseFare}',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Package Fare: "),
                  Text('₱${widget.booking.package.basePrice}',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booking Duration: "),
                  Text("(${widget.booking.numberOfNights}) ₱1000",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overall Total Price: "),
                  Text(widget.booking.totalPrice,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Method: "),
                  Text(widget.booking.modeOfPayment,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * .4,
                  height: MediaQuery.sizeOf(context).height * .06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                      disabledBackgroundColor:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.5),
                    ),
                    onPressed: isBookingPending ? null : () {},
                    child: Text(
                      'Begin',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
