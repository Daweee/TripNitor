import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants/constant.dart';
import 'package_start_final_location.dart';

class PackageDetailsCreationPage extends StatefulWidget {
  final packageType;
  final packageVisibility;

  const PackageDetailsCreationPage(
      {super.key, required this.packageType, required this.packageVisibility});

  @override
  State<PackageDetailsCreationPage> createState() =>
      _PackageDetailsCreationPageState();
}

class _PackageDetailsCreationPageState
    extends State<PackageDetailsCreationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final int _maxCharacters = 400;
  int _currentCharacters = 0;

  String? _nameError;
  String? _descriptionError;
  bool _isFormSubmitted = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_updateCharacterCount);
    _nameController.addListener(_validateName);
    _descriptionController.addListener(_validateDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _currentCharacters = _descriptionController.text.length;
    });
  }

  bool _hasInvalidSymbols(String text) {
    return !RegExp(r"^[a-zA-Z0-9 ']+$").hasMatch(text);
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isEmpty) {
        _nameError = 'Package name is required';
      } else if (_hasInvalidSymbols(_nameController.text)) {
        _nameError = 'Symbols are not allowed';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateDescription() {
    setState(() {
      if (_descriptionController.text.isEmpty) {
        _descriptionError = 'Package description is required';
      } else if (_hasInvalidSymbols(_descriptionController.text)) {
        _descriptionError =
            'Only letters, numbers, spaces, and apostrophes are allowed';
      } else if (_descriptionController.text.length > _maxCharacters) {
        _descriptionError =
            'Description cannot exceed $_maxCharacters characters';
      } else {
        _descriptionError = null;
      }
    });
  }

  void _validateForm() {
    setState(() {
      _isFormSubmitted = true;
      _validateName();
      _validateDescription();
    });

    if (_nameError == null && _descriptionError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackageStartFinalLocation(
            packageType: widget.packageType,
            packageVisibility: widget.packageVisibility,
            packageName: _nameController.text.trim(),
            packageDescription: _descriptionController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            '${widget.packageType} • ${widget.packageVisibility}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
              size: 20.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleRow('Package Name'),
              SizedBox(height: 10),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter package name',
                error: _isFormSubmitted ? _nameError : null,
              ),
              if (_isFormSubmitted && _nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _nameError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              SizedBox(height: 25),
              _titleRow('Package Description'),
              SizedBox(height: 10),
              _buildDescriptionField(),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isFormSubmitted && _descriptionError != null)
                    Expanded(
                      child: Text(
                        _descriptionError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  _buildCharacterCounter(),
                ],
              ),
              SizedBox(height: 30),
              _confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? error,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: error != null ? Colors.red : Colors.transparent,
          width: error != null ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isFormSubmitted && _descriptionError != null
              ? Colors.red
              : Colors.transparent,
          width: _isFormSubmitted && _descriptionError != null ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 5,
        maxLength: _maxCharacters,
        decoration: InputDecoration(
          hintText: 'Enter package description',
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }

  Widget _buildCharacterCounter() {
    return Text(
      '$_currentCharacters/$_maxCharacters characters',
      style: TextStyle(
        color: _currentCharacters > _maxCharacters ? Colors.red : Colors.grey,
        fontSize: 12,
      ),
    );
  }

  Widget _titleRow(String title) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(ColorConstants.PRIMARY_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: 20,
          width: 5,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _confirmButton() {
    return Container(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _validateForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Text(
          'Proceed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
