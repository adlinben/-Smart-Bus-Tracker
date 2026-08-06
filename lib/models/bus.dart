import 'route_stop.dart';

class Bus {
  final String busId;
  final String busNumber;
  final String status;
  final double speed;
  final String currentStop;
  final String nextStop;
  final double distanceToNextStop;
  final String boardingStop;
  final String destinationStop;
  final double remainingDistanceToBoardingStop;
  final String etaToBoardingStop;
  final double remainingDistanceToDestination;
  final String etaToDestinationStop;
  final String startingFrom;
  final String departureTime;
  final String busArrivalTimeAtBoardingStop;
  final String busArrivalTimeAtDestinationStop;
  final String lastUpdated;
  final double latitude;
  final double longitude;
  final List<RouteStop> routeStops;

  Bus({
    required this.busId,
    required this.busNumber,
    required this.status,
    required this.speed,
    required this.currentStop,
    required this.nextStop,
    required this.distanceToNextStop,
    required this.boardingStop,
    required this.destinationStop,
    required this.remainingDistanceToBoardingStop,
    required this.etaToBoardingStop,
    required this.remainingDistanceToDestination,
    required this.etaToDestinationStop,
    required this.startingFrom,
    required this.departureTime,
    required this.busArrivalTimeAtBoardingStop,
    required this.busArrivalTimeAtDestinationStop,
    required this.lastUpdated,
    required this.latitude,
    required this.longitude,
    required this.routeStops,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json["busId"] ?? "",
      busNumber: json["busNumber"] ?? "",
      status: json["status"] ?? "",
      speed: (json["speed"] as num?)?.toDouble() ?? 0.0,
      currentStop: json["currentStop"] ?? "",
      nextStop: json["nextStop"] ?? "",
      distanceToNextStop: (json["distanceToNextStop"] as num?)?.toDouble() ?? 0.0,
      boardingStop: json["boardingStop"] ?? "",
      destinationStop: json["destinationStop"] ?? "",
      remainingDistanceToBoardingStop: (json["remainingDistanceToBoardingStop"] as num?)?.toDouble() ?? 0.0,
      etaToBoardingStop: json["etaToBoardingStop"] ?? "",
      remainingDistanceToDestination: (json["remainingDistanceToDestination"] as num?)?.toDouble() ?? 0.0,
      etaToDestinationStop: json["etaToDestinationStop"] ?? "",
      startingFrom: json["startingFrom"] ?? "",
      departureTime: json["departureTime"] ?? "",
      busArrivalTimeAtBoardingStop: json["busArrivalTimeAtBoardingStop"] ?? "",
      busArrivalTimeAtDestinationStop: json["busArrivalTimeAtDestinationStop"] ?? "",
      lastUpdated: json["lastUpdated"] ?? "",
      latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
      longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
      routeStops: (json["routeStops"] as List<dynamic>?)
          ?.map((e) => RouteStop.fromJson(e))
          .toList() ??
          [],
    );
  }
}