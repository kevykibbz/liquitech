import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:liquitech/maps config/directions_model.dart';
import 'package:liquitech/maps config/directions_repository.dart';
import 'dart:async';
import 'package:location/location.dart';

double latitude=0.0;
double longitude=0.0;

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final Location location = Location();
  final themedata = GetStorage();
  late StreamSubscription locationSubscription;
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
    tilt: 50.0,
  );

  late GoogleMapController _googleMapController;
  late Marker _origin;
  late Marker _destination;
  late Directions _info;

  @override
  void initState() {
    super.initState();
    getLocationStatus();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void getLocationStatus() {
    locationSubscription =
        location.onLocationChanged.listen((LocationData result) async {
      final PermissionStatus permissionGrantedResult =
          await location.hasPermission();
      final service = await location.serviceEnabled();
      if (permissionGrantedResult != PermissionStatus.granted) {
        await location.requestPermission();
      } else {
        getGeoPoint(result);
      }
      if (!service) {
        await location.requestService();
      }else {
        getGeoPoint(result);
      }
      
    });
  }

  void getGeoPoint(LocationData result){
    setState(() {
      latitude = result.latitude as double;
      longitude = result.longitude as double;
      print("curent latitude is:$latitude and longitude is :$longitude");
    });
  }

  @override
  Widget build(BuildContext context) {
    final themedata = GetStorage();
    bool isDarkMode = themedata.read("darkmode") ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('View location'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.green : Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Origin'),
          ),
          TextButton(
            onPressed: () {
              _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.blue : Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            child: const Text('Dest'),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: const <Widget>[
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _initialCameraPosition,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          _googleMapController.animateCamera(
            // ignore: unnecessary_null_comparison
            _info != null
                ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
                : CameraUpdate.newCameraPosition(_initialCameraPosition),
          );
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
    });
    // Get directions
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin.position, destination: pos);
    setState(() => _info = directions!);
  }
}
