import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/providers/booking_provider.dart';
import '../../../../models/booking_model.dart';
import '../../../widgets/custom_modal_dialogue.dart';

class BookingAdminProfile extends ConsumerStatefulWidget {
  final Booking booking;
  const BookingAdminProfile({super.key, required this.booking});

  @override
  ConsumerState<BookingAdminProfile> createState() =>
      _BookingAdminProfileState();
}

class _BookingAdminProfileState extends ConsumerState<BookingAdminProfile> {
  @override
  Widget build(BuildContext context) {
    final DateFormat dateTimeFormat = DateFormat('d MMM yyyy, h:mm a');
    bool isBookingPending = widget.booking.status.toUpperCase() == 'PENDING';

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        scrolledUnderElevation: 0.0,
        title: Text(
          dateTimeFormat.format(widget.booking.createdAt),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
              Container(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Package Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: FaIcon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Starting Location: "),
                        Text(widget.booking.package.startLocation.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Final Location: "),
                        Text(widget.booking.package.finalDestination.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Payment Method: "),
                        Text(widget.booking.modeOfPayment,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Price:"),
                        Row(
                          children: [
                            Text(
                              "₱${widget.booking.totalPrice}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {},
                              child: FaIcon(
                                FontAwesomeIcons.angleRight,
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Driver Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: FaIcon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          widget.booking.drivers.asMap().entries.map((entry) {
                        final index = entry.key;
                        final driver = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(driver.user.name),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (widget.booking.status == 'PENDING') ...[
                _confirmBookingButton(widget.booking.id),
                SizedBox(
                  height: 20,
                ),
              ],
              _cancelBookingButton(widget.booking.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cancelBookingButton(String bookingStatus) {
    final bool isEnabled = bookingStatus == "PENDING";

    void _showCancelConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModalDialog(
            title: 'Cancel Booking',
            content:
                'Are you sure you want to cancel this booking? This action cannot be undone.',
            onConfirm: () {
              // Add your cancel booking logic here
              print('Booking cancelled');
            },
            color: Color(ColorConstants.CANCEL_COLOR),
            buttonText: 'Cancel Booking',
          );
        },
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: isEnabled ? () => _showCancelConfirmation() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(ColorConstants.CANCEL_COLOR),
          disabledBackgroundColor: Color(ColorConstants.DISABLED_COLOR),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Cancel Booking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _confirmBookingButton(String bookingId) {
    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModalDialog(
            title: 'Confirm Booking',
            content: 'Are you sure you want to confirm this booking?',
            onConfirm: () async {
              // Add your confirm booking logic here
              print('Booking confirmed: $bookingId');

              await ref
                  .read(bookingStateProvider.notifier)
                  .confirmBooking(bookingId);
            },
            color: Color(ColorConstants.PRIMARY_COLOR),
            buttonText: 'Confirm',
          );
        },
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () => _showConfirmationDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
          disabledBackgroundColor: Color(ColorConstants.DISABLED_COLOR),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Confirm Booking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
