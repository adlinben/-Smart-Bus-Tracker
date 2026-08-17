import '../config/api_constants.dart';
import '../models/bus.dart';
import '../services/api_service.dart';

class BusRepository {
  final ApiService _apiService = ApiService();

  Future<List<Bus>> searchBuses(
      String source,
      String destination,
      String time,
      ) async {
    print("========================================");
    print("BUS SEARCH");
    print("Source      : $source");
    print("Destination : $destination");
    print("Time        : $time");
    print("========================================");
    final response = await _apiService.post(
      ApiConstants.searchBus,
      {
        "boardingStop": source,
        "destinationStop": destination,
        "travelTime": time,
      },
    );
    print("========================================");
    print("RAW BACKEND RESPONSE");
    print(response);
    print("========================================");

    if (response == null) {
      return [];
    }
    if (response is! List) {
      throw Exception(
        "Expected bus list from backend",
      );
    }
    final List<Bus> buses = [];
    for (final item in response) {
      if (item is Map<String, dynamic>) {
        buses.add(
          Bus.fromJson(item),
        );
      } else if (item is Map) {
        buses.add(
          Bus.fromJson(
            Map<String, dynamic>.from(item),
          ),
        );
      }
    }
    print(
      "TOTAL BUSES FROM BACKEND: ${buses.length}",
    );

    for (final bus in buses) {
      print("----------------------------------------");
      print("Bus ID       : ${bus.busId}");
      print("Bus Number   : ${bus.busNumber}");
      print("Status       : ${bus.status}");
      print("Current Stop : ${bus.currentStop}");
      print("Next Stop    : ${bus.nextStop}");
      print("Speed        : ${bus.speed}");
      print(
        "Boarding ETA : ${bus.etaToBoardingStop}",
      );
      print(
        "Destination ETA : ${bus.etaToDestinationStop}",
      );
      print("Latitude     : ${bus.latitude}");
      print("Longitude    : ${bus.longitude}");
      print(
        "Route Stops  : ${bus.routeStops.length}",
      );
    }
    print("========================================");
    return buses;
  }
}