import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';

class DriverBookingDetails extends StatefulWidget {
  DriverBookingDetails({super.key});

  @override
  State<DriverBookingDetails> createState() => _DriverBookingDetailsState();
}

class _DriverBookingDetailsState extends State<DriverBookingDetails> {
  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(color: Colors.green, fontSize: 24),
                  ),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booking Status: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Regards By: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Client Name: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Route: "),
              //     Text("Booking Status: ",
              //         style: TextStyle(color: Colors.green)),
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pick Up: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Destination: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date:"),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Time: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Passengers: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Client Message: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Distance: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Price per kilometer: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Vat Tax: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overall Total Price: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Status: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Method: "),
                  Text("Booking Status: ",
                      style: TextStyle(color: Colors.green)),
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
                    ),
                    onPressed: () {},
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
