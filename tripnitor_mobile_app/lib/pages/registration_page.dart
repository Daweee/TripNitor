// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../constants/constant.dart';
import '../constants/constant.dart';
import '../providers/auth_provider.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'login_page.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: _buildUI(context),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 60,
            ),
            child: _headerText(context),
          ),
          _registrationForm(context),
        ],
      ),
    );
  }

  Widget _headerText(BuildContext context) {
    return Container(
      child: Text(
        "Getting Started",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _registrationForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomeFormField(
              labelText: "Username",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            CustomeFormField(
              labelText: "Name",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Please enter a valid name (letters and spaces only!)';
                }
                return null;
              },
            ),
            CustomeFormField(
              labelText: "Email Address",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            CustomeFormField(
              labelText: "Phone Number",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _phoneNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^\d{11,}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            CustomeFormField(
              labelText: "Password",
              height: MediaQuery.sizeOf(context).height * .1,
              obscureText: _isPasswordObscured,
              controller: _passwordController,
              isPassword: true,
              onToggleObscureText: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            CustomeFormField(
              labelText: "Confirm Password",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _confirmPasswordController,
              obscureText: _isConfirmPasswordObscured,
              isPassword: true,
              onToggleObscureText: () {
                setState(() {
                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            _registrationButton(),
            SizedBox(
              height: 30,
            ),
            _AlreadyHaveAnAccount(),
          ],
        ),
      ),
    );
  }

  Widget _registrationButton() {
    final authState = ref.watch(authProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                offset: Offset(5, 5),
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * .06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final authNotifier = ref.read(authProvider.notifier);
                    await authNotifier.register(
                      _usernameController.text.trim(),
                      _nameController.text.trim(),
                      _emailController.text.trim(),
                      _phoneNumberController.text.trim(),
                      _passwordController.text.trim(),
                    );

                    // Check the authentication state after registration
                    final updatedAuthState = ref.read(authProvider);
                    print(
                        "Registration completed. isAuthenticated: ${updatedAuthState.isAuthenticated}");

                    if (updatedAuthState.error == null ||
                        updatedAuthState.error!.isEmpty) {
                      // Registration successful, attempt automatic login
                      await authNotifier.login(
                        _usernameController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      final loginState = ref.read(authProvider);
                      if (loginState.isAuthenticated) {
                        // Login successful, navigate to home page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage()), // Replace with your actual HomePage
                        );
                      } else {
                        // Login failed, show message and navigate to login page
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Registration successful. Please log in.')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage()), // Replace with your actual LoginPage
                        );
                      }
                    } else {
                      // Registration failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(updatedAuthState.error ??
                                'Registration failed. Please try again.')),
                      );
                    }
                  } catch (e) {
                    // Handle any exceptions
                    print("Error during registration or login: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('An error occurred. Please try again.')),
                    );
                  }
                }
              },
              child: authState.isLoading
                  ? Center(
                      child: SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3.0,
                        ),
                      ),
                    )
                  : Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _AlreadyHaveAnAccount() {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () {
            // navigate to register page
            Navigator.pop(context);
          },
          child: const Text(
            " Login ",
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
