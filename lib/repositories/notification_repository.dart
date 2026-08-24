import '../services/api_service.dart';

class NotificationRepository {
  final ApiService _apiService = ApiService();

  Future<void> registerBusNotification({
    required String deviceToken,
    required String busId,
    required String boardingStop,
    required String destinationStop,
  }) async {
    await _apiService.registerDevice(
      deviceToken: deviceToken,
      busId: busId,
      boardingStop: boardingStop,
      destinationStop: destinationStop,
    );
  }

  Future<void> unsubscribeFromBus({
    required String deviceToken,
    required String busId,
  }) async {
    await _apiService.unsubscribeDevice(
      deviceToken: deviceToken,
      busId: busId,
    );
  }
}