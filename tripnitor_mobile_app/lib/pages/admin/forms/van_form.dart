import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/providers/gas_provider.dart';
import 'package:tripnitor_mobile_app/providers/van_provider.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../../../models/gas_model.dart';
import '../../../models/van_model.dart';
import '../profile/van_admin_profile.dart';
import '../van_admin_page.dart';

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
  late TextEditingController _vanModelController = TextEditingController();
  late TextEditingController _plateNumberController = TextEditingController();
  late TextEditingController _dateBoughtController = TextEditingController();
  late TextEditingController _registryExpiryDateController =
      TextEditingController();
  late TextEditingController _maxPassengerController = TextEditingController();
  late TextEditingController _gasIDController = TextEditingController();
  String? _selectedGasId;
  int _maxPassengers = 1;

  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _maxPassengerController.text = _maxPassengers.toString();

    if (widget.isEditMode && widget.van != null) {
      _vanModelController.text = widget.van!.model;
      _plateNumberController.text = widget.van!.plateNumber;

      // Set the date fields with formatted date strings
      _dateBoughtController.text =
          widget.van!.dateBought.toIso8601String().split("T")[0]; // YYYY-MM-DD
      _registryExpiryDateController.text = widget.van!.registrationExpiryDate
          .toIso8601String()
          .split("T")[0]; // YYYY-MM-DD

      _maxPassengerController.text = widget.van!.maxPassengers.toString();
      _selectedGasId = widget.van!.gas?.id;
      _maxPassengers = widget.van!.maxPassengers;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gasStateProvider.notifier).getAllGas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
        title: Text(widget.isEditMode ? "Edit Van" : "Add Van"),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
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
            _VanFormBody(),
          ],
        ),
      ),
    );
  }

  Widget _headerText(BuildContext context) {
    return Container(
      child: Text(
        widget.isEditMode ? "Edit Van" : "Add Van",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _VanFormBody() {
    final gasState = ref.watch(gasStateProvider);
    final List<Gas>? _gas = gasState.gasList;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
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

            // Date of Purchase
            TextField(
              controller: _dateBoughtController,
              decoration: InputDecoration(
                labelText: "Date of Purchase",
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(_dateBoughtController);
              },
            ),
            SizedBox(height: 12),
            // Date of Expiration
            TextField(
              controller: _registryExpiryDateController,
              decoration: InputDecoration(
                labelText: "Date of Expiration",
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(_registryExpiryDateController);
              },
            ),
            SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Set border color
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              padding: EdgeInsets.all(12), // Padding inside the container
              margin: EdgeInsets.symmetric(
                  vertical: 12), // Margin around the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Max Passenger:"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
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
                      Container(
                        width: 40,
                        child: Text(
                          _maxPassengers.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
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

            DropdownButtonFormField<Gas>(
              decoration: InputDecoration(
                labelText: "Gas Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: _selectedGasId != null
                  ? _gas?.firstWhere((gas) => gas.id == _selectedGasId,
                      orElse: () => _gas.first)
                  : null, // Set initial value,
              items: _gas?.map<DropdownMenuItem<Gas>>((Gas gas) {
                return DropdownMenuItem<Gas>(
                  value: gas,
                  child: Text('${gas.gasName} | ₱${gas.gasPrice}'),
                );
              }).toList(),
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
            ),

            _addVanButton(context, ref),
          ],
        ),
      ),
    );
  }

  // calendar
  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        controller.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Widget _addVanButton(BuildContext context, WidgetRef ref) {
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
                final vanStateNotifier = ref.read(vanStateProvider.notifier);

                final van = VanPatch(
                  model: _vanModelController.text.trim(),
                  plateNumber: _plateNumberController.text.trim(),
                  dateBought:
                      DateTime.tryParse(_dateBoughtController.text.trim()) ??
                          DateTime.now(),
                  registrationExpiryDate: DateTime.tryParse(
                          _registryExpiryDateController.text.trim()) ??
                      DateTime.now(),
                  maxPassengers: int.parse(_maxPassengerController.text.trim()),
                  gasId: _selectedGasId,
                );

                if (widget.isEditMode) {
                  final updatedVan =
                      await vanStateNotifier.updateVan(widget.van!.id, van);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VanAdminProfile(van: updatedVan),
                    ),
                  );
                } else {
                  final createdVan = await vanStateNotifier.createVan(van);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VanAdminProfile(van: createdVan),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('An error occurred. Please try again.')),
                );
              }

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => VanAdminPage()),
              );
            }
          },
          child: Text(
            widget.isEditMode ? 'Update Van' : 'Add Van',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
