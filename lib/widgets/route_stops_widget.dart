import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../theme/app_theme.dart';

class RouteStopsWidget extends StatelessWidget {
  final Bus bus;
  final bool isRunning;

  const RouteStopsWidget({
    super.key,
    required this.bus,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    if (bus.routeStops.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.route_outlined,
              size: 20,
              color: AppTheme.textMuted,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "No stop schedule details available.",
                style: TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bus.routeStops.length,
      itemBuilder: (context, index) {
        final stop = bus.routeStops[index];
        final bool isLast = index == bus.routeStops.length - 1;
        final bool isCurrent = stop.currentStop;
        final String etaText = stop.expectedArrivalText.trim();
        final bool isPassed = !isCurrent && etaText.toUpperCase() == "PASSED";
        final bool isFuture = !isCurrent && !isPassed;

        return _buildStop(
          stop: stop, index: index,
          isLast: isLast, isCurrent: isCurrent,
          isPassed: isPassed, isFuture: isFuture,
        );
      },
    );
  }
  Widget _buildStop({
    required dynamic stop,
    required int index,
    required bool isLast,
    required bool isCurrent,
    required bool isPassed,
    required bool isFuture,
  }) {
    final Color pointColor;
    if (isCurrent) {
      pointColor = AppTheme.running;
    } else if (isPassed) {
      pointColor = AppTheme.textMuted;
    } else {
      pointColor = AppTheme.primaryRed;
    }
    final String distanceText = stop.distanceAwayText.trim();
    final bool hasDistance = distanceText.isNotEmpty;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Container(
                  width: isCurrent ? 30 : 23, height: isCurrent ? 30 : 23,
                  decoration: BoxDecoration(
                    color: isCurrent ? pointColor.withOpacity(0.12) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: pointColor, width: isCurrent ? 2.5 : 2,
                    ),
                  ),
                  child: Icon(
                    isCurrent ? Icons.directions_bus_rounded : isPassed ? Icons.check_rounded : Icons.circle,
                    size: isCurrent ? 16 : isPassed ? 14 : 7,
                    color: pointColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2,
                      margin: const EdgeInsets.symmetric(
                        vertical: 3,
                      ),
                      color: isPassed ? AppTheme.textMuted.withOpacity(0.35) : isCurrent ? AppTheme.running.withOpacity(0.35) : AppTheme.primaryRed.withOpacity(0.18),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 18,
              ),
              child: Container(
                padding: isCurrent ? const EdgeInsets.all(11) : const EdgeInsets.symmetric(
                  vertical: 2,
                ),
                decoration: isCurrent
                    ? BoxDecoration(
                  color: AppTheme.runningLight,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: AppTheme.running.withOpacity(0.25),
                  ),
                )
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop.stopName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isCurrent ? 14 : 13,
                              fontWeight: isCurrent ? FontWeight.w800 : isPassed ? FontWeight.w500 : FontWeight.w700,
                              color: isCurrent ? AppTheme.running : isPassed ? AppTheme.textMuted : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStopStatus(
                              stop: stop,
                              isCurrent: isCurrent,
                              isPassed: isPassed,
                            ),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                              color: isCurrent ? AppTheme.running : isPassed ? AppTheme.textMuted : AppTheme.textSecondary,
                            ),
                          ),
                          if (isFuture && hasDistance) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.near_me_outlined,
                                  size: 12, color: AppTheme.textMuted,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    distanceText, maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    const TextStyle(
                                      fontSize: 10, color: AppTheme.textMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (isCurrent) ...[
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 7, height: 7,
                                  decoration:
                                  const BoxDecoration(
                                    color: AppTheme.running,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  "Bus is here",
                                  style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.running,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isFuture)
                      _etaBadge(
                        stop.expectedArrivalText,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  String _getStopStatus({
    required dynamic stop,
    required bool isCurrent,
    required bool isPassed,
  }) {
    if (isCurrent) {
      return "BUS IS HERE";
    }
    if (isPassed) {
      return "PASSED";
    }
    return "Expected arrival";
  }
  Widget _etaBadge(String eta) {
    final String value = eta.trim();
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8, vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppTheme.redLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppTheme.primaryRed,
        ),
      ),
    );
  }
}