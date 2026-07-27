import 'package:flutter/material.dart';
import '../models/bus.dart';
import 'map_screen.dart';
class BusDetailsScreen extends StatelessWidget {
  final Bus bus;
  const BusDetailsScreen({
    super.key,
    required this.bus,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRunning = bus.status.toUpperCase() == 'RUNNING';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bus Number : ${bus.busNumber}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Journey : ${bus.source} -> ${bus.destination}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const Divider(height: 30),
            Text("Status : ${bus.status}",
                style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (isRunning) ...[
              const Text(
                "Running Bus Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 15),
              Text("Current Stop : ${bus.currentStop}"),
              const SizedBox(height: 10),
              Text("Next Stop : ${bus.nextStop}"),
              const SizedBox(height: 10),
              Text("Distance to Next Stop : ${bus.distanceToNextStop} km"),
              const SizedBox(height: 10),
              Text("ETA to ${bus.source} : ${bus.etaToSource}"),
              const SizedBox(height: 10),
              Text("Remaining Distance to ${bus.destination} : ${bus.remainingDistanceToDestination} km"),
              const SizedBox(height: 10),
              Text("ETA to ${bus.destination} : ${bus.etaToDestination}"),
            ]
            else ...[
              const Text(
                "Scheduled Bus Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 15),
              Text("Starting From : ${bus.startingFrom}"),
              const SizedBox(height: 10),
              Text("Departure Time : ${bus.departureTime}"),
              const SizedBox(height: 10),
              Text("Expected Arrival at ${bus.destination} : ${bus.busDestinationArrivalTime}"),
            ],
               Text("Last Updated : ${bus.lastUpdated}"),
            const SizedBox(height: 30),
            const Text(
              "Route Stops",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            if (bus.routeStops.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("No stop schedule details available for this route.",
                    style: TextStyle(color: Colors.grey,)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bus.routeStops.length,
                itemBuilder: (context, index) {

                  final stop = bus.routeStops[index];
                  final bool isLast = index == bus.routeStops.length - 1;
                  final bool isCurrentStop = isRunning &&
                      bus.currentStop.toLowerCase() == stop.stopName.toLowerCase();
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(
                              isCurrentStop
                                  ? Icons.location_on
                                  : Icons.radio_button_unchecked,
                              color: isCurrentStop
                                  ? Colors.green
                                  : Colors.grey,
                              size: 22,
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 55,
                                color: Colors.grey,
                              ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stop.stopName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: isCurrentStop
                                        ? FontWeight.bold
                                         : FontWeight.w500,
                                    color: isCurrentStop
                                        ? Colors.green
                                        : Colors.blue,
                                  ),
                                ),

                                if (!isLast)
                                  Text(
                                    "${bus.routeStops[index + 1].distanceFromPrevious} km",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                if (isCurrentStop)
                                  const Text(
                                    "Current Stop",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
            if (isRunning && bus.latitude != 0.0)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text("View Live Location"),
                  onPressed: () {
                    Navigator.push(
                      context,
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
 