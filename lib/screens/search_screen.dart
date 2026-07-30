import 'package:flutter/material.dart';
import 'bus_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController =
  TextEditingController();
  final TextEditingController timeController = TextEditingController();

  TimeOfDay? selectedTime;
  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeController.text = picked.format(context);
      });
    }
  }

  void _searchBuses() {
    if (!_formKey.currentState!.validate()) {
      return;}
    final source = sourceController.text.trim();
    final destination = destinationController.text.trim();
    final time = timeController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusListScreen(
          source: source,
          destination: destination,
          time: time,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Tracking"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: sourceController,
                decoration: const InputDecoration(
                  labelText: "Boarding",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter Boarding";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: destinationController,
                decoration: const InputDecoration(
                  labelText: "Destination",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter destination";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: InputDecoration(
                  labelText: "Time",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please select time";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _searchBuses,
                child: const Text("Search"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}