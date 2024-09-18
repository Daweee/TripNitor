import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

class DriversForm extends ConsumerStatefulWidget {
  DriversForm({Key? key})
      : super(key: key); // ({Key? key}) : super(key: key); / ({super.key});
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
  // final TextEditingController _dateHiredController = TextEditingController();
  // final TextEditingController _vanIDController = TextEditingController();

  String selectedDate = "";

  @override
  Widget build(BuildContext context) {
    // WidgetRef ref
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: _buildUI(context, ref),
      ),
    );
  }

  Widget _buildUI(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
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
    final selectedDate = ref.watch(selectedDateProvider);
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
              keyboardType: TextInputType.number,
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
            // Date of purchase
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date Hired',
                  fillColor: Color(ColorConstants.SECONDARY_COLOR),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(ColorConstants.SECONDARY_COLOR),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd').format(selectedDate),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            // CustomeFormField(
            //   labelText: "Date Hired",
            //   height: MediaQuery.sizeOf(context).height * .1,
            //   controller: _dateHiredController,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter when did the driver is hired';
            //     }
            //     return null;
            //   },
            // ),

            _addDriverButton(context, ref),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  Widget _addDriverButton(BuildContext context, WidgetRef ref) {
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
