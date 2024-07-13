// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/auth/auth_services.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Focus nodes for text fields
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  // Error messages
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  // AuthService instance
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Add listeners to text fields
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    // Clean up controllers and listeners
    emailController.removeListener(_validateEmail);
    passwordController.removeListener(_validatePassword);
    confirmPasswordController.removeListener(_validatePasswords);
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      emailError = _isValidEmail(emailController.text)
          ? ''
          : 'Please enter a valid email address.';
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _validatePassword() {
    setState(() {
      passwordError = _isValidPassword(passwordController.text)
          ? ''
          : 'Please enter a strong password';
    });
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void _validatePasswords() {
    setState(() {
      confirmPasswordError =
          passwordController.text == confirmPasswordController.text
              ? ''
              : 'Passwords do not match.';
    });
  }

  void register() async {
    setState(() {
      emailError =
          emailController.text.isEmpty || !_isValidEmail(emailController.text)
              ? 'Please enter a valid email address.'
              : '';
      passwordError = passwordController.text.isEmpty ||
              !_isValidPassword(passwordController.text)
          ? 'Please enter a strong password'
          : '';
      confirmPasswordError = confirmPasswordController.text.isEmpty ||
              confirmPasswordController.text != passwordController.text
          ? 'Passwords do not match.'
          : '';
    });

    // Check if all fields are valid before attempting registration
    if (emailError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty) {
      // Check if email is already in use
      bool emailInUse =
          await _authService.isEmailAlreadyInUse(emailController.text);
      if (emailInUse) {
        _showErrorDialog(
          "Email Already Registered",
          "This email address is already registered. Please use a different email.",
        );
        return;
      }

      // Perform registration logic
      try {
        await _authService.signUpWithEmailPassword(
          emailController.text,
          passwordController.text,
        );
        // Registration successful, navigate to next screen or show success message
      } catch (e) {
        _showErrorDialog(
          /*"Registration Failed",
          "An error occurred while creating your account. Please try again.",
          */
          "Email Already Registered",
          "This email address is already registered. Please use a different email.",
        );
      }
    } else {
      // Scroll to the first error field
      _scrollToFirstErrorField();
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

  // Show password criteria dialog
  void _showPasswordCriteriaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Password Criteria"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("- Password must have 8 or more characters."),
            Text("- The first character must be an uppercase letter."),
            Text("- Password must contain at least one number."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Scroll to the first error field
  void _scrollToFirstErrorField() {
    if (emailError.isNotEmpty) {
      _scrollToField(emailFocusNode);
    } else if (passwordError.isNotEmpty) {
      _scrollToField(passwordFocusNode);
    } else if (confirmPasswordError.isNotEmpty) {
      _scrollToField(confirmPasswordFocusNode);
    }
  }

  // Helper method to scroll to a specific field
  void _scrollToField(FocusNode focusNode) {
    Scrollable.ensureVisible(
      focusNode.context!,
      alignment: 0.5,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/logo/Yum_Yum_Logo.PNG',
                  width: 100,
                  height: 100,
                ),
                // Logo

                /* 
                Icon(
                  Icons.lock_open_rounded,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),*/

                const SizedBox(height: 25),

                // Message, app slogan
                Text(
                  "Let's create an account for you",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 25),

                // Email text field
                MyTextField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  hintText: "Email",
                  obscureText: false,
                ),
                if (emailError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      emailError,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 10),

                // Password text field with criteria info
                Stack(
                  children: [
                    MyTextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      hintText: "Password",
                      obscureText: true,
                    ),
                    Positioned(
                      right: 10,
                      bottom: 12,
                      child: GestureDetector(
                        onTap: _showPasswordCriteriaDialog,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: const Text(
                            "!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (passwordError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        passwordError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // Confirm Password text field
                MyTextField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),
                if (confirmPasswordError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        confirmPasswordError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // Sign Up button
                MyButton(
                  text: "Sign Up",
                  onTap: register,
                ),

                const SizedBox(height: 25),

                // Already have an account? Login
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
