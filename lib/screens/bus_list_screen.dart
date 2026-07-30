import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../repositories/bus_repository.dart';
import '../widgets/bus_card.dart';

class BusListScreen extends StatefulWidget {
  final String source;
  final String destination;
  final String time;
  const BusListScreen({
    super.key,
    required this.source,
    required this.destination,
    required this.time,
  });

  @override
  State<BusListScreen> createState() => _BusListScreenState();}
class _BusListScreenState extends State<BusListScreen> {
  final BusRepository _repository = BusRepository();
  List<Bus> buses = [];

  @override
  void initState() {
    super.initState();
    _loadBuses();
  }
  Future<void> _loadBuses() async {
    try {
      final data = await _repository.searchBuses(
        widget.source,
        widget.destination,
        widget.time,
      );
      if (!mounted) return;
      setState(() {
        buses = data;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    final runningBuses = buses
        .where((bus) => bus.status.toUpperCase() == "RUNNING").toList();
    final scheduledBuses = buses
        .where((bus) => bus.status.toUpperCase() == "SCHEDULED").toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Available Buses"),),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [const SizedBox(height: 20),
          const Center(child: Text("Journey",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          ),
          const SizedBox(height: 10),
          Center(child: Text("${widget.source} → ${widget.destination}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red,),),
          ),
          const SizedBox(height: 15),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                if (runningBuses.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8,),
                    child: Text("Running Buses",
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,),),
                  ),
                  ...runningBuses.map((bus) => BusCard(bus: bus)),
                ],

                if (scheduledBuses.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8,),
                    child: Text("Scheduled Buses",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue,),),
                  ),
                  ...scheduledBuses.map((bus) => BusCard(bus: bus)),
                ],

                if (runningBuses.isEmpty && scheduledBuses.isEmpty)
                  const Center(
                    child: Padding(padding: EdgeInsets.only(top: 50),
                      child: Text("No buses available",
                        style: TextStyle(fontSize: 18, color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}