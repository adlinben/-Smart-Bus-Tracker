import 'package:flutter/material.dart';
import '../models/bus.dart';

class ScheduledBusDetails extends StatelessWidget {
  final Bus bus;
  const ScheduledBusDetails({
    super.key,
    required this.bus,});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text(
          "Scheduled Bus Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo,),),
             const SizedBox(height: 15),
             Text("Starting From : ${bus.startingFrom}"),
             const SizedBox(height: 10),
             Text("Departure Time : ${bus.departureTime}"),
             const SizedBox(height: 10),
             Text("Expected Arrival at ${bus.destination} : " "${bus.busDestinationArrivalTime}",),
      ],
    );}
}