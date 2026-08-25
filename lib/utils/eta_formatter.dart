String formatEta(String eta) {
  final minutes = int.tryParse(eta) ?? 0;

  if (minutes <= 0) {
    return "Arriving";
  }

  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  if (hours > 0 && remainingMinutes > 0) {
    return "$hours hr $remainingMinutes min";
  }

  if (hours > 0) {
    return "$hours hr";
  }

  return "$minutes min";
}