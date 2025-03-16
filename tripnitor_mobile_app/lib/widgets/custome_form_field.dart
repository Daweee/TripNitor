import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';

class CustomeFormField extends StatelessWidget {
  final String labelText;
  final double height;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onToggleObscureText;
  final bool isPassword;
  final TextInputType? keyboardType;

  const CustomeFormField({
    super.key,
    required this.labelText,
    required this.height,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.onToggleObscureText,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.black.withOpacity(.5),
          ),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 2.0,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black.withOpacity(.5),
                  ),
                  onPressed: onToggleObscureText,
                )
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
