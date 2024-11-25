import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _obscureText = true;
  bool _isValidEmail = true;
  bool _isValidPassword = true;
  bool _isConfirmedPassword = false;

  bool get obscureText => _obscureText;
  bool get isValidEmail => _isValidEmail;
  bool get isValidPassword => _isValidPassword;
  bool get isConfirmedPassword => _isConfirmedPassword;

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Toggle password visibility
  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  // Validate email
  void validateEmail(String email) {
    _isValidEmail = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email);
    notifyListeners();
  }

  // Validate password
  void validatePassword(String password) {
    _isValidPassword = password.length >= 8;
    notifyListeners();
  }

  void confirmPassword(String password, String confirmPassword) {
    _isConfirmedPassword = password == confirmPassword;
    notifyListeners();
  }

  bool get canSignUp {
    return _isValidEmail && _isValidPassword && _isConfirmedPassword;
  }

  // Sign up with email and password
// Sign up with email and password
  Future<String?> signUp(String email, String password, String fullName) async {
    try {
      // Sign up the user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user instance
      User? user = userCredential.user;

      if (user != null) {
        // Store user data in Firestore
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');

        // Add user data to Firestore under the 'users' collection
        await users.doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'fullName': fullName,
          'createdAt': Timestamp.now(),
          // 'isVerified': user.emailVerified,
        });
        log("User Created: ${user.uid}");
        log("Data Stored in Firestore: $email, $fullName");

        // Send email verification if not verified
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          return "Please check your email to verify your account to login.";
        }
        return "Signup Success";
      }

      return "User creation failed.";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "The email is already in use. Please use a different email address.";
      } else if (e.code == 'weak-password') {
        return "The password is too weak. Please choose a stronger password.";
      }
      log('FirebaseAuthException: ${e.message}');
      return e.message;
    } catch (e) {
      log('Error during signup: $e');
      return "An error occurred";
    }
  }

  // Sign in with email and password
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut(); // Ensure the user is signed out
        return "Please verify your email to log in.";
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      return "Login Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An error occurred";
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset email sent";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An error occurred";
    }
  }

  // Check if user is already logged in
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        log("this is the user data${userDoc.data() as Map<String, dynamic>}");
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Log out the user and clear the login state
  Future<void> logOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
}
