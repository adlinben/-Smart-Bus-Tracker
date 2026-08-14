class RouteStop {
  final String stopId;
  final String stopName;
  final int stopOrder;

  final String expectedArrivalText;
  final String distanceAwayText;

  final bool currentStop;

  const RouteStop({
    required this.stopId,
    required this.stopName,
    required this.stopOrder,
    required this.expectedArrivalText,
    required this.distanceAwayText,
    required this.currentStop,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      stopId: json['stopId']?.toString() ?? '',

      stopName: json['stopName']?.toString() ?? '',

      stopOrder: _toInt(
        json['stopOrder'],
      ),

      expectedArrivalText:
      json['expectedArrivalText']?.toString() ?? '',

      distanceAwayText:
      json['distanceAwayText']?.toString() ?? '',

      currentStop:
      _toBool(json['currentStop']),
    );
  }

  // ------------------------------------------------------------
  // Compatibility getter
  // ------------------------------------------------------------
  // If another widget uses stop.eta,
  // it will receive expectedArrivalText.
  String get eta => expectedArrivalText;

  // ------------------------------------------------------------
  // Convert number safely
  // ------------------------------------------------------------

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  // ------------------------------------------------------------
  // Convert boolean safely
  // ------------------------------------------------------------

  static bool _toBool(dynamic value) {
    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.trim().toLowerCase() == 'true';
    }

    return false;
  }

  @override
  String toString() {
    return '''
RouteStop(
  stopId: $stopId,
  stopName: $stopName,
  stopOrder: $stopOrder,
  expectedArrivalText: $expectedArrivalText,
  distanceAwayText: $distanceAwayText,
  currentStop: $currentStop
)
''';
  }
}