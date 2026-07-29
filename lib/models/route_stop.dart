class RouteStop {

  final String stopName;
  final double distance;
  RouteStop({
    required this.stopName,
    required this.distance,
  });
  factory RouteStop.fromJson(Map<String,dynamic> json){
    return RouteStop(
      stopName: json['stopName'] ?? "",
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}