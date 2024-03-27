import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AllTeamMembersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Team Members'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Team').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<TeamMember> teamMembers = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return TeamMember.fromMap(data);
            }).toList();

            return ListView.builder(
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                return _buildTeamMemberCard(context, teamMembers[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildTeamMemberCard(BuildContext context, TeamMember member) {
    return ListTile(
      onTap: () {
        _showMemberDetailsDialog(context, member);
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(member.imageUrl),
      ),
      title: Text(member.name),
      subtitle: Text(member.post),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteTeamMember(context, member);
        },
      ),
    );
  }

  void _deleteTeamMember(BuildContext context, TeamMember member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${member.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performDelete(context, member);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete(BuildContext context, TeamMember member) {
    FirebaseFirestore.instance.collection('Team').where('Name', isEqualTo: member.name).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${member.name} deleted successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete ${member.name}: $error')),
          );
        });
      });
    });
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

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
