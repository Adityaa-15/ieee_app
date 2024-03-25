import 'package:flutter/material.dart';
import 'package:ieee/screens/admin.dart';
import 'package:ieee/screens/team_members.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IEEE-VESIT'),
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
        return AdminPanelPage(); // Use imported ProfileScreen class
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
        'assets/images/grey.jpeg', // Replace 'image.jpg' with your image path
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
              _buildDecoratedText('Upcoming Workshops', isLeftAligned: true),
              _buildDecoratedText('Meet our Team', isLeftAligned: false),
              _buildDecoratedText('Fun Events', isLeftAligned: true),
              _buildDecoratedText('Connect with Us', isLeftAligned: false),
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
