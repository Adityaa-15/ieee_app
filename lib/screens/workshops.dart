import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee/screens/workshopInfo.dart';


class WorkshopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workshops'),
        backgroundColor: Colors.blue[900], // Navy blue background color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Workshops').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final workshops = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: workshops.length,
                    itemBuilder: (context, index) {
                      final workshop = workshops[index].data() as Map<String, dynamic>;

                      return WorkshopTile(
                        posterUrl: workshop['posterUrl'],
                        workshopName: workshop['name'],
                        workshopDate: workshop['date'],
                        workshopTime: workshop['time'],
                        workshopDescription: workshop['description'],
                        workshopImageURL: workshop['posterUrl'], // Pass the posterUrl as workshopImageURL
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

class WorkshopTile extends StatelessWidget {
  final String posterUrl;
  final String workshopName;
  final String workshopDate;
  final String workshopTime;
  final String workshopDescription;
  final String workshopImageURL; // Add workshopImageURL parameter

  WorkshopTile({
    required this.posterUrl,
    required this.workshopName,
    required this.workshopDate,
    required this.workshopTime,
    required this.workshopDescription,
    required this.workshopImageURL, // Add workshopImageURL to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkshopInfo(
                workshopName: workshopName,
                workshopDate: workshopDate,
                workshopTime: workshopTime,
                workshopDescription: workshopDescription,
                workshopImageURL: workshopImageURL,
              ),
            ),
          );
        },
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
                              workshopName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.grey[100], // Background color for the workshop name
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkshopInfo(
                                  workshopName: workshopName,
                                  workshopDate: workshopDate,
                                  workshopTime: workshopTime,
                                  workshopDescription: workshopDescription,
                                  workshopImageURL: workshopImageURL,
                                ),
                              ),
                            );
                          },
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
}
