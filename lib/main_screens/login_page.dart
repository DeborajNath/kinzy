import 'dart:developer';
import 'package:authentication_firebase/components/primary_button.dart';
import 'package:authentication_firebase/constants/index.dart';
import 'package:authentication_firebase/main_screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _forgotPasswordController =
      TextEditingController();

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Forgot Password?'),
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.cancel),
              ),
            ],
          ),
          content: TextField(
            controller: _forgotPasswordController,
            decoration: const InputDecoration(
              labelText: 'Enter your email',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            GradientButton(
              onTap: () {
                LoginProvider()
                    .sendPasswordResetEmail(_forgotPasswordController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Password reset link sent to ${_forgotPasswordController.text}')),
                );
              },
              text: 'Send',
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: cardBackgrround,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                height: 50,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
                  errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: red)),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
                  disabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
                  labelText: 'Email',
                  errorText:
                      loginProvider.isValidEmail ? null : "Invalid email",
                  prefixIcon: Icon(
                    Icons.person,
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
                  border:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
                  errorBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: red)),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
                  disabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: green)),
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
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _showForgotPasswordDialog(context),
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GradientButton(
                onTap: () async {
                  final result = await loginProvider.signIn(
                    _emailController.text,
                    _passwordController.text,
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(result!)));
                  log("result is   $result");
                  if (result == "Login Success") {
                    RoutingService.gotoWithoutBack(context, const Homepage());
                  }
                },
                text: 'Login',
              ),
              TextButton(
                onPressed: () {
                  RoutingService.gotoWithoutBack(context, const SignupScreen());
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
