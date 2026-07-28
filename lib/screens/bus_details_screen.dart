import 'package:flutter/material.dart';
import '../models/bus.dart';
import 'map_screen.dart';
import '../widgets/running_bus_details.dart';
import '../widgets/scheduled_bus_details.dart';
import '../widgets/route_stops_widget.dart';

class BusDetailsScreen extends StatelessWidget {
  final Bus bus;
  const BusDetailsScreen({super.key,
    required this.bus,
  });
  @override
  Widget build(BuildContext context) {
    final bool isRunning = bus.status.toUpperCase() == "RUNNING";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(
              "Bus Number : ${bus.busNumber}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("Journey : ${bus.source} -> ${bus.destination}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red,),),
            const Divider(height: 30),
            Text("Status : ${bus.status}",
              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold,),),
            const SizedBox(height: 15),

            if (isRunning)
              RunningBusDetails(bus: bus)
            else
              ScheduledBusDetails(bus: bus),

            const SizedBox(height: 20),
            Text("Last Updated : ${bus.lastUpdated}",
              style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 30),
            const Text("Route Stops",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),

            const Divider(),
            RouteStopsWidget(
              bus: bus,
              isRunning: isRunning,
            ),
            const SizedBox(height: 30),

            if (isRunning && bus.latitude != 0.0)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text("View Live Location"),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(bus: bus),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}