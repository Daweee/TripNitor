import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/constant.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';
import 'user/home_page.dart';

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
      backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 1),
        child: AppBar(
          title: Text(
            "Registration",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(ColorConstants.BACKGROUND_COLOR),
          elevation: 0,
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(
              color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.3),
              thickness: 1,
              height: 1,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _buildUI(context),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildFormHeader(),
            _buildRegistrationForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor:
                Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.1),
            child: Icon(
              Icons.person_add,
              size: 40,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Create New Account",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Please fill in the details to create your account",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Account Information"),
          SizedBox(height: 16),
          _buildFormField(
            controller: _usernameController,
            label: "Username",
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          _buildFormField(
            controller: _nameController,
            label: "Full Name",
            icon: Icons.badge,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                return 'Please enter a valid name (letters and spaces only)';
              }
              return null;
            },
          ),
          _buildFormField(
            controller: _emailController,
            label: "Email Address",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
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
          _buildFormField(
            controller: _phoneNumberController,
            label: "Phone Number",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
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
          SizedBox(height: 24),
          _buildSectionHeader("Security"),
          SizedBox(height: 16),
          _buildFormField(
            controller: _passwordController,
            label: "Password",
            icon: Icons.lock,
            obscureText: _isPasswordObscured,
            toggleObscureText: () {
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
          _buildFormField(
            controller: _confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock_outline,
            obscureText: _isConfirmPasswordObscured,
            toggleObscureText: () {
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
          SizedBox(height: 40),
          _buildRegistrationButton(),
          SizedBox(height: 30),
          _buildAlreadyHaveAccountLink(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(ColorConstants.PRIMARY_COLOR),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? toggleObscureText,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Color(ColorConstants.PRIMARY_COLOR),
          ),
          suffixIcon: obscureText && toggleObscureText != null
              ? IconButton(
                  icon: Icon(
                    _isPasswordObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: toggleObscureText,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.SECONDARY_COLOR),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(ColorConstants.PRIMARY_COLOR),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 16),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  Widget _buildRegistrationButton() {
    final authState = ref.watch(authProvider);

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(ColorConstants.PRIMARY_COLOR).withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(ColorConstants.PRIMARY_COLOR),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
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

              final updatedAuthState = ref.read(authProvider);

              if (updatedAuthState.error == null ||
                  updatedAuthState.error!.isEmpty) {
                await authNotifier.login(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                );

                final loginState = ref.read(authProvider);
                if (loginState.isAuthenticated) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  _showSnackBar('Registration successful. Please log in.');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                }
              } else {
                _showSnackBar(updatedAuthState.error ??
                    'Registration failed. Please try again.');
              }
            } catch (e) {
              _showSnackBar('An error occurred. Please try again.');
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.app_registration,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            message.contains('success') ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(15),
        duration: Duration(seconds: message.contains('success') ? 2 : 4),
      ),
    );
  }

  Widget _buildAlreadyHaveAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "Login",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(ColorConstants.PRIMARY_COLOR),
            ),
          ),
        ),
      ],
    );
  }
}
