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
              Icons.route_outlined, size: 20, color: AppTheme.textMuted,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "No stop schedule details available.",
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
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
        final String etaValue = stop.eta.trim().toUpperCase();
        final bool isCurrent = etaValue == "CURRENT";
        final bool isPassed = etaValue == "PASSED";
        final bool isFuture = !isCurrent && !isPassed;

        return _buildStop(
          stop: stop,
          index: index,
          isLast: isLast,
          isCurrent: isCurrent,
          isPassed: isPassed,
          isFuture: isFuture,
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

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: isCurrent ? 28 : 22,
                  height: isCurrent ? 28 : 22,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? pointColor.withOpacity(0.12)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: pointColor,
                      width: isCurrent ? 2.5 : 2,
                    ),
                  ),
                  child: Icon(
                    isCurrent
                        ? Icons.directions_bus_rounded
                        : isPassed
                        ? Icons.check_rounded
                        : Icons.circle,
                    size: isCurrent
                        ? 15
                        : isPassed
                        ? 13
                        : 7,
                    color: pointColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(
                        vertical: 3,
                      ),
                      color: isPassed
                          ? AppTheme.textMuted.withOpacity(0.35)
                          : AppTheme.primaryRed.withOpacity(0.18),
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
                padding: isCurrent
                    ? const EdgeInsets.all(11)
                    : const EdgeInsets.symmetric(
                  vertical: 2,
                ),
                decoration: isCurrent
                    ? BoxDecoration(
                  color: AppTheme.runningLight,
                  borderRadius:
                  BorderRadius.circular(11),
                  border: Border.all(
                    color: AppTheme.running
                        .withOpacity(0.15),
                  ),
                )
                    : null,
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop.stopName,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isCurrent
                                  ? 14
                                  : 13,
                              fontWeight: isCurrent
                                  ? FontWeight.w800
                                  : isPassed
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: isPassed
                                  ? AppTheme.textMuted
                                  : isCurrent
                                  ? AppTheme.running
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _getStopStatus(stop.eta),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isCurrent
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isCurrent
                                  ? AppTheme.running
                                  : isPassed
                                  ? AppTheme.textMuted
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          if (!isPassed && stop.remainingDistance > 0) ...[
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  Icons.near_me_outlined,
                                  size: 12, color: AppTheme.textMuted,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  "${stop.remainingDistance} km away",
                                  style:
                                  const TextStyle(
                                    fontSize: 10, color: AppTheme.textMuted,
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
                        stop.eta,
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
  Widget _etaBadge(String eta) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppTheme.redLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        eta, style: const TextStyle(
          fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.primaryRed,
        ),
      ),
    );
  }
  String _getStopStatus(String eta) {
    final value = eta.trim().toUpperCase();
    if (value == "CURRENT") {
      return "Bus is here";
    }
    if (value == "PASSED") {
      return "Passed";
    }
    return "Expected arrival";
  }
}