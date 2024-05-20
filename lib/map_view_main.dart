import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapViewMain extends StatefulWidget {
  @override
  _MapViewMainState createState() => _MapViewMainState();
}

class _MapViewMainState extends State<MapViewMain> with WidgetsBindingObserver {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-37.87, 145.06); // Chadstone, Melbourne
  bool _isMapInitialized = false; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    mapController.dispose(); 
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isMapInitialized) {
      _initMap();
    }
  }

  Future<void> _initMap() async {
    if (await Permission.location.request().isGranted) {
      setState(() => _isMapInitialized = true);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chadstone Map'),
          backgroundColor: Colors.green[700],
        ),
        body: _isMapInitialized ? GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 12, 
          ),
          onMapCreated: _onMapCreated,
          // Set map options here
          liteModeEnabled: false, // Disable lite mode for better performance
          minMaxZoomPreference: const MinMaxZoomPreference(10, 16), // Limit zoom
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ):Container(), //show container until the permission is granted to access the map
      ),
    );
  }
}

