import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: _buildUI(context),
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
            padding: EdgeInsets.only(top: 30, bottom: 60,),
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
        "Geting Started",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _registrationForm(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomeFormField(
            hintText: "Full Name",
            height: MediaQuery.sizeOf(context).height * .1,
          ),
          CustomeFormField(
            hintText: "Email Adress",
            height: MediaQuery.sizeOf(context).height * .1,
          ),
          CustomeFormField(
            hintText: "Password",
            obscureText: true,
            height: MediaQuery.sizeOf(context).height * .1,
          ),
          CustomeFormField(
            hintText: "Confirm Password",
            height: MediaQuery.sizeOf(context).height * .1,
          ),
          _registrationButton(),
          // Text('Testing'),
          _AlreadyHaveAnAccount(),
        ],
      ),
    );
  }

  Widget _registrationButton() {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 50,
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
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
