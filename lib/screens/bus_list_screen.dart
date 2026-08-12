import 'dart:async';

import 'package:flutter/material.dart';

import '../models/bus.dart';
import '../repositories/bus_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/bus_card.dart';

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
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  final BusRepository _repository = BusRepository();

  List<Bus> buses = [];

  Timer? _timer;

  int selectedTab = 0;

  bool isLoading = true;
  bool isRefreshing = false;

  String? errorMessage;

  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();

    _loadBuses();

    // Automatically refresh every 5 minutes.
    _timer = Timer.periodic(
      const Duration(minutes: 5),
          (_) => _loadBuses(silent: true),
    );
  }

  // ============================================================
  // LOAD BUSES
  // ============================================================

  Future<void> _loadBuses({
    bool silent = false,
  }) async {
    if (!silent && mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final data = await _repository.searchBuses(
        widget.source,
        widget.destination,
        widget.time,
      );

      if (!mounted) return;

      setState(() {
        buses = _sortBusesByBoardingTime(data);
        isLoading = false;
        isRefreshing = false;
        errorMessage = null;

        // Store the time of the latest successful API update.
        lastUpdated = DateTime.now();
      });
    } catch (e) {
      debugPrint("Bus list error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isRefreshing = false;
        errorMessage = "Unable to load buses";
      });
    }
  }

  // ============================================================
  // PULL TO REFRESH
  // ============================================================

  Future<void> _refresh() async {
    if (!mounted) return;

    setState(() {
      isRefreshing = true;
    });

    await _loadBuses(silent: true);
  }

  // ============================================================
  // FORMAT LAST UPDATED TIME
  // ============================================================

  String _formatLastUpdated() {
    if (lastUpdated == null) {
      return "Not updated yet";
    }

    final hour = lastUpdated!.hour;
    final minute = lastUpdated!.minute;

    final displayHour =
    hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;

    final period = hour >= 12 ? "PM" : "AM";

    return "${displayHour.toString()}:"
        "${minute.toString().padLeft(2, '0')} $period";
  }
  List<Bus> _sortBusesByBoardingTime(List<Bus> buses) {
    final requestedMinutes = _timeToMinutes(widget.time);

    final sorted = List<Bus>.from(buses);

    sorted.sort((a, b) {
      final aMinutes =
      _timeToMinutes(a.busArrivalTimeAtBoardingStop);

      final bMinutes =
      _timeToMinutes(b.busArrivalTimeAtBoardingStop);

      // Prefer buses that have not yet arrived.
      final aAfter = aMinutes >= requestedMinutes;
      final bAfter = bMinutes >= requestedMinutes;

      if (aAfter != bAfter) {
        return aAfter ? -1 : 1;
      }

      // Within the same group, choose the closest time.
      final aDifference =
      (aMinutes - requestedMinutes).abs();

      final bDifference =
      (bMinutes - requestedMinutes).abs();

      return aDifference.compareTo(bDifference);
    });

    return sorted;
  }
  int _timeToMinutes(String time) {
    try {
      final value = time.trim().toUpperCase();

      final isPm = value.contains("PM");
      final isAm = value.contains("AM");

      final cleaned = value
          .replaceAll("AM", "")
          .replaceAll("PM", "")
          .trim();

      final parts = cleaned.split(":");

      int hour = int.parse(parts[0]);
      final minute = parts.length > 1
          ? int.parse(parts[1])
          : 0;

      if (isPm && hour != 12) {
        hour += 12;
      }

      if (isAm && hour == 12) {
        hour = 0;
      }

      return hour * 60 + minute;
    } catch (_) {
      // If the time cannot be parsed, put it at the end.
      return 24 * 60;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final runningBuses = buses
        .where(
          (bus) =>
      bus.status.toUpperCase() == "RUNNING",
    )
        .toList();

    final waitingBuses = buses
        .where(
          (bus) =>
          bus.status.toUpperCase().contains("WAITING"),
    )
        .toList();

    final scheduledBuses = buses
        .where(
          (bus) =>
      bus.status.toUpperCase() == "SCHEDULED",
    )
        .toList();

    final List<Bus> displayedBuses;

    if (selectedTab == 0) {
      displayedBuses = runningBuses;
    } else if (selectedTab == 1) {
      displayedBuses = waitingBuses;
    } else {
      displayedBuses = scheduledBuses;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Available Buses",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          if (isRefreshing)
            const Padding(
              padding: EdgeInsets.only(
                right: 16,
              ),
              child: SizedBox(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // Journey information
          _buildJourneyHeader(),

          const SizedBox(height: 6),

          // Running / Waiting / Upcoming
          _buildFilterTabs(
            runningCount: runningBuses.length,
            waitingCount: waitingBuses.length,
            scheduledCount: scheduledBuses.length,
          ),

          const SizedBox(height: 2),

          // Last updated indicator
          _buildLastUpdated(),

          const SizedBox(height: 2),

          // Bus list
          Expanded(
            child: _buildContent(
              displayedBuses,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // JOURNEY HEADER
  // ============================================================

  Widget _buildJourneyHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        15,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            "YOUR JOURNEY",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
              color: AppTheme.textMuted,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              Expanded(
                child: _journeyPoint(
                  icon:
                  Icons.radio_button_checked,
                  value: widget.source,
                  color: AppTheme.primaryRed,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppTheme.primaryRed,
                ),
              ),

              Expanded(
                child: _journeyPoint(
                  icon: Icons.location_on_rounded,
                  value: widget.destination,
                  color: AppTheme.primaryRed,
                  alignRight: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // Boarding time
          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppTheme.redLight,
              borderRadius:
              BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: AppTheme.primaryRed,
                ),

                const SizedBox(width: 5),

                Text(
                  "Boarding around ${widget.time}",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // JOURNEY POINT
  // ============================================================

  Widget _journeyPoint({
    required IconData icon,
    required String value,
    required Color color,
    bool alignRight = false,
  }) {
    return Row(
      mainAxisAlignment: alignRight
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!alignRight)
          Icon(
            icon,
            size: 14,
            color: color,
          ),

        if (!alignRight)
          const SizedBox(width: 5),

        Flexible(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: alignRight
                ? TextAlign.right
                : TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
        ),

        if (alignRight)
          const SizedBox(width: 5),

        if (alignRight)
          Icon(
            icon,
            size: 14,
            color: color,
          ),
      ],
    );
  }

  // ============================================================
  // FILTER TABS
  // ============================================================

  Widget _buildFilterTabs({
    required int runningCount,
    required int waitingCount,
    required int scheduledCount,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        12,
        5,
        12,
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              title: "Running",
              count: runningCount,
              icon:
              Icons.directions_bus_rounded,
              color: AppTheme.running,
              index: 0,
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: _buildTab(
              title: "Waiting",
              count: waitingCount,
              icon:
              Icons.pause_circle_outline_rounded,
              color: AppTheme.waiting,
              index: 1,
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: _buildTab(
              title: "Upcoming",
              count: scheduledCount,
              icon: Icons.schedule_rounded,
              color: AppTheme.scheduled,
              index: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAB
  // ============================================================

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
        setState(() {
          selectedTab = index;
        });
      },

      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.08)
              : AppTheme.background,

          borderRadius:
          BorderRadius.circular(10),

          border: Border.all(
            color: selected
                ? color.withOpacity(0.35)
                : AppTheme.border,
          ),
        ),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected
                  ? color
                  : AppTheme.textSecondary,
            ),

            const SizedBox(width: 4),

            Flexible(
              child: Text(
                title,
                overflow:
                TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? color
                      : AppTheme.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 4),

            Container(
              constraints:
              const BoxConstraints(
                minWidth: 20,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),

              decoration: BoxDecoration(
                color: selected
                    ? color.withOpacity(0.12)
                    : AppTheme.border,
                borderRadius:
                BorderRadius.circular(10),
              ),

              child: Text(
                count.toString(),
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight:
                  FontWeight.w800,
                  color: selected
                      ? color
                      : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LAST UPDATED
  // ============================================================

  Widget _buildLastUpdated() {
    final bool hasUpdated =
        lastUpdated != null;

    return Container(
      width: double.infinity,
      color: Colors.white,

      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        6,
      ),

      child: Row(
        children: [
          // Live indicator
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: hasUpdated
                  ? AppTheme.running
                  : AppTheme.textMuted,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            hasUpdated
                ? "Live data"
                : "Waiting for data",
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(width: 6),

          Container(
            width: 3,
            height: 3,
            decoration:
            const BoxDecoration(
              color: AppTheme.textMuted,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            hasUpdated
                ? "Updated ${_formatLastUpdated()}"
                : "Not updated yet",
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),

          const Spacer(),

          if (isRefreshing)
            const SizedBox(
              width: 12,
              height: 12,
              child:
              CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppTheme.primaryRed,
              ),
            )
          else
            const Icon(
              Icons.sync_rounded,
              size: 13,
              color: AppTheme.textMuted,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(
      List<Bus> displayedBuses,
      ) {
    // Initial loading
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryRed,
        ),
      );
    }

    // API error
    if (errorMessage != null &&
        buses.isEmpty) {
      return _buildErrorState();
    }

    // No buses
    if (displayedBuses.isEmpty) {
      return RefreshIndicator(
        color: AppTheme.primaryRed,

        onRefresh: _refresh,

        child: ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          children: [
            SizedBox(
              height: 380,
              child: _buildEmptyState(),
            ),
          ],
        ),
      );
    }

    // Bus list
    return RefreshIndicator(
      color: AppTheme.primaryRed,

      onRefresh: _refresh,

      child: ListView.builder(
        physics:
        const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.only(
          top: 5,
          bottom: 20,
        ),

        itemCount:
        displayedBuses.length,

        itemBuilder:
            (context, index) {
          return BusCard(
            bus: displayedBuses[index],
            recommended: index == 0,
          );
        },
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    String title;
    String subtitle;
    IconData icon;

    if (selectedTab == 0) {
      title =
      "No buses running right now";

      subtitle =
      "Try checking the Waiting or Upcoming buses.";

      icon =
          Icons.directions_bus_outlined;
    } else if (selectedTab == 1) {
      title =
      "No buses are waiting";

      subtitle =
      "There are currently no buses waiting at a stop.";

      icon =
          Icons.pause_circle_outline_rounded;
    } else {
      title =
      "No upcoming buses";

      subtitle =
      "Try selecting a different boarding time.";

      icon =
          Icons.schedule_rounded;
    }

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 35,
        ),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Container(
              width: 76,
              height: 76,

              decoration:
              const BoxDecoration(
                color: AppTheme.redLight,
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 34,
                color:
                AppTheme.primaryRed,
              ),
            ),

            const SizedBox(height: 17),

            Text(
              title,
              textAlign:
              TextAlign.center,

              style: const TextStyle(
                fontSize: 15,
                fontWeight:
                FontWeight.w800,
                color:
                AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign:
              TextAlign.center,

              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color:
                AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Container(
              width: 70,
              height: 70,

              decoration:
              const BoxDecoration(
                color: AppTheme.redLight,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.cloud_off_rounded,
                size: 32,
                color:
                AppTheme.primaryRed,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Couldn't load buses",
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                FontWeight.w800,
                color:
                AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Please check your connection and try again.",
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color:
                AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 42,

              child: ElevatedButton(
                onPressed: () {
                  _loadBuses();
                },

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppTheme.primaryRed,

                  foregroundColor:
                  Colors.white,

                  elevation: 0,

                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 22,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),
                ),

                child: const Text(
                  "Try again",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}