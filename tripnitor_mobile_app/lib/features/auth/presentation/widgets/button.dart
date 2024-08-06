import 'package:flutter/material.dart';

class Button extends StatelessWidget {
    final Function()? onTap;

    const Button({super.key, required this.onTap});

    @override
    Widget build(BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;

        return GestureDetector(
            onTap: onTap,
            child: Container(
                width: screenWidth * 0.6,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Color(0XFFFC9963E),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(1),
                            offset: Offset(5, 5),
                            blurRadius: 10,
                        ),
                    ],
                ),
                child: Center(
                    child: Text('Login'),
                ),
            ),
        );
    }
}