import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../widgets/bus_card.dart';

class BusListScreen extends StatelessWidget {
  final List<Bus> buses;
  final String source;
  final String destination;
  const BusListScreen({
    super.key,
    required this.buses,
    required this.source,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final runningBuses = buses
        .where((bus) => bus.status.toUpperCase() == "RUNNING")
        .toList();
    final scheduledBuses = buses
        .where((bus) => bus.status.toUpperCase() == "SCHEDULED")
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Buses"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Journey",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "$source → $destination",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(thickness: 1),
          Expanded(
            child: ListView(
              children: [
                if (runningBuses.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      "Running Buses",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  ...runningBuses.map(
                        (bus) => BusCard(bus: bus),
                  ),
                ],
                if (scheduledBuses.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      "Scheduled Buses",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  ...scheduledBuses.map(
                        (bus) => BusCard(bus: bus),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}