import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllWorkshopsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Workshops'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Workshops').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Workshop> workshops = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Workshop.fromMap(data);
            }).toList();

            return ListView.builder(
              itemCount: workshops.length,
              itemBuilder: (context, index) {
                return _buildWorkshopCard(context, workshops[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildWorkshopCard(BuildContext context, Workshop workshop) {
    return ListTile(
      onTap: () {
        _showWorkshopDetailsDialog(context, workshop);
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(workshop.posterUrl),
      ),
      title: Text(workshop.name),
      subtitle: Text('${workshop.date}, ${workshop.time}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteWorkshop(context, workshop);
        },
      ),
    );
  }

  void _deleteWorkshop(BuildContext context, Workshop workshop) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${workshop.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performDelete(context, workshop);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete(BuildContext context, Workshop workshop) {
    FirebaseFirestore.instance.collection('Workshops').where('name', isEqualTo: workshop.name).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${workshop.name} deleted successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete ${workshop.name}: $error')),
          );
        });
      });
    });
  }

  void _showWorkshopDetailsDialog(BuildContext context, Workshop workshop) {
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
                  backgroundImage: NetworkImage(workshop.posterUrl),
                ),
                SizedBox(height: 16.0),
                Text(
                  workshop.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${workshop.date}, ${workshop.time}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  workshop.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Workshop {
  final String name;
  final String date;
  final String time;
  final String description;
  final String posterUrl;

  Workshop({
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.posterUrl,
  });

  factory Workshop.fromMap(Map<String, dynamic> map) {
    return Workshop(
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      description: map['description'] ?? '',
      posterUrl: map['posterUrl'] ?? '',
    );
  }
}
