import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/auth_model.dart';
import 'package:tripnitor_mobile_app/pages/booking_detail_page.dart';
import '../models/booking_model.dart';
import '../models/package_model.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';

class PaymentBookingPage extends ConsumerStatefulWidget {
  final String packageId;

  const PaymentBookingPage({Key? key, required this.packageId})
      : super(key: key);

  @override
  ConsumerState<PaymentBookingPage> createState() => _PaymentBookingPageState();
}

class _PaymentBookingPageState extends ConsumerState<PaymentBookingPage> {
  String _selectedPaymentMethod = 'CASH';

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final authState = ref.watch(authProvider);
    final DateFormat dateTimeFormat = DateFormat('MMM d, yyyy h:mm a');

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Booking Confirmation',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
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
      body: bookingState.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookingState.previewBooking!.package,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text: 'Start Date: ',
                                style: TextStyle(fontWeight: FontWeight.normal),
                                children: [
                                  TextSpan(
                                    text: '    ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  TextSpan(
                                    text: dateTimeFormat.format(
                                        bookingState.previewBooking!.startDate),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                text: 'End Date: ',
                                style: TextStyle(fontWeight: FontWeight.normal),
                                children: [
                                  TextSpan(
                                    text: '    ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  TextSpan(
                                    text: dateTimeFormat.format(
                                        bookingState.previewBooking!.endDate),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                text: 'Number of Passengers: ',
                                style: TextStyle(fontWeight: FontWeight.normal),
                                children: [
                                  TextSpan(
                                    text: '    ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  TextSpan(
                                    text: bookingState
                                        .previewBooking!.numberOfPassengers
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
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
                          "User Info",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 5.0),
                    child: Column(
                      children: [
                        _buildUserInfoRow(
                            "Name", authState.user?.name ?? "N/A"),
                        SizedBox(height: 8),
                        _buildUserInfoRow("Phone Number",
                            authState.user?.phoneNumber ?? "N/A"),
                        SizedBox(height: 8),
                        _buildUserInfoRow(
                            "Email", authState.user?.email ?? "N/A"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.PRIMARY_COLOR),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                                          text:
                                              "${bookingState.previewBooking!.assignedDrivers.length}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " drivers will be assigned for this booking",
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: bookingState.previewBooking!.assignedDrivers
                          .asMap()
                          .entries
                          .map((entry) {
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
                                Text(
                                  'Driver ${index + 1} Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                _buildDriverInfoRow("Name", driver.name),
                                _buildDriverInfoRow(
                                    "Phone Number", driver.phoneNumber),
                                _buildDriverInfoRow(
                                    "Van Model", driver.vanModel),
                                _buildDriverInfoRow(
                                    "Plate Number", driver.vanPlateNumber),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
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
                          "Payment Summary",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 5.0),
                    child: Column(
                      children: [
                        _buildPaymentInfoRow("Base Fare",
                            "₱${bookingState.previewBooking!.baseFare.toStringAsFixed(2)}"),
                        _buildPaymentInfoRow("Package Fare",
                            "₱${bookingState.previewBooking!.basePackagePrice.toStringAsFixed(2)}"),
                        _buildPaymentInfoRow("Booking Duration",
                            "${bookingState.previewBooking!.numberOfNights} nights x ₱1000.00"),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          child: Divider(
                            color: Color(ColorConstants.PRIMARY_COLOR)
                                .withOpacity(.5),
                            height: 1,
                            thickness: 1,
                          ),
                        ),
                        _buildPaymentInfoRow("Total Price",
                            "₱${bookingState.previewBooking!.totalPrice.toStringAsFixed(2)}",
                            isBold: true),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
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
                          "Payment Methods",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            FaIcon(FontAwesomeIcons.moneyBill1),
                            SizedBox(width: 10),
                            Text('Cash', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Radio<String>(
                          value: 'CASH',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                          activeColor: Colors.grey[800],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final driverIds = bookingState
                              .previewBooking!.assignedDrivers
                              .map((driver) => driver.id)
                              .toList();

                          final booking = BookingCreationRequest(
                            user: authState.user!.id,
                            package: widget.packageId,
                            assigned_drivers: driverIds,
                            numberOfPassengers:
                                bookingState.previewBooking!.numberOfPassengers,
                            modeOfPayment: _selectedPaymentMethod,
                            startDate: bookingState.previewBooking!.startDate,
                            endDate: bookingState.previewBooking!.endDate,
                          );

                          ref
                              .read(bookingStateProvider.notifier)
                              .createBooking(booking);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
          ),
        ),
        SizedBox(width: 50),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfoRow(String label, String value,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
          ),
        ),
        SizedBox(width: 50),
        Text(
          value,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
