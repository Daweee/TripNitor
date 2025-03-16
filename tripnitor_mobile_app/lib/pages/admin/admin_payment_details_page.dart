import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/constant.dart';
import '../../models/booking_model.dart';

class AdminPaymentDetailsPage extends StatefulWidget {
  Booking booking;

  AdminPaymentDetailsPage({super.key, required this.booking});

  @override
  State<AdminPaymentDetailsPage> createState() =>
      _AdminPaymentDetailsPageState();
}

class _AdminPaymentDetailsPageState extends State<AdminPaymentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            'Payment Details',
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
      child: Column(
        children: [
          _titleRow('Payment Breakdown'),
          _paymentDetailSection(),
          _titleRow('Payment Method'),
          _modeOfPaymentSection(),
        ],
      ),
    );
  }

  Widget _modeOfPaymentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _paymentRow(
        widget.booking.modeOfPayment,
        calcTotalPrice(widget.booking.baseFare,
            widget.booking.updatedPackageFare, widget.booking.numberOfNights),
        false,
      ),
    );
  }

  Widget _titleRow(String title) {
    return Container(
      height: 30,
      width: double.infinity,
      color: Color(ColorConstants.SECONDARY_COLOR),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentDetailSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _paymentRow('Base Fare', widget.booking.baseFare, false),
          _paymentRow('Package Fare', widget.booking.updatedPackageFare, false),
          _paymentRow(
              'Duration Fee', widget.booking.numberOfNights.toString(), true),
          Divider(),
          _paymentRow(
            'Total Price',
            calcTotalPrice(
                widget.booking.baseFare,
                widget.booking.updatedPackageFare,
                widget.booking.numberOfNights),
            false,
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  String calcTotalPrice(
      String baseFare, String updatedPackageFare, int durationFee) {
    double totalPrice = 0;

    totalPrice = double.parse(baseFare) +
        double.parse(updatedPackageFare) +
        (durationFee * 1000.00);

    return totalPrice.toStringAsFixed(2);
  }

  Widget _paymentRow(String label, String amount, bool isNumberOfNights) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
          ),
          isNumberOfNights
              ? Text(
                  "(${amount}) ₱1000.00",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  "₱${amount}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}
