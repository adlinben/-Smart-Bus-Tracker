import 'package:flutter/material.dart';
import 'bus_list_screen.dart';
import '../repositories/bus_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final BusRepository _repository = BusRepository();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController =
  TextEditingController();
  final TextEditingController timeController = TextEditingController();

  TimeOfDay? selectedTime;
  bool isLoading = false;

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    timeController.dispose();
    super.dispose();
  }
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeController.text = picked.format(context);
      });
    }
  }
  Future<void> _searchBuses() async {
    if (!_formKey.currentState!.validate()) {
      return;}
    final source = sourceController.text.trim();
    final destination = destinationController.text.trim();
    final time = timeController.text.trim();
    setState(() {
      isLoading = true;
    });
    try {
      final buses = await _repository.searchBuses(source, destination, time,);
      if (!mounted) return;
      if (buses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No buses found for the selected route."),),);
            return;}
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => BusListScreen(buses: buses, source: source, destination: destination,),
        ),);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to connect to server. Please try again.",),),);
    } finally {
      if (mounted) {setState(() {
          isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Tracking"),),
      body: Form(
        key: _formKey,
        child: Padding(padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(controller: sourceController,
                decoration: const InputDecoration(
                  labelText: "Source",
                  border: OutlineInputBorder(),),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter source";
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
                onPressed: isLoading ? null : _searchBuses,
                child: isLoading
                    ? const SizedBox(height: 20, width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue,
                  ),
                )
                    : const Text("Search"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}