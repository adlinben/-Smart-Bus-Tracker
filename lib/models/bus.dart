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
      // -----------------------------------------
      // Bus identity
      // -----------------------------------------

      busId: _toString(json["busId"]),

      busNumber: _toString(json["busNumber"]),

      // -----------------------------------------
      // Status
      // -----------------------------------------

      status: _toString(json["status"]),

      statusBanner: _toString(json["statusBanner"]),

      // -----------------------------------------
      // Current bus information
      // -----------------------------------------

      speed: _toDouble(json["speed"]),

      currentStop: _toString(json["currentStop"]),

      nextStop: _toString(json["nextStop"]),

      distanceToNextStop:
      _toDouble(json["distanceToNextStop"]),

      // -----------------------------------------
      // Boarding stop
      // -----------------------------------------

      boardingStop:
      _toString(json["boardingStop"]),

      remainingDistanceToBoardingStop:
      _toDouble(
        json["remainingDistanceToBoardingStop"],
      ),

      /*
       * Backend:
       * boardingEta
       *
       * Flutter:
       * etaToBoardingStop
       */
      etaToBoardingStop:
      _toString(json["boardingEta"]),

      /*
       * Backend:
       * boardingArrival
       *
       * Flutter:
       * busArrivalTimeAtBoardingStop
       */
      busArrivalTimeAtBoardingStop:
      _toString(json["boardingArrival"]),

      // -----------------------------------------
      // Destination stop
      // -----------------------------------------

      destinationStop:
      _toString(json["destinationStop"]),

      /*
       * Backend:
       * destinationRemainingDistance
       *
       * Flutter:
       * remainingDistanceToDestination
       */
      remainingDistanceToDestination:
      _toDouble(
        json["destinationRemainingDistance"],
      ),

      /*
       * Backend:
       * destinationEta
       *
       * Flutter:
       * etaToDestinationStop
       */
      etaToDestinationStop:
      _toString(json["destinationEta"]),

      /*
       * Backend:
       * destinationArrival
       *
       * Flutter:
       * busArrivalTimeAtDestinationStop
       */
      busArrivalTimeAtDestinationStop:
      _toString(json["destinationArrival"]),

      // -----------------------------------------
      // Schedule
      // -----------------------------------------

      startingFrom:
      _toString(json["startingFrom"]),

      departureTime:
      _toString(json["departureTime"]),

      // -----------------------------------------
      // Location
      // -----------------------------------------

      latitude:
      _toDouble(json["latitude"]),

      longitude:
      _toDouble(json["longitude"]),

      // -----------------------------------------
      // Last updated
      // -----------------------------------------

      lastUpdated:
      _toString(json["lastUpdated"]),

      // -----------------------------------------
      // Route stops
      // -----------------------------------------

      routeStops:
      _parseRouteStops(json["routeStops"]),
    );
  }

  // ==========================================================
  // SAFE STRING CONVERSION
  // ==========================================================

  static String _toString(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString();
  }

  // ==========================================================
  // SAFE DOUBLE CONVERSION
  // ==========================================================

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

  // ==========================================================
  // SAFE ROUTE STOP PARSING
  // ==========================================================

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

  // ==========================================================
  // DEBUG STRING
  // ==========================================================

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
  remainingDistanceToBoardingStop:
      $remainingDistanceToBoardingStop,
  etaToBoardingStop:
      $etaToBoardingStop,
  busArrivalTimeAtBoardingStop:
      $busArrivalTimeAtBoardingStop,

  destinationStop:
      $destinationStop,
  remainingDistanceToDestination:
      $remainingDistanceToDestination,
  etaToDestinationStop:
      $etaToDestinationStop,
  busArrivalTimeAtDestinationStop:
      $busArrivalTimeAtDestinationStop,

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