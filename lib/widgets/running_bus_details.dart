import 'package:flutter/material.dart';
import '../models/bus.dart';

class RunningBusDetails extends StatelessWidget {
  final Bus bus;
  const RunningBusDetails({
    super.key,
    required this.bus,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWaiting = bus.status.toUpperCase().contains("WAITING");
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(
          isWaiting ? "Waiting Bus Details" : "Running Bus Details",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo,),),
        const SizedBox(height: 15),
        Text("Current Stop : ${bus.currentStop}"),
        const SizedBox(height: 10),
        if (isWaiting)
          const Text("Bus is currently waiting at this stop",
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16,),),
        const SizedBox(height: 10),
        Text("Next Stop : ${bus.nextStop}"),
        const SizedBox(height: 10),
        Text("Speed : ${bus.speed} km/hr"),
        const SizedBox(height: 10),
        Text("Distance to Next Stop : ${bus.distanceToNextStop} km",),
        const SizedBox(height: 10),
        Text("ETA to ${bus.boardingStop} : ${bus.etaToBoardingStop}",),
        const SizedBox(height: 10),
        Text("Arrival at ${bus.boardingStop} : ${bus.busArrivalTimeAtBoardingStop}",),
        const SizedBox(height: 10),
        Text("Remaining Distance to ${bus.destinationStop} : ${bus.remainingDistanceToDestination} km",),
        const SizedBox(height: 10),
        Text("ETA to ${bus.destinationStop} : ${bus.etaToDestinationStop}",),
        const SizedBox(height: 10),
        Text("Arrival at ${bus.destinationStop} : ${bus.busArrivalTimeAtDestinationStop}",),],
    );
  }
}