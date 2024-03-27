import 'package:flutter/material.dart';

class WorkshopInfo extends StatelessWidget {
  final String workshopName;
  final String workshopDate;
  final String workshopTime;
  final String workshopDescription;
  final String workshopImageURL;

  WorkshopInfo({
    required this.workshopName,
    required this.workshopDate,
    required this.workshopTime,
    required this.workshopDescription,
    required this.workshopImageURL,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Workshop Info'),
        backgroundColor: Colors.blue[900], // Set background color to navy blue
      ),
      body: Stack(
        children: [
          // Background image fetched from Firebase with blur effect
          Image.network(
            workshopImageURL,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Workshop details overlay
          Center(
            child: Container(
              width: screenWidth * 0.9,
              height: screenWidth * 0.9, // Height equal to width
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    workshopName,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 20.0),
                      SizedBox(width: 5.0),
                      Text(
                        workshopDate,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 20.0),
                      SizedBox(width: 5.0),
                      Text(
                        workshopTime,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        workshopDescription,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
