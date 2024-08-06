import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
    final String labelText; 
    final controller;
    final bool obscureText;

    const InputField({
        super.key, 
        required this.controller,
        required this.labelText, 
        this.obscureText = false
    });

    @override
    Widget build(BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;

        return SizedBox(
            width: screenWidth * 0.8,
            child: TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFFE7C17E),
                        ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFFC9963E),
                            width: 2.0,    
                        ),
                    ),
                    labelText: labelText,
                ),
            ),
        );
    }
}