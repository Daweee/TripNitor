import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripnitor_mobile_app/pages/registration_page.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Color backgroundColor = Colors.deepOrange; //0xE5842A 0xFFF2D9

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _header(),
          _loginForm(),
          //_registerAccountLink(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .40,
      //color: Colors.deepOrange,
      child: Center(
        child: Image(
          image: AssetImage(
            'assets/images/tripnitor_logo_rmbg.png',
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      width: MediaQuery.of(context).size.width * .75, // .75
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * .05, // .05
      ),
      height: MediaQuery.of(context).size.height * .35, // .1
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomeFormField(
              hintText: "Email",
              height: MediaQuery.sizeOf(context).height * .1,
            ),
            CustomeFormField(
              hintText: "Password",
              height: MediaQuery.sizeOf(context).height * .1,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: _loginButton(),
            ),
            Container(child: _registerAccountLink()),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * .05,
            child: MaterialButton(
              onPressed: () {},
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                'Login',
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

  Widget _registerAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Don\'t have an account? '),
          GestureDetector(
            onTap: () {
              // _navigationService
              //     .pushNamed("/register"); // navigate to register page
              //print('Button is being clicked');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ),
              );
            },
            child: const Text(
              " Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    );
  }
}
