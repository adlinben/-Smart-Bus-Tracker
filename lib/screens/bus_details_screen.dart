import 'dart:async';
import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../repositories/bus_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/running_bus_details.dart';
import '../widgets/scheduled_bus_details.dart';
import '../widgets/route_stops_widget.dart';
import 'map_screen.dart';
import '../repositories/notification_repository.dart';
import '../services/notification_service.dart';
import '../utils/eta_formatter.dart';

class BusDetailsScreen extends StatefulWidget {
  final Bus bus;

  const BusDetailsScreen({
    super.key,
    required this.bus,
  });

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  final BusRepository _repository = BusRepository();

  final NotificationRepository _notificationRepository =
  NotificationRepository();

  late Bus bus;

  Timer? _timer;

  bool _notificationsEnabled = false;
  bool _notificationLoading = false;

  @override
  void initState() {
    super.initState();

    bus = widget.bus;

    _loadBus();

    _timer = Timer.periodic(
      const Duration(seconds: 30),
          (_) => _loadBus(),
    );
  }

  Future<void> _loadBus() async {
    try {
      final buses = await _repository.searchBuses(
        bus.boardingStop,
        bus.destinationStop,
        bus.departureTime,
      );

      final updatedBus = buses.firstWhere(
            (b) => b.busId == bus.busId,
        orElse: () => bus,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        bus = updatedBus;
      });
    } catch (e) {
      debugPrint(
        "Bus details refresh error: $e",
      );
    }
  }

  Future<void> _subscribeToBus() async {
    if (_notificationLoading) {
      return;
    }

    setState(() {
      _notificationLoading = true;
    });

    try {
      final String? token =
      await NotificationService.getFcmToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          "FCM token is not available.",
        );
      }

      await _notificationRepository.registerBusNotification(
        deviceToken: token,
        busId: bus.busId,
        boardingStop: bus.boardingStop,
        destinationStop: bus.destinationStop,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _notificationsEnabled = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Notifications enabled for this bus.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not enable notifications: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _notificationLoading = false;
        });
      }
    }
  }

  Future<void> _unsubscribeFromBus() async {
    if (_notificationLoading) {
      return;
    }

    setState(() {
      _notificationLoading = true;
    });

    try {
      final String? token =
      await NotificationService.getFcmToken();

      if (token == null || token.isEmpty) {
        throw Exception(
          "FCM token is not available.",
        );
      }

      await _notificationRepository.unsubscribeFromBus(
        deviceToken: token,
        busId: bus.busId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _notificationsEnabled = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Notifications stopped for this bus.",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not unsubscribe: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _notificationLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = bus.status.toUpperCase();

    final bool isRunning =
        status == "RUNNING";

    final bool isWaiting =
    status.contains("WAITING");

    final bool isScheduled =
        status == "SCHEDULED" ||
            status == "UPCOMING";

    final Color statusColor = isRunning
        ? AppTheme.running
        : isWaiting
        ? AppTheme.waiting
        : AppTheme.scheduled;

    final Color statusBackground = isRunning
        ? AppTheme.runningLight
        : isWaiting
        ? AppTheme.waitingLight
        : AppTheme.scheduledLight;

    final String displayStatus = isRunning
        ? "RUNNING NOW"
        : isWaiting
        ? "WAITING AT STOP"
        : "UPCOMING";

    final bool hasLiveLocation =
        (isRunning || isWaiting) &&
            bus.latitude != 0 &&
            bus.longitude != 0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "Bus Details",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryRed,
        onRefresh: _loadBus,
        child: SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding:
          const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              _buildBusHeader(
                statusColor: statusColor,
                statusBackground:
                statusBackground,
                displayStatus:
                displayStatus,
              ),

              const SizedBox(height: 10),

              _buildQuickEtaCard(
                statusColor: statusColor,
                isRunning: isRunning,
                isWaiting: isWaiting,
                isScheduled: isScheduled,
              ),

              const SizedBox(height: 10),

              _buildNotificationButton(),

              const SizedBox(height: 10),

              _section(
                title: isScheduled
                    ? "Trip Information"
                    : "Live Information",
                icon: isScheduled
                    ? Icons.info_outline_rounded
                    : Icons.my_location_rounded,
                child: isScheduled
                    ? ScheduledBusDetails(
                  bus: bus,
                )
                    : RunningBusDetails(
                  bus: bus,
                ),
              ),

              const SizedBox(height: 10),

              _section(
                title: "Route",
                icon: Icons.route_rounded,
                child: RouteStopsWidget(
                  bus: bus,
                  isRunning:
                  isRunning || isWaiting,
                ),
              ),

              const SizedBox(height: 10),

              if (hasLiveLocation)
                _buildMapButton(context),

              if (hasLiveLocation)
                const SizedBox(height: 10),

              _buildLastUpdated(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusHeader({
    required Color statusColor,
    required Color statusBackground,
    required String displayStatus,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.directions_bus_rounded,
                  size: 29,
                  color: statusColor,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.busNumber,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.w800,
                        color:
                        AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      bus.startingFrom.isEmpty
                          ? "Bus service"
                          : bus.startingFrom,
                      style: const TextStyle(
                        fontSize: 12,
                        color:
                        AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    if (displayStatus ==
                        "RUNNING NOW")
                      Container(
                        width: 7,
                        height: 7,
                        decoration:
                        const BoxDecoration(
                          color:
                          AppTheme.running,
                          shape:
                          BoxShape.circle,
                        ),
                      ),

                    if (displayStatus ==
                        "RUNNING NOW")
                      const SizedBox(width: 5),

                    Text(
                      displayStatus,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight:
                        FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _routePoint(
                  label: "BOARDING",
                  value: bus.boardingStop,
                ),
              ),

              const Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 19,
                  color:
                  AppTheme.primaryRed,
                ),
              ),

              Expanded(
                child: _routePoint(
                  label: "DESTINATION",
                  value:
                  bus.destinationStop,
                  alignRight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _routePoint({
    required String label,
    required String value,
    bool alignRight = false,
  }) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppTheme.textMuted,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          maxLines: 2,
          overflow:
          TextOverflow.ellipsis,
          textAlign: alignRight
              ? TextAlign.right
              : TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickEtaCard({
    required Color statusColor,
    required bool isRunning,
    required bool isWaiting,
    required bool isScheduled,
  }) {
    String title;
    String subtitle;
    String time;
    IconData icon;

    if (isRunning || isWaiting) {
      title = "Your bus arrival";
      subtitle = bus.boardingStop;
      time =
          bus.busArrivalTimeAtBoardingStop;
      icon =
          Icons.access_time_filled_rounded;
    } else {
      title = "Expected boarding";
      subtitle = bus.boardingStop;
      time =
          bus.busArrivalTimeAtBoardingStop;
      icon = Icons.schedule_rounded;
    }

    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
              statusColor.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: statusColor,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              const Text(
                "ARRIVAL",
                style: TextStyle(
                  fontSize: 8,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  AppTheme.textMuted,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                time,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w800,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Arrives in ${formatEta(bus.etaToBoardingStop)}",
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _notificationLoading
            ? null
            : _notificationsEnabled
            ? _unsubscribeFromBus
            : _subscribeToBus,
        icon: Icon(
          _notificationsEnabled
              ? Icons.notifications_off_rounded
              : Icons.notifications_none_rounded,
          size: 20,
        ),
        label: Text(
          _notificationLoading
              ? _notificationsEnabled
              ? "Stopping notifications..."
              : "Enabling notifications..."
              : _notificationsEnabled
              ? "Unsubscribe from notifications"
              : "Notify me about this bus",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          _notificationsEnabled
              ? AppTheme.textSecondary
              : AppTheme.primaryRed,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          AppTheme.textMuted,
          elevation: 0,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding:
      const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        18,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: AppTheme.primaryRed,
              ),

              const SizedBox(width: 7),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight:
                  FontWeight.w800,
                  color:
                  AppTheme.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  Widget _buildMapButton(
      BuildContext context,
      ) {
    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.location_on_rounded,
          size: 20,
        ),
        label: const Text(
          "View Live Location",
          style: TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          AppTheme.primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MapScreen(bus: bus),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sync_rounded,
            size: 14,
            color: AppTheme.textMuted,
          ),

          const SizedBox(width: 5),

          Text(
            "Last updated: ${bus.lastUpdated}",
            style: const TextStyle(
              fontSize: 10,
              color:
              AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}