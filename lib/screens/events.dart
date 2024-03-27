import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.blue[900], // Navy blue background color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Events').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final events = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index].data() as Map<String, dynamic>;

                      return EventTile(
                        posterUrl: event['posterUrl'],
                        eventName: event['name'],
                        eventDate: event['date'],
                        eventTime: event['time'],
                        eventDescription: event['description'],
                      );
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
}

class EventTile extends StatelessWidget {
  final String posterUrl;
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String eventDescription;

  EventTile({
    required this.posterUrl,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _showEventDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Faint grey background color
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: Image.network(
                      posterUrl,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width - 20, // Set height to be equal to the width minus the margins
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey.withOpacity(0.05), // Faint grey background for the name and button row
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0), // Margin for left alignment
                            child: Text(
                              eventName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.grey[100], // Background color for the event name
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _showEventDetails(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800], // Darker blue button color
                          ),
                          child: Text(
                            'More info >>',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900], // Navy blue color
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 5),
                    Text('Date: $eventDate'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 5),
                    Text('Time: $eventTime'),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900], // Navy blue color
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  eventDescription,
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
