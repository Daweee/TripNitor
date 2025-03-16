import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';
import 'package:tripnitor_mobile_app/providers/driver_provider.dart';
import 'package:tripnitor_mobile_app/providers/van_provider.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../../../models/auth_model.dart';
import '../driver_admin_page.dart';
import '../profile/driver_admin_profile.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

class DriversForm extends ConsumerStatefulWidget {
  final Driver? driver;

  DriversForm({Key? key, this.driver}) : super(key: key);

  @override
  ConsumerState<DriversForm> createState() => _DriversFormState();
}

class _DriversFormState extends ConsumerState<DriversForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  String? _selectedVanId;

  bool get _isEditMode => widget.driver != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vanStateProvider.notifier).getAllUnassignedVans();

      if (_isEditMode && widget.driver != null) {
        _usernameController.text = widget.driver!.user.username;
        _nameController.text = widget.driver!.user.name;
        _emailController.text = widget.driver!.user.email;
        _phoneNumberController.text = widget.driver!.user.phoneNumber;
        _licenseNumberController.text = widget.driver!.licenseNumber;
        _selectedVanId = widget.driver!.van.id;
        // Set the selected date if available
        ref.read(selectedDateProvider.notifier).state =
            widget.driver!.dateHired;
      } else {
        // Set _selectedVanId to null for new drivers
        _selectedVanId = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vanState = ref.watch(vanStateProvider);
    final List<Van>? _vans = vanState.vanList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: _buildUI(_vans),
      ),
    );
  }

  Widget _buildUI(_vans) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 40),
              child: _headerText(context),
            ),
            _DriversFormBody(_vans),
          ],
        ),
      ),
    );
  }

  Widget _headerText(BuildContext context) {
    return Container(
      child: Text(
        _isEditMode ? "Edit Driver" : "Add Driver",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _DriversFormBody(_vans) {
    final selectedDate = ref.watch(selectedDateProvider);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (!_isEditMode)
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
            if (!_isEditMode)
              CustomeFormField(
                labelText: "Email",
                height: MediaQuery.sizeOf(context).height * .1,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Email';
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
            if (!_isEditMode)
              CustomeFormField(
                labelText: "Password",
                height: MediaQuery.of(context).size.height * .1,
                controller: _passwordController,
                obscureText: true,
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

            SizedBox(height: 20),
            DropdownButtonFormField<String?>(
              decoration: InputDecoration(
                labelText: "Assign a van",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: _vans?.any((van) => van.id == _selectedVanId) == true
                  ? _selectedVanId
                  : null,
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Select a van'),
                ),
                ..._vans?.map<DropdownMenuItem<String>>((Van van) {
                      return DropdownMenuItem<String>(
                        value: van.id,
                        child: Text('${van.model} | ${van.plateNumber}'),
                      );
                    }).toList() ??
                    [],
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedVanId = newValue;
                });
              },
              validator: (value) {
                if (!_isEditMode && (value == null || value.isEmpty)) {
                  return 'Please select a van';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _addDriverButton(context, ref),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime sixMonthsFromNow =
        DateTime(now.year, now.month + 6, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: sixMonthsFromNow,
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                final driverNotifier = ref.read(driverStateProvider.notifier);

                final selectedDate = ref.read(selectedDateProvider);
                String? formattedDate;
                if (selectedDate != null) {
                  formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                }

                if (_isEditMode) {
                  final user = UserPatch(
                    name: _nameController.text.trim(),
                    phoneNumber: _phoneNumberController.text.trim(),
                  );

                  final updateDriver = await driverNotifier.updateDriver(
                    widget.driver!.id,
                    DriverPatch(
                      user: user,
                      licenseNumber: _licenseNumberController.text.trim(),
                      dateHired: formattedDate,
                      vanId: _selectedVanId,
                    ),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DriverAdminProfile(driver: updateDriver),
                    ),
                  );
                } else {
                  final createdDriver = await driverNotifier.createDriver(
                    _usernameController.text.trim(),
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                    _phoneNumberController.text.trim(),
                    _passwordController.text.trim(),
                    _licenseNumberController.text.trim(),
                    formattedDate,
                    _selectedVanId,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Driver created successfully')),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverAdminPage(),
                    ),
                  );
                }

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DriverAdminPage()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('An error occurred. Please try again.')),
                );
              }
            }
          },
          child: Text(
            _isEditMode ? 'Update Driver' : 'Add Driver',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
