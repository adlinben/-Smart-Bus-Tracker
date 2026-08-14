import 'dart:async';
import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../repositories/bus_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/bus_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../repositories/notification_repository.dart';

class BusListScreen extends StatefulWidget {
  final String source;
  final String destination;
  final String time;

  const BusListScreen({
    super.key,
    required this.source,
    required this.destination,
    required this.time,
  });

  @override
  State<BusListScreen> createState() => _BusListScreenState();}

class _BusListScreenState extends State<BusListScreen> {
  final BusRepository _repository = BusRepository();
  List<Bus> buses = [];
  Timer? _refreshTimer;
  int selectedTab = 0;
  String? recommendedBusId;
  bool isLoading = true;
  bool isRefreshing = false;
  bool _requestInProgress = false;
  String? errorMessage;
  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();
    _loadBuses();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30), (_) {
      _loadBuses(silent: true);
    },
    );
  }
  Future<void> _loadBuses({
    bool silent = false,
  }) async {
    if (_requestInProgress) {
      return;
    }
    _requestInProgress = true;
    if (!silent && mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final result = await _repository.searchBuses(
        widget.source,
        widget.destination,
        widget.time,
      );
      if (!mounted) {
        return;
      }

      final sortedBuses = _sortBuses(result);
      final recommendedBus = _findRecommendedBus(sortedBuses,);

      setState(() {
        buses = sortedBuses;
        recommendedBusId = recommendedBus?.busId;
        isLoading = false;
        isRefreshing = false;
        errorMessage = null;
        lastUpdated = DateTime.now();
      });
    } catch (e) {
      debugPrint("Bus list error: $e");
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        isRefreshing = false;
        errorMessage = "Unable to load the latest bus data";
      });
    } finally {
      _requestInProgress = false;
    }
  }
  Future<void> _refresh() async {
    if (!mounted || _requestInProgress) {
      return;
    }

    setState(() {
      isRefreshing = true;
    });
    await _loadBuses(
      silent: true,
    );
  }
  String _normalizeStatus(String status) {
    return status
        .trim()
        .toUpperCase()
        .replaceAll("-", "_")
        .replaceAll(" ", "_");
  }
  bool _isRunning(Bus bus) {
    return _normalizeStatus(bus.status) == "RUNNING";}
  bool _isWaiting(Bus bus) {
    return _normalizeStatus(bus.status).contains("WAITING");}
  bool _isScheduled(Bus bus) {
    final status = _normalizeStatus(bus.status);
    return status == "SCHEDULED" || status == "UPCOMING";
  }
  List<Bus> _sortBuses(List<Bus> source) {
    final requestedMinutes = _timeToMinutes(widget.time,);
    final sorted = List<Bus>.from(source);
    sorted.sort((a, b) {
      final aTime = _timeToMinutes(a.busArrivalTimeAtBoardingStop,);
      final bTime = _timeToMinutes(b.busArrivalTimeAtBoardingStop,);
      final aIsSuitable = aTime >= requestedMinutes;
      final bIsSuitable = bTime >= requestedMinutes;

      if (aIsSuitable != bIsSuitable) {
        return aIsSuitable ? -1 : 1;
      }
      if (aIsSuitable && bIsSuitable) {
        return aTime.compareTo(bTime);
      }
      return bTime.compareTo(aTime);
    });
    return sorted;
  }
  Bus? _findRecommendedBus(List<Bus> buses) {
    if (buses.isEmpty) {
      return null;
    }
    final requestedMinutes = _timeToMinutes(widget.time,);
    final suitableBuses = buses.where((bus) {
      final arrivalMinutes = _timeToMinutes(bus.busArrivalTimeAtBoardingStop,);
      return arrivalMinutes >= requestedMinutes;
    }).toList();
    if (suitableBuses.isEmpty) {
      return null;
    }
    suitableBuses.sort((a, b) {
      final aArrival = _timeToMinutes(a.busArrivalTimeAtBoardingStop,);
      final bArrival = _timeToMinutes(b.busArrivalTimeAtBoardingStop,);
      final aDifference = aArrival - requestedMinutes;
      final bDifference = bArrival - requestedMinutes;
      return aDifference.compareTo(bDifference,
      );
    });
    return suitableBuses.first;
  }
  int _timeToMinutes(String time) {
    try {
      String value = time.trim().toUpperCase();
      if (value.isEmpty) {
        return 24 * 60;
      }
      final bool isPm = value.contains("PM");
      final bool isAm = value.contains("AM");
      value = value
          .replaceAll("AM", "")
          .replaceAll("PM", "")
          .trim();

      final parts = value.split(":");
      if (parts.isEmpty) {
        return 24 * 60;
      }
      int hour = int.parse(
        parts[0].trim(),
      );
      int minute = 0;
      if (parts.length > 1) {
        minute = int.parse(parts[1].trim(),);
      }
      if (hour < 0 || hour > 23) {
        return 24 * 60;
      }
      if (minute < 0 || minute > 59) {
        return 24 * 60;
      }
      if (isPm && hour < 12) {
        hour += 12;
      }
      if (isAm && hour == 12) {
        hour = 0;
      }
      return hour * 60 + minute;
    } catch (_) {
      return 24 * 60;
    }
  }
  String _formatLastUpdated() {
    if (lastUpdated == null) {
      return "Not updated yet";
    }
    final hour = lastUpdated!.hour;
    final minute = lastUpdated!.minute;
    final displayHour = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
    final period = hour >= 12 ? "PM" : "AM";
    return "${displayHour.toString()}:""${minute.toString().padLeft(2, '0')} ""$period";
  }
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final runningBuses = buses.where(_isRunning).toList();
    final waitingBuses = buses.where(_isWaiting).toList();
    final scheduledBuses = buses.where(_isScheduled).toList();
    final List<Bus> displayedBuses;
    switch (selectedTab) {
      case 0:
        displayedBuses = runningBuses;
        break;
      case 1:
        displayedBuses = waitingBuses;
        break;
      case 2:
        displayedBuses = scheduledBuses;
        break;
      default:
        displayedBuses = runningBuses;
    }
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryRed, foregroundColor: Colors.white, elevation: 0,
        title: const Text("Available Buses",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,),
        ),
        actions: [
          if (isRefreshing)
            const Padding(
              padding: EdgeInsets.only(right: 16,),
              child: SizedBox(
                width: 17, height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildJourneyHeader(),
          const SizedBox(height: 6,),
          _buildFilterTabs(
            runningCount: runningBuses.length,
            waitingCount: waitingBuses.length,
            scheduledCount: scheduledBuses.length,
          ),
          const SizedBox(height: 2,),
          _buildLastUpdated(),
          const SizedBox(height: 2,),
          Expanded(
            child: _buildContent(displayedBuses,),
          ),
        ],
      ),
    );
  }
  Widget _buildJourneyHeader() {
    return Container(
      width: double.infinity, color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 15,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("YOUR JOURNEY",
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.7, color: AppTheme.textMuted,),
          ),
          const SizedBox(height: 9,),
          Row(
            children: [
              Expanded(
                child: _journeyPoint(icon: Icons.radio_button_checked, value: widget.source, color: AppTheme.primaryRed,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8,),
                child: Icon(
                  Icons.arrow_forward_rounded, size: 18, color: AppTheme.primaryRed,
                ),
              ),
              Expanded(
                child: _journeyPoint(icon: Icons.location_on_rounded, value: widget.destination, color: AppTheme.primaryRed, alignRight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11,),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9, vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.redLight, borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_rounded, size: 14, color: AppTheme.primaryRed,
                ),
                const SizedBox(width: 5,),
                Text(
                  "Boarding Around: ${widget.time}",
                  style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _journeyPoint({
    required IconData icon,
    required String value,
    required Color color,
    bool alignRight = false,
  }) {
    return Row(
      mainAxisAlignment: alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!alignRight)
          Icon(icon, size: 14, color: color,
          ),
        if (!alignRight)
          const SizedBox(width: 5,),
        Flexible(
          child: Text(
            value, maxLines: 2, overflow: TextOverflow.ellipsis,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary,
            ),
          ),
        ),
        if (alignRight)
          const SizedBox(width: 5,),
        if (alignRight)
          Icon(icon, size: 14, color: color,
          ),
      ],
    );
  }
  Widget _buildFilterTabs({
    required int runningCount,
    required int waitingCount,
    required int scheduledCount,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 5, 12, 8,),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              title: "Running",
              count: runningCount, icon: Icons.directions_bus_rounded, color: AppTheme.running, index: 0,
            ),
          ),
          const SizedBox(width: 7,),
          Expanded(
            child: _buildTab(
              title: "Waiting",
              count: waitingCount, icon: Icons.pause_circle_outline_rounded, color: AppTheme.waiting, index: 1,
            ),
          ),
          const SizedBox(width: 7,),
          Expanded(
            child: _buildTab(
              title: "Upcoming", count: scheduledCount, icon: Icons.schedule_rounded, color: AppTheme.scheduled, index: 2,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTab({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    final bool selected =
        selectedTab == index;
    return GestureDetector(
      onTap: () {
        if (selected) {
          return;
        }
        setState(() {
          selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 5, vertical: 9,),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : AppTheme.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color.withOpacity(0.35) : AppTheme.border,),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, size: 15, color: selected ? color : AppTheme.textSecondary,
            ),
            const SizedBox(width: 4,),
            Flexible(
              child: Text(
                title, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: selected ? color : AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 4,),
            Container(
              constraints: const BoxConstraints(minWidth: 20,),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 5, vertical: 2,
              ),
              decoration: BoxDecoration(
                color: selected ? color.withOpacity(0.12) : AppTheme.border,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w800, color: selected ? color : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLastUpdated() {
    final bool hasUpdated =
        lastUpdated != null;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 6,),
      child: Row(
        children: [
          Container(width: 7, height: 7,
            decoration: BoxDecoration(
              color: hasUpdated ? AppTheme.running : AppTheme.textMuted,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6,),
          Text(
            hasUpdated ? "Live data" : "Waiting for data",
            style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 6,),
          Container(width: 3, height: 3,
            decoration:
            const BoxDecoration(
              color: AppTheme.textMuted, shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6,),
          Text(
            hasUpdated ? "Updated ${_formatLastUpdated()}" : "Not updated yet",
            style: const TextStyle(
              fontSize: 10, color: AppTheme.textMuted,
            ),
          ),
          const Spacer(),
          if (isRefreshing)
            const SizedBox(
              width: 12, height: 12,
              child:
              CircularProgressIndicator(
                strokeWidth: 1.5, color: AppTheme.primaryRed,
              ),
            )
          else
            const Icon(
              Icons.sync_rounded, size: 13, color: AppTheme.textMuted,
            ),
        ],
      ),
    );
  }
  Widget _buildContent(
      List<Bus> displayedBuses,
      ) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryRed,
        ),
      );
    }
    if (errorMessage != null &&
        buses.isEmpty) {
      return _buildErrorState();
    }
    if (displayedBuses.isEmpty) {
      return RefreshIndicator(
        color: AppTheme.primaryRed, onRefresh: _refresh,
        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 380, child: _buildEmptyState(),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: AppTheme.primaryRed, onRefresh: _refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 5, bottom: 20,),
        itemCount: displayedBuses.length,
        itemBuilder: (context, index) {
          final bus = displayedBuses[index];
          return BusCard(
            bus: bus,
            recommended: bus.busId == recommendedBusId,
            onBusSelected: registerSelectedBus,
          );
        },
      ),
    );
  }
  Widget _buildEmptyState() {
    String title;
    String subtitle;
    IconData icon;
    if (selectedTab == 0) {
      title = "No buses running right now";
      subtitle = "Try checking Waiting or Upcoming buses.";
      icon = Icons.directions_bus_outlined;
    } else if (selectedTab == 1) {
      title = "No buses are waiting";
      subtitle = "There are currently no buses waiting at a stop.";
      icon = Icons.pause_circle_outline_rounded;
    } else {
      title = "No upcoming buses";
      subtitle = "No suitable upcoming buses were found for your selected time.";
      icon = Icons.schedule_rounded;
    }
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 35,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76, height: 76,
              decoration: const BoxDecoration(
                color: AppTheme.redLight, shape: BoxShape.circle,
              ),
              child: Icon(
                icon, size: 34, color: AppTheme.primaryRed,
              ),
            ),
            const SizedBox(height: 17,),
            Text(
              title, textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary,),
            ),
            const SizedBox(height: 6,),
            Text(
              subtitle, textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12, height: 1.4, color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70, height: 70,
              decoration: const BoxDecoration(
                color: AppTheme.redLight, shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded, size: 32, color: AppTheme.primaryRed,
              ),
            ),
            const SizedBox(height: 15,),
            const Text("Couldn't load buses",
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6,),
            Text(
              errorMessage ?? "Please try again.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 18,),
            SizedBox(height: 42,
              child: ElevatedButton(
                onPressed: () {_loadBuses();},
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22,),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10,),
                  ),
                ),
                child: const Text("Try again",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> registerSelectedBus(Bus bus) async {
    try {
      final token =
      await FirebaseMessaging.instance.getToken();

      if (token == null || token.isEmpty) {
        debugPrint("FCM token not available");
        return;
      }

      final repository = NotificationRepository();

      await repository.registerBusNotification(
        deviceToken: token,
        busId: bus.busId,
        boardingStop: bus.boardingStop,
        destinationStop: bus.destinationStop,
      );

      debugPrint(
        "Registered for bus: ${bus.busId}",
      );
    } catch (e) {
      debugPrint(
        "Bus notification registration failed: $e",
      );
    }
  }
}