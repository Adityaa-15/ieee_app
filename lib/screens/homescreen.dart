import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ieee/screens/adminTeam.dart';
import 'package:ieee/screens/contactUs.dart';
import 'package:ieee/screens/events.dart';
import 'package:ieee/screens/magazine.dart';
import 'package:ieee/screens/profileScreen.dart';
import 'package:ieee/screens/team_members.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ieee/screens/loginscreen.dart';
import 'package:ieee/screens/workshops.dart';
import 'package:ieee/screens/magazine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  // List<String> _images = [
  //   'assets/images/college.jpeg',
  //   'assets/images/groupPhoto.png',
  // ];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // Start the image change animation
  //   Timer.periodic(Duration(seconds: 2), (timer) {
  //     setState(() {
  //       _currentIndex = (_currentIndex + 1) % _images.length;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IEEE-VESIT'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout logic goes here
              _logout(context);
            },
          ),
        ],
      ),
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[850],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Meet Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return _buildHomeScreen();
      case 1:
        return MeetMyTeamPage(); // Use imported ExploreScreen class
      case 2:
        return MeetMyTeamPage(); // Use imported MeetTeamScreen class
      case 3:
        return ProfileScreen(); // Use imported ProfileScreen class
      default:
        return Container();
    }
  }

  Widget _buildHomeScreen() {
    return Column(
      children: [
      // Image taking one-fourth of the vertical space
      Container(
      height: 250, // Adjust the height as needed
      color: Colors.grey, // Placeholder color
      child: Image.asset(
        'assets/images/college.jpeg', // Replace 'image.jpg' with your image path
        fit: BoxFit.cover, // Cover horizontally
        width: double.infinity, // Take up full available width
      ),
    ),
    // Text "IEEE-VESIT" with desired style
    Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed
    child: Text(
    'IEEE-VESIT',
    style: TextStyle(
    fontSize: 30, // Adjust font size as needed
    fontFamily: 'PlayfairDisplay', // Kings font style
    color: Colors.blue[900], // Text color
    ),
    ),
    ),
    // Paragraph below "IEEE-VESIT" with some padding
    Expanded(
    flex: 3, // Three-fourths of the vertical space
    child: Container(
    color: Colors.white, // Adjust this color as needed
    child: const Center(
    child: Text(
    'IEEE stands for Institute of Electrical and Electronics Engineers. Here at IEEE-VESIT, we conduct many technical workshops as well as fun events and seminars, maintaining the balance between academics and co-curricular activities. Being the perfect blend of hardware and software, IEEE-VESIT covers a huge cloud of domains in which students can build their career. The faculty and student council works hand-in-hand and the legacy is carried forward.',
      style: TextStyle(fontSize: 18, fontFamily: 'Lato'),
    ),
    ),
    ),
    ),
// Four lines of text with extended borders and filled with royal blue color aligned left and right alternately
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to Upcoming Workshops screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkshopScreen()),
                  );
                },
                child: _buildDecoratedText('Workshops', isLeftAligned: true),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to MagazinePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MagazinePage(title: 'Magazines')),
                  );
                },
                child: _buildDecoratedText('Magazines', isLeftAligned: false),
              ),

              GestureDetector(
                onTap: () {
                  // Navigate to Fun Events screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventsScreen()),
                  );
                },
                child: _buildDecoratedText('Fun Events', isLeftAligned: true),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to Connect with Us screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()),
                  );
                },
                child: _buildDecoratedText('Connect with Us', isLeftAligned: false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDecoratedText(String text, {bool isLeftAligned = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blue[900], // Royal blue color
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(isLeftAligned ? 16.0 : 8.0, 8.0,
            isLeftAligned ? 8.0 : 16.0, 8.0), // Adjust padding to extend the border till the line ends
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color
          ),
        ),
      ),
      alignment: isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
    );
  }
}
