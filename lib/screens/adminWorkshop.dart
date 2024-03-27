import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ieee/screens/adminDeleteWorkshop.dart';
import 'package:image_picker/image_picker.dart';


class AddWorkshopScreen extends StatefulWidget {
  @override
  _AddWorkshopScreenState createState() => _AddWorkshopScreenState();
}

class _AddWorkshopScreenState extends State<AddWorkshopScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _workshopName;
  late String _workshopDate;
  late String _workshopDescription;
  late String _workshopTime;
  File? _workshopPoster;
  late String _posterUrl = '';

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workshop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Workshop Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workshop name';
                  }
                  return null;
                },
                onSaved: (value) => _workshopName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onSaved: (value) => _workshopDate = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _workshopDescription = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
                onSaved: (value) => _workshopTime = value!,
              ),
              ElevatedButton(
                onPressed: _pickWorkshopPoster,
                child: Text('Upload Poster'),
              ),
              _workshopPoster != null
                  ? Image.file(
                _workshopPoster!,
                height: 150,
              )
                  : SizedBox(),
              ElevatedButton(
                onPressed: _addWorkshop,
                child: Text('Add Workshop'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllWorkshopsScreen()),
                  );
                },
                child: Text('Delete a Workshop'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickWorkshopPoster() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _workshopPoster = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _addWorkshop() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload poster image to Firebase Storage
      String _posterUrl = '';
      if (_workshopPoster != null) {
        Reference ref = FirebaseStorage.instance.ref().child('workshop_posters/${DateTime.now().toString()}');
        UploadTask uploadTask = ref.putFile(_workshopPoster!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        _posterUrl = await taskSnapshot.ref.getDownloadURL();
      }

      // Save workshop details to Firestore
      FirebaseFirestore.instance.collection('Workshops').add({
        'name': _workshopName,
        'date': _workshopDate,
        'description': _workshopDescription,
        'time': _workshopTime,
        'posterUrl': _posterUrl,
      }).then((_) {
        // Clear form after submission
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workshop added successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add workshop: $error')),
        );
      });
    }
  }
}
