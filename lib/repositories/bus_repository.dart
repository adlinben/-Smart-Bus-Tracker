import '../config/api_constants.dart';
import '../models/bus.dart';
import '../services/api_service.dart';

class BusRepository {
  final ApiService _apiService = ApiService();
  Future<List<Bus>> searchBuses(String source, String destination, String time,) async {
    final response = await _apiService.post(
      ApiConstants.searchBus,
      {
        "currentLocation": source,
        "destination": destination,
        "time": time,
      },
    );
    return (response as List)
        .map((e) => Bus.fromJson(e))
        .toList();
  }
}