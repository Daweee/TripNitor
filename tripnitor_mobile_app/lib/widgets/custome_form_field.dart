import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomeFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator; 

  const CustomeFormField({
    super.key,
    required this.hintText,
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
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }
}