import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripnitor_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../injection_container.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';
import 'register_user_page.dart';

class LoginUserPage extends StatelessWidget {
    LoginUserPage({super.key});

    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    void _loginUser(BuildContext context) {
        final username = usernameController.text.trim();
        final password = passwordController.text.trim();

        // Access the AuthBloc and dispatch the LoginRequested event
        context.read<AuthBloc>().add(LoginRequested(username: username, password: password));
    }

    @override
        Widget build(BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double screenWidth = MediaQuery.of(context).size.width;
        // final double containerHeight = screenHeight / 3;    

        return Scaffold(
            backgroundColor: Color(0xFFFFF2D9),
            resizeToAvoidBottomInset: false,
            body: Column(
              children: <Widget>[
                  Container(
                      height: screenHeight * 0.4,
                      child: Placeholder(),
                  ),
                  Container(
                      height: screenHeight * 0.6,
                      width: screenWidth,
                      child: Column(
                        children: <Widget>[
                            Center(
                                child: InputField(labelText: 'Username', controller: usernameController, obscureText: false),
                            ),
                            SizedBox(height: 20),
                            Center(
                                child: InputField(labelText: 'Password', controller: passwordController, obscureText: true),
                            ),
                            SizedBox(height: 40),
                            Button(onTap: () => _loginUser(context)),
                            SizedBox(height: 60),
                            RichText(
                                text: TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                        TextSpan(
                                            text: 'Sign Up',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                            ..onTap = () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => RegisterUserPage()));}
                                        ),
                                ],
                            )),
                        ],
                      ),
                  ),
            
              ],
            ) 
        );
    }
}

