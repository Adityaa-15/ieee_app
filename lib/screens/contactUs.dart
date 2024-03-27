import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import package for launching URLs
import 'package:ieee/screens/homescreen.dart';
class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  int _currentIndex = 0;
  List<String> _images = [
    'assets/images/college.jpeg',
    'assets/images/groupPhoto.png',
  ];

  @override
  void initState() {
    super.initState();
    // Start the image change animation
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.grey, // Placeholder color
              child: Image.asset(
                _images[_currentIndex],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250.0,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    'Connect with Us!',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'PlayfairDisplay',
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    'If you have any queries or feedback, feel free to reach out to us!',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(FontAwesomeIcons.instagram, Colors.pink, () {
                  _launchURL('https://www.instagram.com/ieee_vesit');
                }),

                SizedBox(width: 20),
                _buildSocialIcon(FontAwesomeIcons.envelope, Colors.orange, () {
                  _launchEmail();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, Function() onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(12),
      child: IconButton(
        onPressed: onPressed,
        icon: FaIcon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }

  // Function to launch URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to launch Email
  void _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'ieee.vesit@ves.ac.in',
      query: 'subject=Query',
    );

    var emailUrl = params.toString();
    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }
}
