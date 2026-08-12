import 'dart:async';
import 'package:flutter/material.dart';
import '../config/api_constants.dart';
import '../services/api_service.dart';
import 'bus_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final ApiService _apiService = ApiService();

  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> sourceSuggestions = [];
  List<String> destinationSuggestions = [];

  bool sourceLoading = false;
  bool destinationLoading = false;

  Timer? _sourceDebounce;
  Timer? _destinationDebounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (timeController.text.isEmpty) {
      timeController.text = selectedTime.format(context);
    }
  }

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    timeController.dispose();

    _sourceDebounce?.cancel();
    _destinationDebounce?.cancel();

    super.dispose();
  }
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      selectedTime = picked;
      timeController.text = picked.format(context);
    });
  }


  Future<void> _searchSourceStops(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        sourceSuggestions = [];
      });
      return;
    }
    setState(() {
      sourceLoading = true;
    });
    try {
      final response = await _apiService.get(
        "${ApiConstants.searchStops}?query=${Uri.encodeComponent(query.trim())}",);
      if (!mounted) return;
      setState(() {
        sourceSuggestions = List<String>.from(response);
        sourceLoading = false;
      });
      debugPrint("Source suggestions: $sourceSuggestions");
    } catch (e) {
      if (!mounted) return;
      setState(() {
        sourceSuggestions = [];
        sourceLoading = false;
      });
      debugPrint("Source search error: $e");
    }
  }
  Future<void> _searchDestinationStops(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        destinationSuggestions = [];
      });
      return;
    }
    setState(() {
      destinationLoading = true;
    });
    try {
      final response = await _apiService.get(
        "${ApiConstants.searchStops}?query=${Uri.encodeComponent(query.trim())}",
      );
      if (!mounted) return;
      setState(() {
        destinationSuggestions = List<String>.from(response);
        destinationLoading = false;
      });
      debugPrint(
        "Destination suggestions: $destinationSuggestions",
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        destinationSuggestions = [];
        destinationLoading = false;
      });
      debugPrint("Destination search error: $e");
    }
  }
  void _onSourceChanged(String value) {
    _sourceDebounce?.cancel();
    _sourceDebounce = Timer(
      const Duration(milliseconds: 300),
          () {_searchSourceStops(value);},
    );
  }
  void _onDestinationChanged(String value) {
    _destinationDebounce?.cancel();
    _destinationDebounce = Timer(
      const Duration(milliseconds: 300),
          () {_searchDestinationStops(value);},
    );
  }
  void _searchBuses() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String source = sourceController.text.trim();
    final String destination = destinationController.text.trim();
    final String time = timeController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusListScreen(source: source, destination: destination, time: time,),
      ),
    );
  }
  Widget _buildSourceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: sourceController, onChanged: _onSourceChanged,
          decoration: InputDecoration(
            labelText: "Boarding",
            hintText: "Search boarding stop",
            prefixIcon: const Icon(
              Icons.location_on, color: Colors.red,
            ),
            suffixIcon: sourceLoading ? const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,),
              ),
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (String? value) {
            if (value == null ||
                value.trim().isEmpty) {
              return "Please select boarding stop";
            }
            return null;
          },
        ),
        if (sourceSuggestions.isNotEmpty)
          _buildSuggestionList(
            sourceSuggestions,
            isSource: true,
          ),
      ],
    );
  }
  Widget _buildDestinationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: destinationController,
          onChanged: _onDestinationChanged,
          decoration: InputDecoration(
            labelText: "Destination",
            hintText: "Search destination stop",
            prefixIcon: const Icon(
              Icons.location_on, color: Colors.red,
            ),
            suffixIcon: destinationLoading
                ? const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2,
                ),
              ),
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (String? value) {
            if (value == null ||
                value.trim().isEmpty) {
              return "Please select destination stop";
            }
            return null;
          },
        ),
        if (destinationSuggestions.isNotEmpty)
          _buildSuggestionList(
            destinationSuggestions,
            isSource: false,
          ),
      ],
    );
  }
  Widget _buildSuggestionList(
      List<String> suggestions, {
        required bool isSource,
      }) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(blurRadius: 5, color: Colors.black26,
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final String stop = suggestions[index];
          return ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red,),
            title: Text(stop),
            onTap: () {
              setState(() {
                if (isSource) {
                  sourceController.text = stop;
                  sourceSuggestions = [];
                } else {
                  destinationController.text = stop;
                  destinationSuggestions = [];
                }
              });
            },
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Bus Tracker"),
      ),
      body: Form(key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(children: [
                    Icon(Icons.directions_bus, color: Colors.red, size: 60,),
                    SizedBox(height: 10),
                    Text("Find Your Bus",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,),
                    ),
                    SizedBox(height: 5),
                    Text("Search buses for your journey",
                      style: TextStyle(color: Colors.grey, fontSize: 15,),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildSourceField(),
              const SizedBox(height: 20),
              _buildDestinationField(),
              const SizedBox(height: 25),
              const Text("Boarding Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              ),
              const SizedBox(height: 8),
              TextFormField(controller: timeController,
                readOnly: true,
                onTap: _selectTime,
                decoration: InputDecoration(
                  hintText: "Select boarding time",
                  prefixIcon: const Icon(
                    Icons.access_time, color: Colors.red,),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time,),
                    onPressed: _selectTime,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please select boarding time";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  onPressed: _searchBuses,
                  icon: const Icon(Icons.search,),
                  label: const Text("Find Buses",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}