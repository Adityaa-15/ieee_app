import 'package:flutter/material.dart';
import 'package:ieee/screens/adminEvents.dart';
import 'package:ieee/screens/adminTeam.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ieee/screens/adminWorkshop.dart';
import 'package:ieee/screens/loginscreen.dart';
import 'package:ieee/screens/team_members.dart';// Import the screens for each section
// import 'package:your_app/workshop_screen.dart';
// import 'package:your_app/event_screen.dart';
// import 'package:your_app/magazine_screen.dart';

class AdminOptions extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'), // Set the title to "Admin Page"
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Team Members screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPanelPage()),
                );
              },
              child: Text('Team Members'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Workshop screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddWorkshopScreen()),
                );
              },
              child: Text('Workshop'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Event screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEventScreen()),
                );
              },
              child: Text('Event'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Magazine screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeetMyTeamPage()),
                );
              },
              child: Text('Magazine'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logout logic goes here
                _logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
