import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ieee/screens/adminDeleteEvents.dart';
import 'package:image_picker/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _eventName;
  late String _eventDate;
  late String _eventDescription;
  late String _eventTime;
  File? _eventPoster;
  late String _posterUrl = '';

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
                onSaved: (value) => _eventName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onSaved: (value) => _eventDate = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _eventDescription = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
                onSaved: (value) => _eventTime = value!,
              ),
              ElevatedButton(
                onPressed: _pickEventPoster,
                child: Text('Upload Poster'),
              ),
              _eventPoster != null
                  ? Image.file(
                _eventPoster!,
                height: 150,
              )
                  : SizedBox(),
              ElevatedButton(
                onPressed: _addEvent,
                child: Text('Add Event'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllEventsScreen()), // Navigate to the delete event screen
                  );
                },
                child: Text('Delete an Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickEventPoster() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _eventPoster = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _addEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload poster image to Firebase Storage
      if (_eventPoster != null) {
        Reference ref = FirebaseStorage.instance.ref().child('event_posters/${DateTime.now().toString()}');
        UploadTask uploadTask = ref.putFile(_eventPoster!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        _posterUrl = await taskSnapshot.ref.getDownloadURL();
      }

      // Save event details to Firestore
      FirebaseFirestore.instance.collection('Events').add({
        'name': _eventName,
        'date': _eventDate,
        'description': _eventDescription,
        'time': _eventTime,
        'posterUrl': _posterUrl,
      }).then((_) {
        // Clear form after submission
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event added successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add event: $error')),
        );
      });
    }
  }
}
