// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../providers/auth_provider.dart';
import 'auth_page.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //appBar: AppBar(),
      body: authState.isLoading
          ? Center(child: CircularProgressIndicator()) 
          : Container(
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
              hintText: "Username",
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
              hintText: "Name",
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return 'Please enter a valid name (letters only!)';
                }
                return null;
              },
            ),
            CustomeFormField(
              hintText: "Email Address",
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
              hintText: "Phone Number",
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
              hintText: "Password",
              obscureText: true,
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _passwordController,
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
              hintText: "Confirm Password",
              obscureText: true,
              height: MediaQuery.sizeOf(context).height * .1,
              controller: _confirmPasswordController,
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
            _AlreadyHaveAnAccount(),
          ],
        ),
      ),
    );
  }

  Widget _registrationButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 30),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 60,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final authNotifier = ref.read(authProvider.notifier);
              await authNotifier.register(
                _usernameController.text.trim(),
                _nameController.text.trim(),
                _emailController.text.trim(),
                _phoneNumberController.text.trim(),
                _passwordController.text.trim(),
              );

              final authState = ref.read(authProvider);

              if (authState.isAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registration failed. Please try again.')),
                );
              }
            }
          },
          child: Text('Register'),
        ),
      ),
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
