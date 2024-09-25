import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import '../../../../models/booking_model.dart';

class BookingAdminProfile extends StatefulWidget {
  final Booking booking;
  BookingAdminProfile({super.key, required this.booking});

  @override
  State<BookingAdminProfile> createState() => _BookingAdminProfileState();
}

class _BookingAdminProfileState extends State<BookingAdminProfile> {
  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: Text('Are you sure you want to cancel this booking?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add your cancel logic here
                print("Booking cancelled");
              },
            ),
          ],
        );
      },
    );
  }

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
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Final Location: "),
                  Text(widget.booking.package.finalDestination.name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Number of Passengers: "),
                  Text("${widget.booking.numberOfPassengers}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Distance: "),
                  Text("${widget.booking.package.totalDistance} km",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Price per kilometer: "),
                  Text(
                    "${(widget.booking.package.totalDistance != null ? double.parse(widget.booking.package.totalDistance!) / 10 : 0).toStringAsFixed(1)} km",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Package Price: "),
                  Text(widget.booking.package.basePrice,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Base Fare: "),
                  Text(widget.booking.baseFare,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Method: "),
                  Text(widget.booking.modeOfPayment,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                        disabledBackgroundColor:
                            Color(ColorConstants.PRIMARY_COLOR)
                                .withOpacity(0.5),
                      ),
                      onPressed: isBookingPending
                          ? () {
                              // Add your confirm logic here
                              print("Booking confirmed");
                            }
                          : null,
                      child: Text(
                        isBookingPending ? 'Confirm' : 'Begin',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(ColorConstants.ERROR_COLOR),
                        disabledBackgroundColor: Colors.red.withOpacity(0.5),
                      ),
                      onPressed: isBookingPending
                          ? () {
                              _showCancelConfirmationDialog();
                            }
                          : null,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
