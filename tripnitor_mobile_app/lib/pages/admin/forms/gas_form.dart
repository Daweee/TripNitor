import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/gas_model.dart';
import 'package:tripnitor_mobile_app/providers/gas_provider.dart';
import 'package:tripnitor_mobile_app/pages/admin/profile/gas_admin_profile.dart';

class GasForm extends ConsumerStatefulWidget {
  final Gas? gas;
  const GasForm({super.key, this.gas});

  @override
  ConsumerState<GasForm> createState() => _GasFormState();
}

class _GasFormState extends ConsumerState<GasForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _gasNameController;
  late TextEditingController _gasPriceController;
  bool _isLoading = false;

  bool get _isEditMode => gas != null;
  Gas? get gas => widget.gas;

  @override
  void initState() {
    super.initState();
    _gasNameController = TextEditingController(text: gas?.gasName ?? '');
    _gasPriceController =
        TextEditingController(text: gas?.gasPrice.toString() ?? '');
  }

  @override
  void dispose() {
    _gasNameController.dispose();
    _gasPriceController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(ColorConstants.PRIMARY_COLOR),
              ),
            )
          : _buildFormContent(),
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
          _isEditMode ? 'Edit Gas' : 'Add Gas',
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

  Widget _buildFormContent() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _buildFormHeader(),
            Expanded(
              child: _buildFormFields(),
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
              _isEditMode ? Icons.edit_document : Icons.local_gas_station,
              size: 40,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _isEditMode ? "Update Gas Information" : "Add New Gas Type",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _isEditMode
                ? "Edit the gas details below"
                : "Fill in the details to add a new gas type",
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

  Widget _buildFormFields() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Gas Information"),
            SizedBox(height: 16),
            _buildFormField(
              controller: _gasNameController,
              label: "Gas Type",
              icon: Icons.local_gas_station,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a gas type';
                }
                return null;
              },
            ),
            _buildFormField(
              controller: _gasPriceController,
              label: "Price per Liter",
              icon: Icons.currency_exchange,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              prefix: '₱',
            ),
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
    String? prefix,
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
          prefixText: prefix,
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
              _isEditMode ? 'Update Gas Type' : 'Add Gas Type',
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final gasNotifier = ref.read(gasStateProvider.notifier);

        if (_isEditMode) {
          final patchGas = GasPatch(
            gasName: _gasNameController.text.trim(),
            gasPrice: _gasPriceController.text.trim(),
          );

          final updatedGas = await gasNotifier.updateGas(gas!.id, patchGas);

          _showSnackBar('Gas type updated successfully');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GasAdminProfile(gas: updatedGas),
            ),
          );
        } else {
          final createGas = Gas(
            gasName: _gasNameController.text.trim(),
            gasPrice: _gasPriceController.text.trim(),
          );

          final createdGas = await gasNotifier.createGas(createGas);

          _showSnackBar('Gas type created successfully');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GasAdminProfile(gas: createdGas),
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
