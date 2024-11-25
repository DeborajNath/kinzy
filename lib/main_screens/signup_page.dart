import 'dart:developer';
import 'package:authentication_firebase/components/primary_button.dart';
import 'package:authentication_firebase/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'login_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    // Check if the keyboard is visible by looking at the bottom padding of the view insets
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: cardBackgrround,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isKeyboardVisible ? 200 : 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: AssetImage("assets/todo.webp"), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  labelText: 'Full Name',
                  prefixIcon: Icon(
                    Icons.person,
                    color: black,
                  ),
                ),
                onChanged: (value) => loginProvider.validateEmail(value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  labelText: 'Email',
                  errorText:
                      loginProvider.isValidEmail ? null : "Invalid email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: black,
                  ),
                ),
                onChanged: (value) => loginProvider.validateEmail(value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: loginProvider.obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  labelText: 'Password',
                  errorText: loginProvider.isValidPassword
                      ? null
                      : "Password must be 8 characters",
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginProvider.obscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => loginProvider.toggleObscureText(),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: black,
                  ),
                ),
                onChanged: (value) => loginProvider.validatePassword(value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: loginProvider.obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: green),
                  ),
                  labelText: 'Confirm Password',
                  errorText: loginProvider.isConfirmedPassword
                      ? null
                      : "Passwords do not match",
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginProvider.obscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => loginProvider.toggleObscureText(),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: black,
                  ),
                ),
                onChanged: (value) => loginProvider.confirmPassword(
                  value,
                  _passwordController.text,
                ),
              ),
              const SizedBox(height: 16),
              GradientButton(
                onTap: loginProvider.canSignUp
                    ? () async {
                        final result = await loginProvider.signUp(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(result!)));
                        log("result is   $result");

                        if (result == "Signup Success") {
                          RoutingService.gotoWithoutBack(
                            context,
                            const LoginPage(),
                          );
                        }
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Please fill up all the details properly")));
                      },
                text: "Sign Up",
                enabled: loginProvider.canSignUp,
              ),
              TextButton(
                onPressed: () {
                  RoutingService.gotoWithoutBack(context, const LoginPage());
                },
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
