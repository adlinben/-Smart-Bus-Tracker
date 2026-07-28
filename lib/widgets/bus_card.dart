import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../screens/bus_details_screen.dart';

class BusCard extends StatelessWidget {
  final Bus bus;
  const BusCard({
    super.key,
    required this.bus,
  });
  @override
  Widget build(BuildContext context) {
    final bool isRunning = bus.status.toUpperCase() == "RUNNING";
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
      child: Padding(padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Row(
              children: [const Icon(
                  Icons.directions_bus, color: Colors.red, size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(bus.busNumber,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5,),
                  decoration: BoxDecoration(
                    color: isRunning ? Colors.green.shade100 : Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(bus.status,
                    style: TextStyle(color: isRunning ? Colors.green.shade800 : Colors.purple.shade800, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 25),
            if (isRunning) ...[
              Text(
                "Current Stop : ${bus.currentStop}",
                style: const TextStyle(fontWeight: FontWeight.w600,),),
              const SizedBox(height: 6),
              Text("Next Stop : ${bus.nextStop}"),
              const SizedBox(height: 6),
              Text("ETA to ${bus.source} : ${bus.etaToSource}"),
            ]
            else ...[
              Text(
                "Starts From : ${bus.startingFrom}",
                style: const TextStyle(fontWeight: FontWeight.w600,),),
              const SizedBox(height: 6),
              Text("Departure : ${bus.departureTime}",),
              const SizedBox(height: 6),
            ],
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.info_outline),
                label: const Text("View Details"),
                onPressed: () {Navigator.push(
                    context, MaterialPageRoute(
                      builder: (_) => BusDetailsScreen(bus: bus),
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