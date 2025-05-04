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
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  String? _nameError;
  String? _descriptionError;
  String? _dateTimeError;
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

  void _validateDates() {
    setState(() {
      if (widget.packageVisibility == 'PUBLIC') {
        if (_startDateTime == null || _endDateTime == null) {
          _dateTimeError =
              'Both start and end dates are required for public packages';
        } else if (_startDateTime!.isAfter(_endDateTime!)) {
          _dateTimeError = 'Start date must be before end date';
        } else {
          _dateTimeError = null;
        }
      }
    });
  }

  void _validateForm() {
    setState(() {
      _isFormSubmitted = true;
      _validateName();
      _validateDescription();
      if (widget.packageVisibility == 'PUBLIC') {
        _validateDates();
      }
    });

    bool isValid = _nameError == null && _descriptionError == null;
    if (widget.packageVisibility == 'PUBLIC') {
      isValid = isValid &&
          _dateTimeError == null &&
          _startDateTime != null &&
          _endDateTime != null;
    }

    if (isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PackageStartFinalLocation(
            packageType: widget.packageType,
            packageVisibility: widget.packageVisibility,
            packageName: _nameController.text.trim(),
            packageDescription: _descriptionController.text.trim(),
            startDate:
                widget.packageVisibility == 'PUBLIC' ? _startDateTime : null,
            endDate: widget.packageVisibility == 'PUBLIC' ? _endDateTime : null,
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
              if (widget.packageVisibility == 'PUBLIC') ...[
                SizedBox(height: 25),
                _titleRow('Set Dates'),
                SizedBox(height: 10),
                _buildShadowedContainer([
                  _buildSection('Start Date and Time', [
                    _buildDateTimeRow(_startDateTime, (dateTime) {
                      setState(() => _startDateTime = dateTime);
                    }),
                  ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(
                      color:
                          Color(ColorConstants.PRIMARY_COLOR).withOpacity(.3),
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  _buildSection('End Date and Time', [
                    _buildDateTimeRow(_endDateTime, (dateTime) {
                      setState(() => _endDateTime = dateTime);
                    }),
                  ]),
                ]),
                if (_isFormSubmitted && _dateTimeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _dateTimeError!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                SizedBox(height: 25),
                _titleRow('Passenger Capacity'),
                SizedBox(height: 10),
                _buildShadowedContainer([
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(ColorConstants.PRIMARY_COLOR),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This tour package has a maximum capacity of 15 passengers only',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
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

  Widget _buildShadowedContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildDateTimeRow(DateTime? dateTime, Function(DateTime) onPick) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateTime != null ? '${dateTime.toLocal()}'.split('.')[0] : 'Not set',
          style: TextStyle(fontSize: 14),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today,
              color: Color(ColorConstants.ACCENT_COLOR)),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: dateTime ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Color(ColorConstants.PRIMARY_COLOR),
                      onPrimary: Color(ColorConstants.TERTIARY_COLOR),
                      surface: Color(ColorConstants.BACKGROUND_COLOR),
                      onSurface:
                          Color(ColorConstants.BOTTOM_PACKAGE_CARD_COLOR),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Color(ColorConstants.PRIMARY_COLOR),
                        onPrimary: Color(ColorConstants.TERTIARY_COLOR),
                        surface: Color(ColorConstants.BACKGROUND_COLOR),
                        onSurface:
                            Color(ColorConstants.BOTTOM_PACKAGE_CARD_COLOR),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (time != null) {
                onPick(DateTime(
                    date.year, date.month, date.day, time.hour, time.minute));
              }
            }
          },
        ),
      ],
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
