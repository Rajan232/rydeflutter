import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'colors.dart';
import 'package:permission_handler/permission_handler.dart';

class MapViewMain extends StatefulWidget {
  @override
  _MapViewMainState createState() => _MapViewMainState();
}

const appcolours = AppColors();

class _MapViewMainState extends State<MapViewMain> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();

  final LatLng _center = const LatLng(-37.87, 145.06); // Latrobe, Melbourne

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
                  return GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
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
