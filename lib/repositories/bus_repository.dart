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
    final response = await _apiService.post(
      ApiConstants.searchBus,
      {
        "boardingStop": source,
        "destinationStop": destination,
        "travelTime": time,
      },
    );

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

    return buses;
  }
}