import 'package:flutter/material.dart';
import 'package:ieee/screens/adminOptions.dart';
import 'package:ieee/screens/homescreen.dart';
import 'package:ieee/screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ieee/screens/adminTeam.dart';

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
          MaterialPageRoute(builder: (context) => AdminOptions()),
        );
      } else {
        // If regular user, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/loginMain.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100), // Increased distance between logo and email box
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/logowhiteonblack.png",
                  height: 125, // Adjust as needed
                  width: 125, // Adjust as needed
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 175), // Added padding between logo and email box
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Reduced the SizedBox height
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _resetPassword,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _login(context),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                            );
                          },
                          child: Text(
                            "Don't have an account? Sign up",
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
