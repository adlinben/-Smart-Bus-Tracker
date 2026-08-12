import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../screens/bus_details_screen.dart';
import '../theme/app_theme.dart';

class BusCard extends StatelessWidget {
  final Bus bus;
  final bool recommended;

  const BusCard({
    super.key,
    required this.bus,
    this.recommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = bus.status.toUpperCase();
    final bool isRunning = status == "RUNNING";
    final bool isWaiting = status.contains("WAITING");
    final bool isScheduled = status == "SCHEDULED";

    final Color statusColor = isRunning
        ? AppTheme.running
        : isWaiting
        ? AppTheme.waiting
        : AppTheme.scheduled;

    final Color statusLight = isRunning
        ? AppTheme.runningLight
        : isWaiting
        ? AppTheme.waitingLight
        : AppTheme.scheduledLight;

    final String statusText = isRunning
        ? "RUNNING"
        : isWaiting
        ? "WAITING"
        : "UPCOMING";

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: recommended
              ? AppTheme.primaryRed.withOpacity(0.35)
              : AppTheme.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BusDetailsScreen(bus: bus),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (recommended) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRedLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppTheme.primaryRed,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "RECOMMENDED FOR YOU",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: statusLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_bus_rounded,
                      color: statusColor,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          bus.busNumber,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          bus.destinationStop,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(
                    statusText,
                    statusColor,
                    statusLight,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (isRunning || isWaiting)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isWaiting
                            ? Icons.pause_circle_outline
                            : Icons.location_on_outlined,
                        size: 19,
                        color: statusColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              isWaiting
                                  ? "Waiting at"
                                  : "Currently near",
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bus.currentStop,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (isRunning || isWaiting)
                const SizedBox(height: 13),
              _etaBox(
                title: "YOUR BOARDING STOP",
                stopName: bus.boardingStop,
                time: bus.busArrivalTimeAtBoardingStop,
                color: AppTheme.primaryRed,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.flag_outlined,
                    size: 17,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      bus.destinationStop,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    bus.busArrivalTimeAtDestinationStop,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              if (isScheduled) ...[
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.departure_board_outlined,
                      size: 17,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 7),
                    const Expanded(
                      child: Text(
                        "Departure",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      bus.departureTime,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              const Divider(
                height: 1,
                color: AppTheme.border,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "View details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: statusColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _statusBadge(
      String text,
      Color color,
      Color background,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6,
            decoration: BoxDecoration(
              color: color, shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  Widget _etaBox({
    required String title,
    required String stopName,
    required String time,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.055),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: 17, color: color,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stopName,
                  style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 14,
              fontWeight: FontWeight.w800, color: color,
            ),
          ),
        ],
      ),
    );
  }
}