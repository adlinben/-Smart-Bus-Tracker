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
    final status = bus.status.toUpperCase();
    final bool isRunning = status == "RUNNING";
    final bool isWaiting = status.contains("WAITING");
    final bool isScheduled = status == "SCHEDULED";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Row(
              children: [
                const Icon(
                  Icons.directions_bus,
                  color: Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(bus.busNumber,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isRunning ? Colors.green.shade100 : isWaiting ? Colors.orange.shade100 : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(bus.status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isRunning ? Colors.green.shade800 : isWaiting ? Colors.orange.shade800 : Colors.blue.shade800,),),
                ),
              ],
            ),

            const Divider(height: 25),

            if (isRunning || isWaiting) ...[
              Text("Current Stop : ${bus.currentStop}"),
              const SizedBox(height: 6),
              if (isWaiting)
                Text("Bus is waiting at ${bus.currentStop}",
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold,)),
              const SizedBox(height: 6),
              Text("Next Stop : ${bus.nextStop}"),
              const SizedBox(height: 6),
              Text("Speed : ${bus.speed} km/hr"),
              const SizedBox(height: 6),
              Text("Distance to Next Stop : ${bus.distanceToNextStop} km",),
              const SizedBox(height: 6),
              Text("ETA to ${bus.boardingStop} : ${bus.etaToBoardingStop}",),
              const SizedBox(height: 6),
              Text("ETA to ${bus.destinationStop} : ${bus.etaToDestinationStop}",),
            ],

            if (isScheduled) ...[
              Text("Starts From : ${bus.startingFrom}"),
              const SizedBox(height: 6),
              Text("Departure : ${bus.departureTime}"),
              const SizedBox(height: 6),
              Text("Arrival at ${bus.boardingStop} : ${bus.busArrivalTimeAtBoardingStop}"),
              const SizedBox(height: 6),
              Text("Arrival at ${bus.destinationStop} : ${bus.busArrivalTimeAtDestinationStop}",),
            ],
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.info_outline),
                label: const Text("View Details"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BusDetailsScreen(
                        bus: bus,
                      ),
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