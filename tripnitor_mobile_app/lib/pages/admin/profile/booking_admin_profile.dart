import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/providers/booking_provider.dart';
import 'package:tripnitor_mobile_app/widgets/itinerary_details_page.dart';
import '../../../../models/booking_model.dart';
import '../../../widgets/booking_itinerary_widgets/booking_itinerary_page.dart';
import '../../../widgets/custom_modal_dialogue.dart';
import '../admin_driver_details_page.dart';
import '../admin_payment_details_page.dart';

class BookingAdminProfile extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingAdminProfile({Key? key, required this.bookingId});

  @override
  ConsumerState<BookingAdminProfile> createState() =>
      _BookingAdminProfileState();
}

class _BookingAdminProfileState extends ConsumerState<BookingAdminProfile> {
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
    final DateFormat dateTimeFormat = DateFormat('d MMM yyyy, h:mm a');

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        scrolledUnderElevation: 0.0,
        title: bookingState.booking != null
            ? Text(
                dateTimeFormat.format(bookingState.booking!.localCreatedAt!),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Container(),
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
      body: bookingState.booking == null
          ? Center(
              child: CircularProgressIndicator(
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            )
          : SingleChildScrollView(
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
                        Text(bookingState.booking!.id,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Booking Status:"),
                        _buildStatusTag(bookingState.booking!.status),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Booked By:"),
                        Text(bookingState.booking!.user.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Starts on:"),
                        Text(
                            dateTimeFormat
                                .format(bookingState.booking!.startDate),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ends on:"),
                        Text(
                            dateTimeFormat
                                .format(bookingState.booking!.endDate),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Number of Passengers:"),
                        Text("${bookingState.booking!.numberOfPassengers}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
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
                                      builder: (context) =>
                                          ItineraryDetailsPage(),
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
                                child: Text(
                                  bookingState.booking?.startLocation?.name ??
                                      "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Final Location: "),
                              Flexible(
                                child: Text(
                                  bookingState
                                          .booking?.finalDestination?.name ??
                                      "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                              Text(bookingState.booking!.modeOfPayment,
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
                                    "₱${bookingState.booking!.totalPrice}",
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
                                              AdminPaymentDetailsPage(
                                                  booking:
                                                      bookingState.booking!),
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
                    if (bookingState.booking!.drivers.isNotEmpty)
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
                                        builder: (context) =>
                                            AdminDriverDetailsPage(
                                                driverList: bookingState
                                                    .booking!.drivers),
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
                              children: bookingState.booking!.drivers
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final driver = entry.value;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
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
                            backgroundColor:
                                Color(ColorConstants.PRIMARY_COLOR),
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
                    if (bookingState.booking!.status == 'PENDING') ...[
                      _confirmBookingButton(bookingState.booking!),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                    _cancelBookingButton(bookingState.booking!),
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

  Widget _cancelBookingButton(Booking booking) {
    final bool isEnabled = booking.status == "PENDING";

    void _showCancelConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModalDialog(
            title: 'Cancel Booking',
            content:
                'Are you sure you want to cancel this booking? This action cannot be undone.',
            onConfirm: () async {
              await ref
                  .read(bookingStateProvider.notifier)
                  .cancelBooking(booking.id);
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

  Widget _confirmBookingButton(Booking booking) {
    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomModalDialog(
            title: 'Confirm Booking',
            content: 'Are you sure you want to confirm this booking?',
            onConfirm: () async {
              await ref
                  .read(bookingStateProvider.notifier)
                  .confirmBooking(booking.id);
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
