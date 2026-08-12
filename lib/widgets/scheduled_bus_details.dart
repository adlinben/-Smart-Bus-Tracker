import 'package:flutter/material.dart';
import '../models/bus.dart';

class ScheduledBusDetails extends StatelessWidget {
  final Bus bus;
  const ScheduledBusDetails({
    super.key,
    required this.bus,
  });

  static const Color primaryRed = Color(0xFFC62828);
  static const Color lightRed = Color(0xFFFFEBEE);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11,
          ),
          decoration: BoxDecoration(
            color: lightRed,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryRed.withOpacity(0.12),
            ),
          ),
          child: Row(
            children: [
              Container(width: 34, height: 34,
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.10), shape: BoxShape.circle,),
                child: const Icon(
                  Icons.schedule_rounded, size: 19, color: primaryRed,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text("This bus has not started yet.",
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: primaryRed,),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text("Trip information",
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _detailRow("Starting from", bus.startingFrom,),
        _detailRow("Departure", bus.departureTime, valueColor: primaryRed,),
        const SizedBox(height: 5),
        const Divider(height: 1, color: borderColor,),
        const SizedBox(height: 16),
        const Text("Your journey",
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary,),
        ),
        const SizedBox(height: 10),
        _detailRow("Your stop", bus.boardingStop,),
        _detailRow("Expected arrival", bus.busArrivalTimeAtBoardingStop, valueColor: primaryRed,),
        const SizedBox(height: 5),
        const Divider(height: 1, color: borderColor,),
        const SizedBox(height: 16),
        const Text("Destination",
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary,),
        ),
        const SizedBox(height: 10),
        _detailRow("Stop", bus.destinationStop,),
        _detailRow("Expected arrival", bus.busArrivalTimeAtDestinationStop, valueColor: primaryRed,),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2, child: Text(
              label, style: const TextStyle(
                color: textSecondary, fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3, child: Text(
              value, textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: valueColor ?? textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}