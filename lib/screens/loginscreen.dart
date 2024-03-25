// loginscreen.dart

import 'package:flutter/material.dart';
import 'package:ieee/screens/homescreen.dart';
import 'package:ieee/screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ieee/screens/admin.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Check if the email and password match the admin credentials
      if (emailController.text == 'ieee.vesit@ves.ac.in' &&
          passwordController.text == 'ieee@2024') {
        // If admin credentials, navigate to AdminPanelPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPanelPage()),
        );
      } else {
        // If regular user, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print('Login failed: $e');
      // Handle login failure, show error message, etc.
    }
  }


  Future<void> _resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      // Show an error message if the email is empty
      _showErrorDialog('Email is required.');
      return;
    }

    try {
      // Send a password reset email
      await _auth.sendPasswordResetEmail(email: email);

      // Show a confirmation message to the user
      _showSuccessDialog('Password reset email sent to $email.');
    } catch (e) {
      print('Password reset failed: $e');

      // Show an error message to the user
      _showErrorDialog('Failed to send password reset email. Please check your email and try again.');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _resetPassword,
              child: Text('Forgot Password?'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
