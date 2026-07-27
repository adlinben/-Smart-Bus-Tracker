class RouteStop {
  final String stopName;
  final double distanceFromPrevious;

  RouteStop({required this.stopName, required this.distanceFromPrevious});
  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      stopName: json["stopName"],
      distanceFromPrevious: (json["distanceFromPrevious"] as num).toDouble(),
    );
  }
}
