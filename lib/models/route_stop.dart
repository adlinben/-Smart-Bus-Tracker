class RouteStop {

  final String stopName;
  final double remainingDistance;
  final String eta;
  RouteStop({
    required this.stopName,
    required this.remainingDistance,
    required this.eta,
  });

  factory RouteStop.fromJson(Map<String,dynamic> json){
    return RouteStop(
      stopName: json["stopName"] ?? "",
      remainingDistance:
      (json["remainingDistance"] as num?)?.toDouble() ?? 0.0,

      eta: json["eta"] ?? "",

    );
  }
}