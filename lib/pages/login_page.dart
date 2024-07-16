import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_button.dart';
import 'package:food_delivery_app/components/my_textfield.dart';
import 'package:food_delivery_app/services/auth/auth_services.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Error messages
  String emailError = '';
  String passwordError = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Login method
  void login() async {
    setState(() {
      emailError =
          emailController.text.isEmpty ? 'Your email is required.' : '';
      passwordError =
          passwordController.text.isEmpty ? 'Your password is required.' : '';
    });

    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      return;
    }

    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      _showErrorDialog(
        "Login Failed",
        "Please check your email and password and try again.",
      );
    }
  }

  // Forgot password
  void forgotPw() async {
    final String email = emailController.text;
    if (email.isEmpty) {
      _showErrorDialog(
        "Email Required",
        "Please enter your email to reset your password.",
      );
      return;
    }

    final authService = AuthService();
    try {
      bool emailRegistered = await authService.isEmailRegistered(email);
      if (emailRegistered) {
        await authService.sendPasswordResetEmail(email);
        _showSuccessDialog("Success", "Password reset email sent.");
      } else {
        _showErrorDialog(
          "Email Not Found",
          "This email address is not registered. Please sign up.",
        );
      }
    } catch (e) {
      _showErrorDialog(
        "Failed to Send Email",
        "An error occurred while sending the password reset email. Please try again.",
      );
    }
  }

  // Show error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show success dialog
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const SizedBox(height: 1),
              _buildAppSlogan(),
              const SizedBox(height: 30),
              _buildEmailTextField(),
              if (emailError.isNotEmpty) _buildErrorText(emailError),
              const SizedBox(height: 15),
              _buildPasswordTextField(),
              if (passwordError.isNotEmpty) _buildErrorText(passwordError),
              const SizedBox(height: 15),
              _buildSignInButton(),
              const SizedBox(height: 30),
              _buildForgotPassword(),
              const SizedBox(height: 30),
              _buildRegisterNow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'lib/images/logo/Yum_Yum_Logo.PNG',
      height: 100,
    );
  }

  Widget _buildAppSlogan() {
    return Text(
      "QuickPlates Food Delivery",
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return MyTextField(
      controller: emailController,
      hintText: "Email",
      obscureText: false,
    );
  }

  Widget _buildPasswordTextField() {
    return MyTextField(
      controller: passwordController,
      hintText: "Password",
      obscureText: true,
    );
  }

  Widget _buildErrorText(String errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        errorText,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Widget _buildSignInButton() {
    return MyButton(
      text: "Sign In",
      onTap: login,
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: forgotPw,
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildRegisterNow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Not a member?",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            "Register now",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ],
    );
  }
}