import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomeFormField extends StatelessWidget {
  final String hintText;
  final double height;
  //final RegExp validationRegEx; // regex
  final bool obscureText;
  final TextEditingController controller;

  const CustomeFormField({
    super.key,
    required this.hintText,
    required this.height,
    //required this.validationRegEx,
    this.obscureText = false,
    required this.controller,
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
          border: OutlineInputBorder()
        ),

      ),
      
    );
  }
}
