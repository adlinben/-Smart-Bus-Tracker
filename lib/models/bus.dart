import 'route_stop.dart';

class Bus {
  final String busId;
  final String busNumber;
  final String status;
  final String statusBanner;
  final double speed;
  final String currentStop;
  final String nextStop;
  final double distanceToNextStop;
  final String boardingStop;
  final double remainingDistanceToBoardingStop;
  final String etaToBoardingStop;
  final String busArrivalTimeAtBoardingStop;
  final String destinationStop;
  final double remainingDistanceToDestination;
  final String etaToDestinationStop;
  final String busArrivalTimeAtDestinationStop;
  final String startingFrom;
  final String departureTime;
  final double latitude;
  final double longitude;
  final String lastUpdated;
  final List<RouteStop> routeStops;
  const Bus({
    required this.busId,
    required this.busNumber,
    required this.status,
    required this.statusBanner,
    required this.speed,
    required this.currentStop,
    required this.nextStop,
    required this.distanceToNextStop,
    required this.boardingStop,
    required this.remainingDistanceToBoardingStop,
    required this.etaToBoardingStop,
    required this.busArrivalTimeAtBoardingStop,
    required this.destinationStop,
    required this.remainingDistanceToDestination,
    required this.etaToDestinationStop,
    required this.busArrivalTimeAtDestinationStop,
    required this.startingFrom,
    required this.departureTime,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
    required this.routeStops,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    print('========================================');
    print('MAPPING BACKEND BUS RESPONSE');
    print('Status Banner: ${json["statusBanner"]}');
    print('Current Stop: ${json["currentStop"]}');
    print('Next Stop: ${json["nextStop"]}');
    print('Speed: ${json["speed"]}');
    print('========================================');
    return Bus(
      busId: _toString(json["busId"]),
      busNumber: _toString(json["busNumber"]),
      status: _toString(json["status"]),
      statusBanner: _toString(json["statusBanner"]),
      speed: _toDouble(json["speed"]),
      currentStop: _toString(json["currentStop"]),
      nextStop: _toString(json["nextStop"]),
      distanceToNextStop: _toDouble(json["distanceToNextStop"]),
      boardingStop: _toString(json["boardingStop"]),
      remainingDistanceToBoardingStop: _toDouble(json["remainingDistanceToBoardingStop"],),
      etaToBoardingStop: _toString(json["boardingEta"]),
      busArrivalTimeAtBoardingStop: _toString(json["boardingArrival"]),
      destinationStop: _toString(json["destinationStop"]),
      remainingDistanceToDestination: _toDouble(json["destinationRemainingDistance"],),
      etaToDestinationStop: _toString(json["destinationEta"]),
      busArrivalTimeAtDestinationStop: _toString(json["destinationArrival"]),
      startingFrom: _toString(json["startingFrom"]),
      departureTime: _toString(json["departureTime"]),
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
      lastUpdated: _toString(json["lastUpdated"]),
      routeStops: _parseRouteStops(json["routeStops"]),
    );
  }
  static String _toString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }
  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  static List<RouteStop> _parseRouteStops(dynamic value) {
    if (value == null) {
      return [];
    }
    if (value is! List) {
      return [];
    }
    final List<RouteStop> stops = [];
    for (final item in value) {
      try {
        if (item is Map<String, dynamic>) {
          stops.add(
            RouteStop.fromJson(item),
          );
        } else if (item is Map) {
          stops.add(
            RouteStop.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      } catch (e) {
        print(
          'RouteStop parsing error: $e',
        );
      }
    }
    return stops;
  }
  @override
  String toString() {
    return '''
Bus(
  busId: $busId,
  busNumber: $busNumber,
  status: $status,
  statusBanner: $statusBanner,
  speed: $speed,
  currentStop: $currentStop,
  nextStop: $nextStop,
  distanceToNextStop: $distanceToNextStop,
  boardingStop: $boardingStop,
  remainingDistanceToBoardingStop:  $remainingDistanceToBoardingStop,
  etaToBoardingStop:  $etaToBoardingStop,
  busArrivalTimeAtBoardingStop:$busArrivalTimeAtBoardingStop,
  destinationStop: $destinationStop,
  remainingDistanceToDestination: $remainingDistanceToDestination,
  etaToDestinationStop: $etaToDestinationStop,
  busArrivalTimeAtDestinationStop:  $busArrivalTimeAtDestinationStop,
  startingFrom: $startingFrom,
  departureTime: $departureTime,
  latitude: $latitude,
  longitude: $longitude,
  lastUpdated: $lastUpdated,
  routeStops: ${routeStops.length}
)
''';
  }
}