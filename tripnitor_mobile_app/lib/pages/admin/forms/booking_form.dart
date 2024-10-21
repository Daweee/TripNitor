import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

class DriversForm extends ConsumerStatefulWidget {
  const DriversForm({super.key});

  @override
  ConsumerState<DriversForm> createState() => _DriversFormState();
}

class _DriversFormState extends ConsumerState<DriversForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _dateHiredController = TextEditingController();
  //final TextEditingController _vanIDController = TextEditingController();

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
            _DriversFormBody(context),
          ],
        ),
      ),
    );
  }

  Widget _headerText(BuildContext context) {
    return Container(
      child: Text(
        "Add Driver",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _DriversFormBody(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Column(
          children: [
            CustomeFormField(
              labelText: "Username",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "name",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Email",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Email';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Phone Number",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _phoneNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Password",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the password';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "License number",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _licenseNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your License Number';
                }
                return null;
              },
            ),

            CustomeFormField(
              labelText: "Date Hired",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _dateHiredController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter when did the driver is hired';
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

            _addDriverButton(),
          ],
        ),
      ),
    );
  }

  Widget _addDriverButton() {
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
            'Add Driver',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
