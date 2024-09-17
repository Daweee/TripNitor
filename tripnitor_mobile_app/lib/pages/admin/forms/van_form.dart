import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

class VanForm extends ConsumerStatefulWidget {
  const VanForm({super.key});

  @override
  ConsumerState<VanForm> createState() => _VanFormState();
}

class _VanFormState extends ConsumerState<VanForm> {
  final TextEditingController _vanModelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _dateBoughtController = TextEditingController();
  final TextEditingController _registryExpiryDateController =
      TextEditingController();
  final TextEditingController _maxPassengerController = TextEditingController();
  final TextEditingController _gasIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: _buildUI(context),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.only(
                //top: 30,
                bottom: 40, // 60
              ),
              child: _headerText(context),
            ),
            _VanFormBody(context),
          ],
        ),
      ),
    );
  }

  Widget _headerText(BuildContext context) {
    return Container(
      child: Text(
        "Add Van",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _VanFormBody(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            CustomeFormField(
              labelText: "Model",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _vanModelController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Van Model';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Plate Number",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _plateNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the Plate Number';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Date of Purchase",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _dateBoughtController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Date of Purchase';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Registration Expiry Date",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _registryExpiryDateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Registration Expiration Date';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Max Passenger",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _maxPassengerController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Max Passenger';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Gas ID",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _gasIDController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Gas ID';
                }
                return null;
              },
            ),

            // CustomeFormField(
            //   labelText: "Van ID",
            //   height: MediaQuery.sizeOf(context).height * .1,
            //   controller: _dateHiredController,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter when did the driver is hired';
            //     }
            //     return null;
            //   },
            // ),

            _addVanButton(),
          ],
        ),
      ),
    );
  }

  Widget _addVanButton() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * .06,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
          ),
          onPressed: () {},
          child: Text(
            'Add Van',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
