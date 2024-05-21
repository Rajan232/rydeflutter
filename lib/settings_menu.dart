import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart';
import 'add_location.dart'; // Import the new file
import 'update_details.dart';


const appcolours = AppColors();

class SettingsMenu extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  static const String heroTag = 'avatar-hero';

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Hero( // Make the avatar a Hero widget
              tag: heroTag,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
                child: user?.photoURL == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
                'Welcome, ${user?.displayName ?? 'User'}', // Display user name
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton( // Update Profile button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateDetailsPage(user: user)),
                );
              },
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton( // Add Location button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddLocationPage(user: user)),
                );
              },
              child: const Text('Add Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton( // Sign out button
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}