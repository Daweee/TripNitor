import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/pages/registration_page.dart';
import 'package:tripnitor_mobile_app/widgets/custome_form_field.dart';

import '../constants/constant.dart';
import '../providers/auth_provider.dart';
import 'auth_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
<<<<<<<<< Temporary merge branch 1
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
=========

  var _isObscured;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isObscured = true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
<<<<<<<<< Temporary merge branch 1

  @override
  Widget build(BuildContext context) {

=========

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
>>>>>>>>> Temporary merge branch 2
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Container(
<<<<<<<<< Temporary merge branch 1
        color: Color(ColorConstants.BACKGROUND_COLOR),
=========
      color: Color(ColorConstants.BACKGROUND_COLOR),
>>>>>>>>> Temporary merge branch 2
      child: SafeArea(
        child: Column(
          children: [
            _header(),
            _loginForm(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .40,
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
    return Form(
<<<<<<<<< Temporary merge branch 1
      key: _formKey, 
=========
      key: _formKey,
>>>>>>>>> Temporary merge branch 2
      child: Container(
        width: MediaQuery.of(context).size.width * .75,
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * .05,
        ),
        height: MediaQuery.sizeOf(context).height * .35,
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
<<<<<<<<< Temporary merge branch 1
            CustomeFormField(
              labelText: "Password",
              height: MediaQuery.sizeOf(context).height * .1,
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              }
=========
            SizedBox(
              // Login password
              height: MediaQuery.sizeOf(context).height * .1,
              child: TextFormField(
                controller: _passwordController,
                obscureText: _isObscured, // false
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: _isObscured
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.black
                        .withOpacity(.5), // Change the label text color here
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
                ),
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
>>>>>>>>> Temporary merge branch 2
            ),
            // CustomeFormField(
            //   labelText: "Password",
            //   height: MediaQuery.sizeOf(context).height * .1,
            //   obscureText: true,
            //   controller: _passwordController,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a password';
            //     }
            //     return null;
            //   }
            // ),
            Container(
              padding: EdgeInsets.all(10),
              child: _loginButton(),
            ),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
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
                  final authNotifier = ref.read(authProvider.notifier);
                  await authNotifier.login(
                    _usernameController.text.trim(),
                    _passwordController.text.trim(),
                  );

<<<<<<<<< Temporary merge branch 1
                   if (ref.read(authProvider).isAuthenticated) {
                     Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => const AuthPage()),
                     );
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Login failed. Please try again.')),
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
                        'Login',
                        style: TextStyle(
                        color: Colors.white,
                        ),
=========
                  if (ref.read(authProvider).isAuthenticated) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Login failed. Please try again.')),
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
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
>>>>>>>>> Temporary merge branch 2
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
