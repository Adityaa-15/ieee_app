import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Event> events = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Event.fromMap(data);
            }).toList();

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return _buildEventCard(context, events[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return ListTile(
      onTap: () {
        _showEventDetailsDialog(context, event);
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(event.posterUrl),
      ),
      title: Text(event.name),
      subtitle: Text('${event.date}, ${event.time}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          _deleteEvent(context, event);
        },
      ),
    );
  }

  void _deleteEvent(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${event.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performDelete(context, event);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete(BuildContext context, Event event) {
    FirebaseFirestore.instance.collection('Events').where('name', isEqualTo: event.name).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete().then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${event.name} deleted successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete ${event.name}: $error')),
          );
        });
      });
    });
  }

  void _showEventDetailsDialog(BuildContext context, Event event) {
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
                  backgroundImage: NetworkImage(event.posterUrl),
                ),
                SizedBox(height: 16.0),
                Text(
                  event.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${event.date}, ${event.time}',
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
                  event.description,
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

class Event {
  final String name;
  final String date;
  final String time;
  final String description;
  final String posterUrl;

  Event({
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.posterUrl,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      description: map['description'] ?? '',
      posterUrl: map['posterUrl'] ?? '',
    );
  }
}
