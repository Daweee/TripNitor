import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/providers/gas_provider.dart';
import 'package:tripnitor_mobile_app/providers/van_provider.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../../../models/gas_model.dart';
import '../van_admin_page.dart';

final dateBoughtProvider = StateProvider<DateTime?>((ref) => null);
final expiryDateProvider = StateProvider<DateTime?>((ref) => null);

class VanForm extends ConsumerStatefulWidget {
  const VanForm({Key? key}) : super(key: key);

  @override
  ConsumerState<VanForm> createState() => _VanFormState();
}

class _VanFormState extends ConsumerState<VanForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vanModelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _dateBoughtController = TextEditingController();
  final TextEditingController _registryExpiryDateController =
      TextEditingController();
  final TextEditingController _maxPassengerController = TextEditingController();
  final TextEditingController _gasIDController = TextEditingController();
  String? _selectedGasId;
  int _maxPassengers = 1;

  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _maxPassengerController.text =
        _maxPassengers.toString(); // Set default value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gasStateProvider.notifier).getAllGas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gasState = ref.watch(gasStateProvider);
    final List<Gas>? _gas = gasState.gasList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: _buildUI(_gas),
      ),
    );
  }

  Widget _buildUI(_gas) {
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
            _VanFormBody(_gas),
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

  Widget _VanFormBody(_gas) {
    final dateBought = ref.watch(dateBoughtProvider);
    final expiryDate = ref.watch(expiryDateProvider);
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
            InkWell(
              onTap: () => _selectDate(context, dateBoughtProvider),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date Bought',
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
                      dateBought == null
                          ? 'Select Date Bought'
                          : DateFormat('yyyy-MM-dd').format(dateBought),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Date of Expiration
            InkWell(
              onTap: () => _selectDate(context, expiryDateProvider),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Registration Expiration Date',
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
                      expiryDate == null
                          ? 'Registration expiry date'
                          : DateFormat('yyyy-MM-dd').format(expiryDate),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
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
  Future<void> _selectDate(
      BuildContext context, StateProvider<DateTime?> provider) async {
    final DateTime now = DateTime.now();
    final DateTime sixMonthsFromNow =
        DateTime(now.year, now.month + 6, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(provider) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: sixMonthsFromNow,
    );
    if (picked != null) {
      ref.read(provider.notifier).state = picked;
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

                final dateBought = ref.read(dateBoughtProvider);
                final expiryDate = ref.read(expiryDateProvider);

                // Format dates to string
                String? formattedDateBought;
                String? formattedExpiryDate;

                if (dateBought != null) {
                  formattedDateBought =
                      DateFormat('yyyy-MM-dd').format(dateBought);
                }
                if (expiryDate != null) {
                  formattedExpiryDate =
                      DateFormat('yyyy-MM-dd').format(expiryDate);
                }

                await vanStateNotifier.createVan(
                  _vanModelController.text.trim(),
                  _plateNumberController.text.trim(),
                  formattedDateBought!,
                  formattedExpiryDate!,
                  int.parse(_maxPassengerController.text.trim()),
                  _selectedGasId,
                );
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
