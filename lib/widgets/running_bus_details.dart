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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text(
          "Running Bus Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo,),),
        const SizedBox(height: 15),
        Text("Current Stop : ${bus.currentStop}"),
        const SizedBox(height: 10),
        Text("Next Stop : ${bus.nextStop}"),
        const SizedBox(height: 10),
        Text("Distance to Next Stop : ${bus.distanceToNextStop} km"),
        const SizedBox(height: 10),
        Text("ETA to ${bus.source} : ${bus.etaToSource}"),
        const SizedBox(height: 10),
        Text("Remaining Distance to ${bus.destination} : " "${bus.remainingDistanceToDestination} km",),
        const SizedBox(height: 10),
        Text("ETA to ${bus.destination} : ${bus.etaToDestination}"),
      ],
    );}
}