import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'colors.dart';
import 'package:permission_handler/permission_handler.dart';

class MapViewMain extends StatefulWidget {
  @override
  _MapViewMainState createState() => _MapViewMainState();
}


const appcolours = AppColors();

class _MapViewMainState extends State<MapViewMain> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-37.87, 145.06); // Latrobe, Melbourne
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(child: Container(color: appcolours.darkGrey, child: Scaffold(body:  GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 14.0,
          ),
        ),)),),
    );
  }
}