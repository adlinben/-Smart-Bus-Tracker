class RouteStop {
  final String stopName;
  final double remainingDistance;
  final int eta;

  const RouteStop({
    required this.stopName,
    required this.remainingDistance,
    required this.eta,
  });

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      stopName: _toString(json['stopName']),
      remainingDistance: _toDouble(json['remainingDistance']),
      eta: _toInt(json['eta']),
    );
  }
  String get expectedArrivalText {
    if (eta <= 0) {
      return '';
    }
    return _formatEta(eta);
  }
  String get distanceAwayText {
    if (remainingDistance <= 0) {
      return '';
    }
    return '${remainingDistance.toStringAsFixed(1)} km';
  }
  String get stopId => '';
  int get stopOrder => 0;
  bool get currentStop => false;
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
      return double.tryParse(value.trim()) ?? 0.0;
    }
    return 0.0;
  }
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
      return int.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }
  static String _formatEta(int eta) {
    if (eta <= 0) {
      return '';
    }
    final int hours = eta ~/ 60;
    final int minutes = eta % 60;
    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    }
    return '${minutes} min';
  }
  String get etaText {
    return expectedArrivalText;
  }
  String get remainingDistanceText {
    return distanceAwayText;
  }
  @override
  String toString() {
    return '''
RouteStop(
  stopName: $stopName,
  remainingDistance: $remainingDistance,
  eta: $eta
)
''';
  }
}