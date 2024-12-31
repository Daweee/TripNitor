import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/constants/constant.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../widgets/custom_modal_dialogue.dart';
import 'home_page.dart';

class BookingDetailPage extends ConsumerWidget {
  const BookingDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingStateProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Booking Details',
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
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
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
      body: _buildBody(bookingState),
    );
  }
}

Widget _buildBody(bookingState) {
  if (bookingState.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  return BookingDetailsContent(booking: bookingState.booking!);
}

class BookingDetailsContent extends StatelessWidget {
  final Booking booking;

  const BookingDetailsContent({Key? key, required this.booking})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateTimeFormat = DateFormat('d MMM yyyy, h:mm a');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookingDetails(dateTimeFormat),
          _buildSection("User Info", [
            _buildInfoRow("Name", booking.user.name),
            _buildInfoRow("Phone Number", booking.user.phoneNumber),
            _buildInfoRow("Email", booking.user.email),
          ]),
          if (booking.drivers.isNotEmpty) _buildDriverSection(),
          _buildSection("Payment Summary", [
            _buildPaymentInfoRow("Base Fare", "₱${booking.baseFare}"),
            _buildPaymentInfoRow(
              "Package Fare",
              "₱${booking.updatedPackageFare}",
              icon: GestureDetector(
                onTap: () => _showFareInfoDialog(context),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withOpacity(.5),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.info,
                      color: Colors.black.withOpacity(.5),
                      size: 6.0,
                    ),
                  ),
                ),
              ),
            ),
            _buildPaymentInfoRow(
                "Duration Fee", "(${booking.numberOfNights}) ₱1000.00",
                boldPart: "(${booking.numberOfNights})"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Divider(
                color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.5),
                height: 1,
                thickness: 1,
              ),
            ),
            _buildPaymentInfoRow("Total Fare", "₱${booking.totalPrice}",
                isBold: true),
          ]),
          _buildSection("Payment Method", [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.moneyBill1),
                SizedBox(width: 10),
                Text(booking.modeOfPayment, style: TextStyle(fontSize: 16)),
              ],
            ),
          ]),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget _buildBookingDetails(DateFormat dateTimeFormat) {
    DateTime localCreatedAt = booking.createdAt.toLocal();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(ColorConstants.PRIMARY_COLOR),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.package.packageName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  _buildInfoRow("Booking ID:", booking.id, isWhite: true),
                  _buildInfoRow(
                    "Booked On:",
                    dateTimeFormat.format(localCreatedAt),
                    isWhite: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    "Start Date",
                    dateTimeFormat.format(booking.startDate),
                  ),
                  _buildInfoRow(
                    "End Date",
                    dateTimeFormat.format(booking.endDate),
                  ),
                  _buildInfoRow(
                    "No. of Passengers",
                    booking.numberOfPassengers.toString(),
                  ),
                  _buildStatusRow(
                    "Booking status:",
                    booking.status,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isWhite = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isWhite ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isWhite ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.PRIMARY_COLOR),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                height: 20,
                width: 5,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Driver/s",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${booking.drivers.length}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: " drivers assigned for this booking",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: booking.drivers.asMap().entries.map((entry) {
              final index = entry.key;
              final driver = entry.value;
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Driver ${index + 1} Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${driver.van.model} | ${driver.van.plateNumber}', // Replace with your desired text
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _buildInfoRow("Name", driver.user.name),
                      _buildInfoRow("Phone Number", driver.user.phoneNumber),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfoRow(String label, String value,
      {bool isBold = false, String? boldPart, Widget? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(label),
              if (icon != null) SizedBox(width: 4),
              if (icon != null) icon,
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (boldPart != null)
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: boldPart,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: value.substring(boldPart.length)),
                    ],
                  ),
                )
              else
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Color(ColorConstants.ACCENT_COLOR);
      case 'CONFIRMED':
        return Color(ColorConstants.PRIMARY_COLOR);
      case 'ONGOING':
        return Color(ColorConstants.SUCCESS_COLOR);
      case 'CANCELLED':
        return Color(ColorConstants.ERROR_COLOR);
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.PRIMARY_COLOR),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                height: 20,
                width: 5,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 5.0),
          child: Column(children: children),
        ),
      ],
    );
  }

  void _showFareInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModalDialog(
          title: 'Package Fare Information',
          content:
              'The package fare has been updated to include transportation costs, number of vans, the trip\'s distance.',
          onConfirm: () {},
          color: Color(ColorConstants.PRIMARY_COLOR),
        );
      },
    );
  }
}
