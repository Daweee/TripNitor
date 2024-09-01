import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';

class CustomeFormField extends StatelessWidget {
  final String labelText;
  final double height;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator; 

  const CustomeFormField({
    super.key,
    required this.labelText,
    required this.height,
    this.obscureText = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
                color: Colors.black.withOpacity(.5),// Change the label text color here
              ),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(ColorConstants.SECONDARY_COLOR),
                ),
            ),
          focusedBorder:  OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(ColorConstants.SECONDARY_COLOR),
                    width: 2.0,    
            ),
        ),
      ),
        validator: validator,
      ),
    );
  }
}