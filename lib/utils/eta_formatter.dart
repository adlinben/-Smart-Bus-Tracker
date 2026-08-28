String formatEta(String eta) {
  if (eta.trim().isEmpty) {
    return "--";
  }

  final int? minutes = int.tryParse(eta.trim());

  if (minutes == null) {
    return eta;
  }

  if (minutes <= 0) {
    return "Arriving";
  }

  if (minutes < 60) {
    return "$minutes min";
  }

  final int hours = minutes ~/ 60;
  final int remainingMinutes = minutes % 60;

  if (remainingMinutes == 0) {
    return hours == 1
        ? "1 hr"
        : "$hours hrs";
  }

  return hours == 1
      ? "1 hr $remainingMinutes min"
      : "$hours hrs $remainingMinutes min";
}