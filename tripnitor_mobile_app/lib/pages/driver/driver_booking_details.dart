import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/booking_model.dart';
import 'package:tripnitor_mobile_app/pages/driver/driver_payment_details_page.dart';
import 'package:tripnitor_mobile_app/widgets/itinerary_details_page.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_itinerary_widgets/booking_itinerary_page.dart';
import '../../widgets/custom_modal_dialogue.dart';
import 'driver_driver_details_page.dart';

class DriverBookingDetails extends ConsumerStatefulWidget {
  final String bookingId;
  DriverBookingDetails({super.key, required this.bookingId});

  @override
  ConsumerState<DriverBookingDetails> createState() =>
      _DriverBookingDetailsState();
}

class _DriverBookingDetailsState extends ConsumerState<DriverBookingDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(bookingStateProvider.notifier)
        .getBookingDetails(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);

    if (bookingState.booking == null) {
      return Scaffold(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        appBar: AppBar(
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          scrolledUnderElevation: 0.0,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(ColorConstants.PRIMARY_COLOR),
          ),
        ),
      );
    }

    final DateFormat dateTimeFormat = DateFormat('d MMM yyyy, h:mm a');
    final booking = bookingState.booking!;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        scrolledUnderElevation: 0.0,
        title: Text(
          dateTimeFormat.format(booking.localCreatedAt!),
          style: TextStyle(
            fontSize: 18,
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
          onPressed: () {
            ref.read(bookingStateProvider.notifier).clearState();
            Navigator.pop(context);
          },
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
                    "Booking ID:",
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Text(booking.id,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booking Status:"),
                  _buildStatusTag(booking.status),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booked By:"),
                  Text(booking.user.name,
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
                  Text("Starts on:"),
                  Text(dateTimeFormat.format(booking.startDate),
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
                  Text("Ends on:"),
                  Text(dateTimeFormat.format(booking.endDate),
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
                  Text("Number of Passengers:"),
                  Text("${booking.numberOfPassengers}",
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
                          'Itinerary Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItineraryDetailsPage(),
                              ),
                            );
                          },
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
                        Flexible(
                          child: Text(booking.startLocation!.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Final Location: "),
                        Flexible(
                          child: Text(booking.finalDestination!.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
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
                        Text("Payment Method: "),
                        Text(booking.modeOfPayment,
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
                              "₱${booking.totalPrice}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DriverPaymentDetailsPage(
                                            booking: booking),
                                  ),
                                );
                              },
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DriverDriverDetailsPage(
                                  driverList: booking.drivers,
                                ),
                              ),
                            );
                          },
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
                      children: booking.drivers.asMap().entries.map((entry) {
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
              _startBookingButton(booking),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData? iconData;

    switch (status.toUpperCase()) {
      case 'PENDING':
        backgroundColor = Color(ColorConstants.ACCENT_COLOR);
        iconData = Icons.hourglass_empty;
        break;
      case 'CONFIRMED':
        backgroundColor = Color(ColorConstants.PRIMARY_COLOR);
        iconData = Icons.check_circle_outline;
        break;
      case 'ONGOING':
        backgroundColor = Color(ColorConstants.SUCCESS_COLOR);
        iconData = Icons.directions_car;
        break;
      case 'CANCELLED':
        backgroundColor = Color(ColorConstants.ERROR_COLOR);
        iconData = Icons.cancel_outlined;
        break;
      case 'COMPLETED':
        backgroundColor = Colors.green;
        iconData = Icons.task_alt;
        break;
      default:
        backgroundColor = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconData != null) ...[
            Icon(
              iconData,
              color: textColor,
              size: 16,
            ),
            SizedBox(width: 4),
          ],
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _startBookingButton(Booking booking) {
    final now = DateTime.now();
    final startDate = booking.startDate;
    final bool isEnabled = booking.status == "CONFIRMED";
    final bool isOngoing = booking.status == "ONGOING";
    final bool isCompleted = booking.status == "COMPLETED";
    final bool isWithinStartWindow =
        startDate.difference(now).inHours <= 6 && now.isBefore(startDate);
    final bool isOverdue = now.isAfter(startDate);

    void _showStartBookingDialogue(BuildContext context) {
      if (now.isBefore(startDate) && !isWithinStartWindow) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cannot Start Booking'),
              content: Text(
                  'This booking cannot be started yet. Please wait until 6 hours before the scheduled start time.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModalDialog(
            title: 'Start Booking',
            content: 'Are you sure you want to start this booking now?',
            onConfirm: () async {
              await ref
                  .read(bookingStateProvider.notifier)
                  .startBooking(booking.id);
            },
            color: Color(ColorConstants.SUCCESS_COLOR),
            buttonText: 'Start',
          );
        },
      );
    }

    String getOverdueText() {
      final difference = now.difference(startDate);
      if (difference.inDays > 0) {
        return 'Overdue by ${difference.inDays} days';
      } else if (difference.inHours > 0) {
        return 'Overdue by ${difference.inHours} hours';
      } else {
        return 'Overdue by ${difference.inMinutes} minutes';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isOverdue && !isOngoing && !isCompleted)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.red, size: 16),
                SizedBox(width: 4),
                Text(
                  getOverdueText(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingItineraryPage(
                      bookingId: widget.bookingId,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'View Itinerary',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        if (!isOngoing && !isCompleted)
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: isEnabled && (isWithinStartWindow || isOverdue)
                  ? () => _showStartBookingDialogue(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(ColorConstants.SUCCESS_COLOR),
                disabledBackgroundColor: Color(ColorConstants.DISABLED_COLOR),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Start Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
