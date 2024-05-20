import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rydeflutter/colors.dart';

class MapViewMain extends StatefulWidget {
  @override
  _MapViewMainState createState() => _MapViewMainState();
}

const appcolours = AppColors();

class _MapViewMainState extends State<MapViewMain> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  final LatLng _center = const LatLng(-37.87, 145.06); // Latrobe, Melbourne
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Container(
          color: appcolours.darkGrey,
          child: Scaffold(
            body: FutureBuilder(
              future: Future.delayed(Duration.zero, () async {
                await Permission.location.request();
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 14.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                      ),
                      // Profile Photo or User Icon Widget
                      Positioned(
                        top: 16.0, // Adjust position as needed
                        right: 16.0,
                        child: CircleAvatar(
                          backgroundImage: user != null && user!.providerData.isNotEmpty &&
                                  user!.providerData[0].providerId == 'google.com'
                              ? NetworkImage(user!.photoURL ?? '') // Google photo if available
                              : null, // No image if not Google sign-in
                          backgroundColor: Colors.grey, // Generic user icon
                          radius: 25, // Background color for generic icon
                          child: user != null && user!.providerData.isNotEmpty &&
                                  user!.providerData[0].providerId == 'google.com'
                              ? null // No child if Google photo is available
                              : const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
