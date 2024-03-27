import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ieee/screens/adminDeleteMember.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanelPage extends StatefulWidget {
  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _category;
  late String _name;
  late String _post;
  late String _email;
  late String _linkedInUrl;
  late String _instagramUrl;
  File? _image;
  late String _imageUrl = '';

  final picker = ImagePicker();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                onSaved: (value) => _category = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Post'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a post';
                  }
                  return null;
                },
                onSaved: (value) => _post = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'LinkedIn URL'),
                onSaved: (value) => _linkedInUrl = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Instagram URL'),
                onSaved: (value) => _instagramUrl = value!,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
              ),
              _image != null
                  ? Image.file(
                _image!,
                height: 150,
              )
                  : SizedBox(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addTeamMember();
                  }
                },
                child: Text('Add Team Member'),
              ),
              SizedBox(height: 16), // Add space between the buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to DeleteScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllTeamMembersScreen()),
                  );
                },
                child: Text('Delete Team Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _addTeamMember() async {
    // Upload image to Firebase Storage
    if (_image != null) {
      Reference ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      _imageUrl = await taskSnapshot.ref.getDownloadURL();
    }

    // Save details to Firestore
    FirebaseFirestore.instance.collection('Team').add({
      'Category': _category,
      'Name': _name,
      'Post': _post,
      'Email': _email,
      'LinkedIn': _linkedInUrl,
      'InstagramID': _instagramUrl,
      'ImageURL': _imageUrl,
    }).then((_) {
      // Clear form after submission
      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team member added successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add team member: $error')),
      );
    });
  }
}