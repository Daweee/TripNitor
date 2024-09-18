import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../../../models/gas_model.dart';
import '../../../providers/gas_provider.dart';
import '../gas_admin_page.dart';

class GasForm extends ConsumerStatefulWidget {
  const GasForm({super.key});

  @override
  ConsumerState<GasForm> createState() => _GasFormState();
}

class _GasFormState extends ConsumerState<GasForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gasNameController = TextEditingController();
  final TextEditingController _gasPriceController = TextEditingController();

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
            _GasFormBody(context),
          ],
        ),
      ),
    );
  }

  Widget _headerText(BuildContext context) {
    return Container(
      child: Text(
        "Enter Gas Details",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _GasFormBody(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomeFormField(
              labelText: "Type of Gas",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _gasNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the Gas Type';
                }
                return null;
              },
            ),
            CustomeFormField(
              labelText: "Gas Price ",
              height: MediaQuery.sizeOf(context).height * .1,
              keyboardType: TextInputType.number,
              controller: _gasPriceController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the Price of the Gas';
                }
                return null;
              },
            ),
            _addGasButton(),
          ],
        ),
      ),
    );
  }

  Widget _addGasButton() {
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
                final gasNotifier = ref.read(gasStateProvider.notifier);

                await gasNotifier.createGas(Gas(
                  gasName: _gasNameController.text.trim(),
                  gasPrice: _gasPriceController.text.trim(),
                ));

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GasAdminPage()),
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
            'Add Gas Details',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
