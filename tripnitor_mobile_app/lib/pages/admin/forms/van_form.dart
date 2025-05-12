import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/gas_model.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';
import 'package:tripnitor_mobile_app/providers/gas_provider.dart';
import 'package:tripnitor_mobile_app/providers/van_provider.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../profile/van_admin_profile.dart';
import '../van_admin_page.dart';

// Create a state provider for date selection, similar to the drivers form
final vanDateProvider = StateProvider<DateTime?>((ref) => null);
final vanExpiryDateProvider = StateProvider<DateTime?>((ref) => null);

class VanForm extends ConsumerStatefulWidget {
  final Van? van;
  final bool isEditMode;
  const VanForm({Key? key, this.van, required this.isEditMode})
      : super(key: key);

  @override
  ConsumerState<VanForm> createState() => _VanFormState();
}

class _VanFormState extends ConsumerState<VanForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vanModelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _maxPassengerController = TextEditingController();
  String? _selectedGasId;
  int _maxPassengers = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _maxPassengerController.text = _maxPassengers.toString();

    if (widget.isEditMode && widget.van != null) {
      _vanModelController.text = widget.van!.model;
      _plateNumberController.text = widget.van!.plateNumber;
      _maxPassengerController.text = widget.van!.maxPassengers.toString();
      _selectedGasId = widget.van!.gas?.id;
      _maxPassengers = widget.van!.maxPassengers;

      // Initialize dates with the existing values
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(vanDateProvider.notifier).state = widget.van!.dateBought;
        ref.read(vanExpiryDateProvider.notifier).state =
            widget.van!.registrationExpiryDate;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(gasStateProvider.notifier).getAllGas();
    } catch (e) {
      _showSnackBar('Failed to load gas types: ${e.toString()}', isError: true);
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
    final gasState = ref.watch(gasStateProvider);
    final List<Gas>? gasList = gasState.gasList;

    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            )
          : _buildFormContent(gasList),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 1),
      child: AppBar(
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isEditMode ? 'Edit Van' : 'Add Van',
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
      ),
    );
  }

  Widget _buildFormContent(List<Gas>? gasList) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildFormHeader(),
            Expanded(
              child: _buildFormFields(gasList),
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
              widget.isEditMode
                  ? Icons.edit_document
                  : Icons.directions_car_filled,
              size: 40,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 16),
          Text(
            widget.isEditMode ? "Update Van Information" : "Add New Van",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.isEditMode
                ? "Edit the van's details below"
                : "Fill in the details to add a new van",
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

  Widget _buildFormFields(List<Gas>? gasList) {
    final purchaseDate = ref.watch(vanDateProvider);
    final expiryDate = ref.watch(vanExpiryDateProvider);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Van Information"),
            SizedBox(height: 16),
            _buildFormField(
              controller: _vanModelController,
              label: "Van Model",
              icon: Icons.directions_car,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter van model';
                }
                return null;
              },
            ),
            _buildFormField(
              controller: _plateNumberController,
              label: "Plate Number",
              icon: Icons.numbers,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter plate number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildDatePicker(
              purchaseDate,
              "Date of Purchase",
              vanDateProvider,
            ),
            SizedBox(height: 16),
            _buildDatePicker(
              expiryDate,
              "Registration Expiry Date",
              vanExpiryDateProvider,
            ),
            SizedBox(height: 24),
            _buildSectionHeader("Capacity & Fuel"),
            SizedBox(height: 16),
            _buildMaxPassengerCounter(),
            SizedBox(height: 16),
            _buildGasDropdown(gasList),
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

  Widget _buildDatePicker(
    DateTime? selectedDate,
    String label,
    StateProvider<DateTime?> dateProvider,
  ) {
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
        onTap: () => _selectDate(context, dateProvider),
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
                      label,
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

  Widget _buildMaxPassengerCounter() {
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              Icons.airline_seat_recline_normal,
              color: Color(ColorConstants.PRIMARY_COLOR),
              size: 24,
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Maximum Passengers",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "$_maxPassengers ${_maxPassengers == 1 ? 'passenger' : 'passengers'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.remove,
                      color: Color(ColorConstants.PRIMARY_COLOR),
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_maxPassengers > 1) {
                        _maxPassengers--;
                        _maxPassengerController.text =
                            _maxPassengers.toString();
                      }
                    });
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.add,
                      color: Color(ColorConstants.PRIMARY_COLOR),
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_maxPassengers < 15) {
                        _maxPassengers++;
                        _maxPassengerController.text =
                            _maxPassengers.toString();
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGasDropdown(List<Gas>? gasList) {
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
      child: DropdownButtonFormField<Gas>(
        decoration: InputDecoration(
          labelText: "Gas Type",
          prefixIcon: Icon(
            Icons.local_gas_station,
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
        value: _selectedGasId != null
            ? gasList?.firstWhere((gas) => gas.id == _selectedGasId,
                orElse: () => gasList.first)
            : null,
        items: gasList?.map<DropdownMenuItem<Gas>>((Gas gas) {
              final bool isCurrentGas =
                  widget.isEditMode && gas.id == widget.van?.gas?.id;

              return DropdownMenuItem<Gas>(
                value: gas,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${gas.gasName} | ₱${gas.gasPrice}',
                        style: TextStyle(
                          color: isCurrentGas
                              ? Color(ColorConstants.PRIMARY_COLOR)
                              : Colors.black87,
                          fontWeight: isCurrentGas
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentGas)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.PRIMARY_COLOR)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(ColorConstants.PRIMARY_COLOR),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList() ??
            [],
        onChanged: (Gas? newValue) {
          setState(() {
            _selectedGasId = newValue?.id;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a gas type';
          }
          return null;
        },
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        isExpanded: true,
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
              widget.isEditMode ? Icons.save : Icons.add_circle,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              widget.isEditMode ? 'Update Van' : 'Add Van',
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

  Future<void> _selectDate(
      BuildContext context, StateProvider<DateTime?> dateProvider) async {
    final DateTime? picked = await _showCustomDatePicker(
      context,
      ref.read(dateProvider),
    );

    if (picked != null) {
      ref.read(dateProvider.notifier).state = picked;
    }
  }

  Future<DateTime?> _showCustomDatePicker(
      BuildContext context, DateTime? initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
      final purchaseDate = ref.read(vanDateProvider);
      final expiryDate = ref.read(vanExpiryDateProvider);

      if (purchaseDate == null || expiryDate == null) {
        _showSnackBar('Please select both purchase and expiry dates',
            isError: true);
        return;
      }

      setState(() => _isLoading = true);

      try {
        final vanStateNotifier = ref.read(vanStateProvider.notifier);

        final van = VanPatch(
          model: _vanModelController.text.trim(),
          plateNumber: _plateNumberController.text.trim(),
          dateBought: purchaseDate,
          registrationExpiryDate: expiryDate,
          maxPassengers: _maxPassengers,
          gasId: _selectedGasId,
        );

        if (widget.isEditMode) {
          final updatedVan =
              await vanStateNotifier.updateVan(widget.van!.id, van);
          _showSnackBar('Van updated successfully');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VanAdminProfile(van: updatedVan),
            ),
          );
        } else {
          final createdVan = await vanStateNotifier.createVan(van);
          _showSnackBar('Van created successfully');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VanAdminProfile(van: createdVan),
            ),
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
