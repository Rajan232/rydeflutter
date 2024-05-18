import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'colors.dart';

class MapViewMain extends StatefulWidget {
  @override
  _MapViewMainState createState() => _MapViewMainState();
}

const appcolour = AppColors();

class _MapViewMainState extends State<MapViewMain> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-37.87, 145.06); // Latrobe, Melbourne

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ryde Map'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}