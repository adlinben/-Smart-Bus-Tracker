import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../utils/eta_formatter.dart';

class RunningBusDetails extends StatelessWidget {
  final Bus bus;

  const RunningBusDetails({
    super.key,
    required this.bus,
  });

  static const Color primaryRed = Color(0xFFC62828);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final bool isWaiting =
    bus.status.toUpperCase().contains("WAITING");

    final Color statusColor =
    isWaiting ? Colors.orange : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isWaiting
                      ? Icons.pause_circle_outline_rounded
                      : Icons.directions_bus_rounded,
                  size: 19,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isWaiting
                      ? "Bus is waiting at ${bus.currentStop}"
                      : "Bus is currently near ${bus.currentStop}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isWaiting
                        ? Colors.orange.shade800
                        : Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          "Live status",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        _detailRow(
          "Current stop",
          bus.currentStop,
        ),

        _detailRow(
          "Next stop",
          bus.nextStop,
        ),

        _detailRow(
          "Speed",
          "${bus.speed.toStringAsFixed(1)} km/hr",
        ),

        _detailRow(
          "Distance to next stop",
          "${bus.distanceToNextStop.toStringAsFixed(1)} km",
        ),

        const SizedBox(height: 5),

        const Divider(
          height: 1,
          color: borderColor,
        ),

        const SizedBox(height: 16),
        const Text(
          "Your boarding stop",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        _detailRow(
          "Stop",
          bus.boardingStop,
        ),
        _detailRow(
          "ETA",
          formatEta(bus.etaToBoardingStop),
          valueColor: primaryRed,
        ),
        _detailRow(
          "Arrival",
          bus.busArrivalTimeAtBoardingStop,
          valueColor: primaryRed,
        ),

        const SizedBox(height: 5),

        const Divider(
          height: 1,
          color: borderColor,
        ),

        const SizedBox(height: 16),
        const Text(
          "Destination",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),

        const SizedBox(height: 10),

        _detailRow(
          "Stop",
          bus.destinationStop,
        ),
        _detailRow(
          "ETA",
          formatEta(bus.etaToDestinationStop),
          valueColor: primaryRed,
        ),

        _detailRow(
          "Arrival",
          bus.busArrivalTimeAtDestinationStop,
          valueColor: primaryRed,
        ),
      ],
    );
  }

  Widget _detailRow(
      String label,
      String value, {
        Color? valueColor,
      }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: textSecondary,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: valueColor ?? textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}