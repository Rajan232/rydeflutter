import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'; // Import path to work with file paths

class UpdateDetailsPage extends StatefulWidget {
  final User? user;
  const UpdateDetailsPage({Key? key, required this.user}) : super(key: key); // Constructor for passing user object

  @override
  _UpdateDetailsPageState createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user?.displayName ?? ''; // Initialize name field
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.user?.updateDisplayName(_nameController.text);

        if (_image != null) {
          // Upload the image to Firebase Storage
          String fileName = basename(_image!.path);
          Reference ref = FirebaseStorage.instance.ref().child('profile_images/$fileName');
          await ref.putFile(_image!);
          String photoURL = await ref.getDownloadURL();
          await widget.user?.updatePhotoURL(photoURL);
        }

        // Optionally, show a success message
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );

        Navigator.pop(context as BuildContext); // Go back after updating
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future _pickImage() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _image = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  onTap: _pickImage, // Make the avatar clickable
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _image != null ? FileImage(_image!) as ImageProvider<Object>? : NetworkImage(widget.user?.photoURL ?? '') as ImageProvider<Object>?,
                    child: widget.user?.photoURL == null && _image == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField( // Name field
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
