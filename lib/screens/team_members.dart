import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMember {
  final String name;
  final String post;
  final String imageUrl;
  final String linkedInUrl;
  final String instagramUrl;
  final String email;
  final String category;

  TeamMember({
    required this.name,
    required this.post,
    required this.imageUrl,
    required this.linkedInUrl,
    required this.instagramUrl,
    required this.email,
    required this.category,
  });

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      name: map['Name'] ?? '',
      post: map['Post'] ?? '',
      imageUrl: map['ImageURL'] ?? '',
      linkedInUrl: map['LinkedIn'] ?? '',
      instagramUrl: map['InstagramID'] ?? '',
      email: map['Email'] ?? '',
      category: map['Category'] ?? '',
    );
  }
}

class MeetMyTeamPage extends StatefulWidget {
  @override
  _MeetMyTeamPageState createState() => _MeetMyTeamPageState();
}

class _MeetMyTeamPageState extends State<MeetMyTeamPage> {
  String _selectedCategory = 'Faculty';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Team'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryOption('Faculty'),
                  _buildCategoryOption('BE'),
                  _buildCategoryOption('TE'),
                  _buildCategoryOption('SE'),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Team').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<TeamMember> teamMembers = snapshot.data!.docs.map((
                      doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return TeamMember.fromMap(data);
                  })
                      .where((member) => member.category == _selectedCategory)
                      .toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: teamMembers.length,
                    itemBuilder: (context, index) {
                      return _buildTeamMemberCard(context, teamMembers[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(String category) {
    bool isSelected = category == _selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(BuildContext context, TeamMember member) {
    return GestureDetector(
      onTap: () {
        _showMemberDetailsDialog(context, member);
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: NetworkImage(member.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        member.post,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showMemberDetailsDialog(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(member.imageUrl),
                ),
                SizedBox(height: 16.0),
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  member.post,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IconButton(
                    //   icon: Icon(Icons.email),
                    //   onPressed: () {
                    //     _launchURL(member.email);
                    //   },
                    // ),
                    IconButton(
                      icon: Icon(CupertinoIcons.news),
                      onPressed: () {
                        _launchURL(member.linkedInUrl);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        _launchURL(member.instagramUrl);
                      },
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
