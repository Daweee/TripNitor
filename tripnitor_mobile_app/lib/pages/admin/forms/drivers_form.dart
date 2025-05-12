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
  bool _isLoading = false;

  bool get _isEditMode => widget.driver != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(vanStateProvider.notifier).getAllUnassignedVans();

      if (_isEditMode && widget.driver != null) {
        _usernameController.text = widget.driver!.user.username;
        _nameController.text = widget.driver!.user.name;
        _emailController.text = widget.driver!.user.email;
        _phoneNumberController.text = widget.driver!.user.phoneNumber;
        _licenseNumberController.text = widget.driver!.licenseNumber;
        _selectedVanId = widget.driver!.van.id;

        ref.read(selectedDateProvider.notifier).state =
            widget.driver!.dateHired;
      } else {
        _selectedVanId = null;
      }
    } catch (e) {
      _showSnackBar('Failed to load data: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(15),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vanState = ref.watch(vanStateProvider);
    final List<Van>? vans = vanState.vanList;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            )
          : _buildFormContent(vans),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 1),
      child: AppBar(
        title: Text(
          _isEditMode ? 'Edit Driver' : 'Add Driver',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
            thickness: 1,
            height: 1,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Widget _buildFormContent(List<Van>? vans) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildFormHeader(),
            Expanded(
              child: _buildFormFields(vans),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor:
                Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
            child: Icon(
              _isEditMode ? Icons.edit_document : Icons.person_add,
              size: 40,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _isEditMode ? "Update Driver Information" : "Add New Driver",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _isEditMode
                ? "Edit the driver's details below"
                : "Fill in the details to add a new driver",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(List<Van>? vans) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Personal Information"),
            SizedBox(height: 16),
            if (!_isEditMode)
              _buildFormField(
                controller: _usernameController,
                label: "Username",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
            _buildFormField(
              controller: _nameController,
              label: "Full Name",
              icon: Icons.badge,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            if (!_isEditMode)
              _buildFormField(
                controller: _emailController,
                label: "Email Address",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            _buildFormField(
              controller: _phoneNumberController,
              label: "Phone Number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            if (!_isEditMode)
              _buildFormField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
            SizedBox(height: 24),
            _buildSectionHeader("Driver Details"),
            SizedBox(height: 16),
            _buildFormField(
              controller: _licenseNumberController,
              label: "License Number",
              icon: Icons.credit_card,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a license number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildDatePicker(selectedDate),
            SizedBox(height: 16),
            _buildVanDropdown(vans),
            SizedBox(height: 32),
            _buildSubmitButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(ColorConstants.PRIMARY_COLOR),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Color(ColorConstants.PRIMARY_COLOR),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.PRIMARY_COLOR),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 16),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  Widget _buildDatePicker(DateTime? selectedDate) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Color(ColorConstants.PRIMARY_COLOR),
                size: 24,
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Date Hired",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      selectedDate == null
                          ? 'Select Date'
                          : DateFormat('MMMM dd, yyyy').format(selectedDate),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: selectedDate == null
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVanDropdown(List<Van>? vans) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String?>(
        decoration: InputDecoration(
          labelText: "Assign Van",
          prefixIcon: Icon(
            Icons.airport_shuttle,
            color: Color(ColorConstants.PRIMARY_COLOR),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.PRIMARY_COLOR),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 16),
        value: vans?.any((van) => van.id == _selectedVanId) == true
            ? _selectedVanId
            : null,
        items: [
          DropdownMenuItem<String?>(
            value: null,
            child: Text(
              'Select a van',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          ...vans?.map<DropdownMenuItem<String>>((Van van) {
                return DropdownMenuItem<String>(
                  value: van.id,
                  child: Text(
                    '${van.model} | ${van.plateNumber}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isEditMode ? Icons.save : Icons.add_circle,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              _isEditMode ? 'Update Driver' : 'Add Driver',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime sixMonthsFromNow =
        DateTime(now.year, now.month + 6, now.day);
    final DateTime? picked = await _showCustomDatePicker(context);

    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  Future<DateTime?> _showCustomDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime sixMonthsFromNow =
        DateTime(now.year, now.month + 6, now.day);

    return showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: sixMonthsFromNow,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(ColorConstants.PRIMARY_COLOR),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: Container(
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

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

          final updatedDriver = await driverNotifier.updateDriver(
            widget.driver!.id,
            DriverPatch(
              user: user,
              licenseNumber: _licenseNumberController.text.trim(),
              dateHired: formattedDate,
              vanId: _selectedVanId,
            ),
          );

          _showSnackBar('Driver updated successfully');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DriverAdminProfile(driver: updatedDriver),
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

          _showSnackBar('Driver created successfully');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DriverAdminPage()),
          );
        }
      } catch (e) {
        _showSnackBar('An error occurred: ${e.toString()}', isError: true);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
