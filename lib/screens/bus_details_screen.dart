import 'dart:async';
import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../repositories/bus_repository.dart';
import '../widgets/running_bus_details.dart';
import '../widgets/scheduled_bus_details.dart';
import '../widgets/route_stops_widget.dart';
import 'map_screen.dart';

class BusDetailsScreen extends StatefulWidget {
  final Bus bus;
  const BusDetailsScreen({
    super.key,
    required this.bus,
  });

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();}
class _BusDetailsScreenState extends State<BusDetailsScreen> {
  final BusRepository _repository = BusRepository();
  late Bus bus;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    bus = widget.bus;
    _loadBus();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _loadBus(),
    );
  }

  Future<void> _loadBus() async {
    try {
      final buses = await _repository.searchBuses(
        bus.boardingStop,
        bus.destinationStop,
        bus.departureTime,
      );

      final updatedBus = buses.firstWhere(
            (b) => b.busId == bus.busId,
        orElse: () => bus,
      );

      if (!mounted) return;
      setState(() {
        bus = updatedBus;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = bus.status.toUpperCase();
    final isRunning = status == "RUNNING";
    final isScheduled = status == "SCHEDULED";

    return Scaffold(
      appBar: AppBar(title: const Text("Bus Details"),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("Bus Number : ${bus.busNumber}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
            const SizedBox(height: 10),
            Text("Journey : ${bus.boardingStop} → ${bus.destinationStop}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red,),),
            const Divider(height: 30),
            Text("Status : ${bus.status}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isRunning ? Colors.green : Colors.blue,),),
            const SizedBox(height: 20),
            if (isRunning)
              RunningBusDetails(bus: bus),
            if (isScheduled)
              ScheduledBusDetails(bus: bus),
            const SizedBox(height: 20),
            Text("Last Updated : ${bus.lastUpdated}",),
            const SizedBox(height: 25),
            const Text("Route Stops",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),

            const Divider(),
            RouteStopsWidget(
              bus: bus,
              isRunning: isRunning,
            ),
            const SizedBox(height: 30),

            if (isRunning && bus.latitude != 0 && bus.longitude != 0)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text("View Live Location"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapScreen(bus: bus),
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