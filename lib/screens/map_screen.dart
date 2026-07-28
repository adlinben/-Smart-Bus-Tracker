import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/bus.dart';

class MapScreen extends StatelessWidget {
  final Bus bus;
  const MapScreen({super.key, required this.bus});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(bus.latitude, bus.longitude), zoom: 15,),
        markers: {Marker(
            markerId: const MarkerId("bus"),
            position: LatLng(bus.latitude, bus.longitude),
            infoWindow: InfoWindow(title: bus.busNumber),
          ),
        },
      ),
    );
  }
}
