import '../services/api_service.dart';

class NotificationRepository {
  final ApiService _apiService = ApiService();

  Future<void> subscribeToBus({
    required String fcmToken,
    required String busId,
    required String boardingStop,
    required String destinationStop,
  }) async {
    await _apiService.registerDevice(
      deviceToken: fcmToken,
      busId: busId,
      boardingStop: boardingStop,
      destinationStop: destinationStop,
    );
  }

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
}