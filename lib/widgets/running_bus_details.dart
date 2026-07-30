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
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text("Running Bus Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo,),),
        const SizedBox(height: 15),
        Text("Current Stop : ${bus.currentStop}"),
        const SizedBox(height: 8),
        if (bus.speed == 0) ...[
          Text("Bus is waiting at ${bus.currentStop}",
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 8),
        ],
        Text("Next Stop : ${bus.nextStop}"),
        const SizedBox(height: 8),
        Text("Speed : ${bus.speed} km/hr"),
        const SizedBox(height: 8),
        Text("Distance to Next Stop : ${bus.distanceToNextStop} km"),
        const SizedBox(height: 15),
        Text("ETA to ${bus.boardingStop} : ${bus.etaToBoardingStop}",
          style: const TextStyle(fontWeight: FontWeight.bold),),
        const SizedBox(height: 8),
        Text("Arrival at ${bus.boardingStop} : ${bus.busArrivalTimeAtBoardingStop}",),
        const SizedBox(height: 15),
        Text("Remaining Distance to ${bus.destinationStop} : ${bus.remainingDistanceToDestination} km",),
        const SizedBox(height: 8),
        Text("ETA to ${bus.destinationStop} : ${bus.etaToDestinationStop}",
          style: const TextStyle(fontWeight: FontWeight.bold),),
        const SizedBox(height: 8),
        Text("Arrival at ${bus.destinationStop} : ${bus.busArrivalTimeAtDestinationStop}",),
      ],
    );
  }
}