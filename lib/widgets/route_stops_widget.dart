import 'package:flutter/material.dart';
import '../models/bus.dart';

class RouteStopsWidget extends StatelessWidget {
  final Bus bus;
  final bool isRunning;
  const RouteStopsWidget({
    super.key,
    required this.bus,
    required this.isRunning,
  });
  @override
  Widget build(BuildContext context) {
    if (bus.routeStops.isEmpty) {return const Padding(padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          "No stop schedule details available for this route.",
          style: TextStyle(color: Colors.grey),
        ),);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bus.routeStops.length,
      itemBuilder: (context, index) {
        final stop = bus.routeStops[index];
        final bool isLast = index == bus.routeStops.length - 1;
        final bool isCurrentStop = isRunning && bus.currentStop.toLowerCase() == stop.stopName.toLowerCase();
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Column(
                children: [Icon(
                    isCurrentStop
                        ? Icons.location_on
                        : Icons.radio_button_unchecked,
                    color:
                    isCurrentStop ? Colors.green : Colors.grey,
                    size: 22,
                  ),
                  if (!isLast)
                    Container(width: 2, height: 55, color: Colors.grey,
                    ),],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Padding(padding: const EdgeInsets.only(bottom: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(
                        stop.stopName,
                        style: TextStyle(fontSize: 17, fontWeight: isCurrentStop ? FontWeight.bold : FontWeight.w500,
                          color: isCurrentStop ? Colors.green : Colors.blue,
                        ),
                      ),
                      if (!isLast)
                        Text(
                          "${bus.routeStops[index + 1].distanceFromPrevious} km",
                          style: const TextStyle(color: Colors.black, fontSize: 13,
                          ),
                        ),
                      if (isCurrentStop)
                        const Text(
                          "Current Stop",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold,
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
    );
  }
}