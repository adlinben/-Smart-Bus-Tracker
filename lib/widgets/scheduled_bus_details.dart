import 'package:flutter/material.dart';
import '../models/bus.dart';

class ScheduledBusDetails extends StatelessWidget {
  final Bus bus;
  const ScheduledBusDetails({
    super.key,
    required this.bus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text("Scheduled Bus Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo,),),
        const SizedBox(height: 15),
        Text("Starts From : ${bus.startingFrom}"),
        const SizedBox(height: 8),
        Text("Departure Time : ${bus.departureTime}"),
        const SizedBox(height: 15),
        Text("Arrival at ${bus.boardingStop} : ${bus.busArrivalTimeAtBoardingStop}",
          style: const TextStyle(fontWeight: FontWeight.bold),),
        const SizedBox(height: 8),
        Text("Arrival at ${bus.destinationStop} : ${bus.busArrivalTimeAtDestinationStop}",
          style: const TextStyle(fontWeight: FontWeight.bold),),
      ],
    );
  }
}