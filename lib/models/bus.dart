import 'route_stop.dart';

class Bus {
  final int busId;
  final String busNumber;
  final String status;
  final double speed;
  final String currentStop;
  final String nextStop;
  final double distanceToNextStop;
  final double remainingDistanceToSource;
  final String etaToSource;
  final double remainingDistanceToDestination;
  final String etaToDestination;
  final String startingFrom;
  final String departureTime;
  final String busArrivalTimeAtSource;
  final String busDestinationArrivalTime;
  final String lastUpdated;
  final String source;
  final String destination;
  final List<RouteStop> routeStops;
  final double latitude;
  final double longitude;

  Bus({
    required this.busId,
    required this.busNumber,
    required this.status,
    required this.speed,
    required this.currentStop,
    required this.nextStop,
    required this.distanceToNextStop,
    required this.remainingDistanceToSource,
    required this.etaToSource,
    required this.remainingDistanceToDestination,
    required this.etaToDestination,
    required this.startingFrom,
    required this.departureTime,
    required this.busArrivalTimeAtSource,
    required this.busDestinationArrivalTime,
    required this.lastUpdated,
    required this.source,
    required this.destination,
    required this.routeStops,
    required this.latitude,
    required this.longitude,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['busId'] ?? 0,
      busNumber: json['busNumber'] ?? '',
      status: json['status'] ?? '',
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      currentStop: json['currentStop'] ?? '',
      nextStop: json['nextStop'] ?? '',
      distanceToNextStop:
      (json['distanceToNextStop'] as num?)?.toDouble() ?? 0.0,
      remainingDistanceToSource:
      (json['remainingDistanceToSource'] as num?)?.toDouble() ?? 0.0,
      etaToSource: json['etaToSource'] ?? '',
      remainingDistanceToDestination:
      (json['remainingDistanceToDestination'] as num?)?.toDouble() ?? 0.0,
      etaToDestination: json['etaToDestination'] ?? '',
      startingFrom: json['startingFrom'] ?? '',
      departureTime: json['departureTime'] ?? '',
      busArrivalTimeAtSource:
      json['busArrivalTimeAtSource'] ?? '',
      busDestinationArrivalTime:
      json['busDestinationArrivalTime'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
      source: json['source'] ?? '',
      destination: json['destination'] ?? '',

      routeStops: (json['routeStops'] as List<dynamic>?)
          ?.map(
            (e) => RouteStop.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}