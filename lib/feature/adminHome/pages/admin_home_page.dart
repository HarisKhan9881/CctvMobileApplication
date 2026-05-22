import 'dart:async';

import 'package:cctv_app/core/components/admin_top_header.dart';
import 'package:cctv_app/core/components/custom_horizontal_listview_widget.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/models/general_parameter_option.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/network/services/dashboard_service.dart';
import 'package:cctv_app/core/network/services/general_parameter_service.dart';
import 'package:cctv_app/core/realtime/app_websocket_event.dart';
import 'package:cctv_app/core/realtime/app_websocket_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adminHome/widget/admin_post_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int selectedIndex = 0;
  int selectedTab = 3; // default Year
  bool _isLoadingSummary = false;
  String? _summaryError;
  int? _latestRegisterCount;
  int? _activeUserCount;
  bool _isLoadingChart = false;
  String? _chartError;
  List<_ChartPoint> _chartPoints = const [];
  bool _isLoadingPosts = false;
  String? _postsError;
  List<ActivePost> _recentPosts = const [];
  List<_CategoryTabItem> _categoryTabs = const [_CategoryTabItem(label: 'All')];
  StreamSubscription<AppWebSocketEvent>? _postsEventSubscription;
  bool _postsRefreshQueued = false;

  final List<String> tabs = ["Daily", "Weekly", "Monthly", "Year"];

  @override
  void initState() {
    super.initState();
    _bindWebSocketEvents();
    _loadSummary();
    _loadChart();
    _loadRecentPostsAndCategories();
  }

  @override
  void dispose() {
    _postsEventSubscription?.cancel();
    super.dispose();
  }

  void _bindWebSocketEvents() {
    _postsEventSubscription?.cancel();
    _postsEventSubscription = AppWebSocketService.instance
        .eventsFor(postRefreshEventTypes)
        .listen((_) => _scheduleRecentPostsRefresh());
  }

  void _scheduleRecentPostsRefresh() {
    if (!mounted) return;
    if (_isLoadingPosts) {
      _postsRefreshQueued = true;
      return;
    }
    _loadRecentPostsAndCategories();
  }

  Future<void> _loadSummary() async {
    setState(() {
      _isLoadingSummary = true;
      _summaryError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final dashboardService = DashboardService();
      final latestRegisterCount = await dashboardService
          .getLatestRegistrationCount(accessToken: accessToken);
      final activeUserCount = await dashboardService.getActiveUserCount(
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _latestRegisterCount = latestRegisterCount;
        _activeUserCount = activeUserCount;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _summaryError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _summaryError = 'Failed to load dashboard summary';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingSummary = false;
      });
    }
  }

  String _formatSummaryValue(int? value) {
    if (_isLoadingSummary) return '...';
    if (_summaryError != null) return '-';
    return (value ?? 0).toString();
  }

  List<String> get _categoryItems =>
      _categoryTabs.map((tab) => tab.label).toList();

  List<ActivePost> get _filteredPosts {
    if (selectedIndex < 0 || selectedIndex >= _categoryTabs.length) {
      return _recentPosts;
    }

    final selectedCategoryId = _categoryTabs[selectedIndex].categoryId;
    if (selectedCategoryId == null) {
      return _recentPosts;
    }

    return _recentPosts
        .where((post) => post.caseDetail?.caseCategoryId == selectedCategoryId)
        .toList();
  }

  Future<void> _loadRecentPostsAndCategories() async {
    setState(() {
      _isLoadingPosts = true;
      _postsError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final postService = CasePostService();
      final parameterService = const GeneralParameterService();
      final results = await Future.wait([
        postService.getAllRecentPosts(accessToken: accessToken),
        parameterService.getByHeaderName(
          headerName: 'CASE_CATEGORY',
          accessToken: accessToken,
        ),
      ]);

      final posts = results[0] as List<ActivePost>;
      final categoryOptions = results[1] as List<GeneralParameterOption>;
      final seenIds = <int>{};
      final categoryTabs = <_CategoryTabItem>[
        const _CategoryTabItem(label: 'All'),
      ];
      for (final option in categoryOptions) {
        if (option.paramLabel.trim().isEmpty ||
            seenIds.contains(option.paramDetailId)) {
          continue;
        }
        seenIds.add(option.paramDetailId);
        categoryTabs.add(
          _CategoryTabItem(
            label: option.paramLabel.trim(),
            categoryId: option.paramDetailId,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _recentPosts = posts;
        _categoryTabs = categoryTabs;
        if (selectedIndex >= _categoryTabs.length) {
          selectedIndex = 0;
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _postsError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _postsError = 'Failed to load recent posts';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingPosts = false;
      });
      if (_postsRefreshQueued) {
        _postsRefreshQueued = false;
        _loadRecentPostsAndCategories();
      }
    }
  }

  Future<void> _loadChart() async {
    setState(() {
      _isLoadingChart = true;
      _chartError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final range = _dateRangeForTab(selectedTab);
      final entries = await DashboardService().getUserAnalysis(
        accessToken: accessToken,
        dateFrom: range.start,
        dateTo: range.end,
      );

      if (!mounted) return;
      setState(() {
        _chartPoints = _buildChartPoints(entries, range, selectedTab);
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _chartError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _chartError = 'Failed to load analytics';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingChart = false;
      });
    }
  }

  DateTimeRange _dateRangeForTab(int tabIndex) {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);

    switch (tabIndex) {
      case 0:
        return DateTimeRange(
          start: end.subtract(const Duration(days: 6)),
          end: end,
        );
      case 1:
        return DateTimeRange(
          start: end.subtract(const Duration(days: 55)),
          end: end,
        );
      case 2:
        return DateTimeRange(
          start: DateTime(end.year, end.month - 11, 1),
          end: end,
        );
      case 3:
      default:
        return DateTimeRange(start: DateTime(end.year - 4, 1, 1), end: end);
    }
  }

  List<_ChartPoint> _buildChartPoints(
    List<DashboardUserAnalysisEntry> entries,
    DateTimeRange range,
    int tabIndex,
  ) {
    final normalizedEntries = entries
        .map(
          (entry) => DashboardUserAnalysisEntry(
            date: DateTime(entry.date.year, entry.date.month, entry.date.day),
            count: entry.count,
          ),
        )
        .toList();

    switch (tabIndex) {
      case 0:
        return _buildDailyPoints(normalizedEntries, range);
      case 1:
        return _buildWeeklyPoints(normalizedEntries, range);
      case 2:
        return _buildMonthlyPoints(normalizedEntries, range);
      case 3:
      default:
        return _buildYearlyPoints(normalizedEntries, range);
    }
  }

  List<_ChartPoint> _buildDailyPoints(
    List<DashboardUserAnalysisEntry> entries,
    DateTimeRange range,
  ) {
    final totals = <DateTime, int>{};
    for (final entry in entries) {
      totals.update(
        entry.date,
        (value) => value + entry.count,
        ifAbsent: () => entry.count,
      );
    }

    final points = <_ChartPoint>[];
    for (
      var day = range.start;
      !day.isAfter(range.end);
      day = day.add(const Duration(days: 1))
    ) {
      final value = totals[day] ?? 0;
      points.add(
        _ChartPoint(label: _formatDayLabel(day), value: value.toDouble()),
      );
    }

    return points;
  }

  List<_ChartPoint> _buildWeeklyPoints(
    List<DashboardUserAnalysisEntry> entries,
    DateTimeRange range,
  ) {
    DateTime weekStart(DateTime date) {
      final normalized = DateTime(date.year, date.month, date.day);
      return normalized.subtract(Duration(days: normalized.weekday - 1));
    }

    final totals = <DateTime, int>{};
    for (final entry in entries) {
      final start = weekStart(entry.date);
      totals.update(
        start,
        (value) => value + entry.count,
        ifAbsent: () => entry.count,
      );
    }

    final points = <_ChartPoint>[];
    var cursor = weekStart(range.start);
    final last = weekStart(range.end);

    while (!cursor.isAfter(last)) {
      final value = totals[cursor] ?? 0;
      points.add(
        _ChartPoint(label: _formatDayLabel(cursor), value: value.toDouble()),
      );
      cursor = cursor.add(const Duration(days: 7));
    }

    return points;
  }

  List<_ChartPoint> _buildMonthlyPoints(
    List<DashboardUserAnalysisEntry> entries,
    DateTimeRange range,
  ) {
    DateTime monthStart(DateTime date) => DateTime(date.year, date.month, 1);

    final totals = <DateTime, int>{};
    for (final entry in entries) {
      final start = monthStart(entry.date);
      totals.update(
        start,
        (value) => value + entry.count,
        ifAbsent: () => entry.count,
      );
    }

    final points = <_ChartPoint>[];
    var cursor = monthStart(range.start);
    final last = monthStart(range.end);
    while (!cursor.isAfter(last)) {
      final value = totals[cursor] ?? 0;
      points.add(
        _ChartPoint(label: _formatMonthLabel(cursor), value: value.toDouble()),
      );
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    }

    return points;
  }

  List<_ChartPoint> _buildYearlyPoints(
    List<DashboardUserAnalysisEntry> entries,
    DateTimeRange range,
  ) {
    DateTime yearStart(DateTime date) => DateTime(date.year, 1, 1);

    final totals = <DateTime, int>{};
    for (final entry in entries) {
      final start = yearStart(entry.date);
      totals.update(
        start,
        (value) => value + entry.count,
        ifAbsent: () => entry.count,
      );
    }

    final points = <_ChartPoint>[];
    var cursor = yearStart(range.start);
    final last = yearStart(range.end);

    while (!cursor.isAfter(last)) {
      final value = totals[cursor] ?? 0;
      points.add(
        _ChartPoint(label: cursor.year.toString(), value: value.toDouble()),
      );
      cursor = DateTime(cursor.year + 1, 1, 1);
    }

    return points;
  }

  String _formatDayLabel(DateTime date) {
    return '${_two(date.month)}-${_two(date.day)}';
  }

  String _formatMonthLabel(DateTime date) {
    return '${date.year}-${_two(date.month)}';
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  Widget _buildChartBody() {
    if (_isLoadingChart) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chartError != null) {
      return Center(
        child: Text(
          _chartError!,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      );
    }

    if (_chartPoints.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      );
    }

    final maxValue = _maxChartValue(_chartPoints);
    final interval = maxValue <= 1 ? 1.0 : (maxValue / 4).ceilToDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: interval,
              getTitlesWidget: (value, meta) {
                if (value % interval != 0) {
                  return const SizedBox.shrink();
                }
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= _chartPoints.length) {
                  return const SizedBox.shrink();
                }

                final skip = _chartPoints.length > 10
                    ? (_chartPoints.length / 6).ceil()
                    : 1;
                if (index % skip != 0) {
                  return const SizedBox.shrink();
                }

                return Text(
                  _chartPoints[index].label,
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(_chartPoints.length, (index) {
          final point = _chartPoints[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: point.value,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                width: 12,
              ),
            ],
          );
        }),
      ),
    );
  }

  double _maxChartValue(List<_ChartPoint> points) {
    var maxValue = 0.0;
    for (final point in points) {
      if (point.value > maxValue) {
        maxValue = point.value;
      }
    }

    if (maxValue <= 0) {
      return 1;
    }

    return maxValue + (maxValue * 0.2);
  }

  Widget _buildRecentPosts() {
    if (_isLoadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_postsError != null) {
      return Center(
        child: Text(
          _postsError!,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      );
    }

    final posts = _filteredPosts;
    if (posts.isEmpty) {
      return const Center(
        child: Text(
          'No recent posts available',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      separatorBuilder: (context, index) => Space.vertical(10),
      itemBuilder: (context, index) => AdminPostContainer(post: posts[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminTopHeader(),
            Space.vertical(10),
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    icon: Assets.pngRegisterTopImage,
                    title: "Total Register",
                    value: _formatSummaryValue(_latestRegisterCount),
                    chart: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                      ),
                      child: Image.asset(Assets.pngRegisterBottomImage),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    icon: Assets.pngActiveTopImage,
                    title: "Active User",
                    value: _formatSummaryValue(_activeUserCount),
                    chart: Image.asset(Assets.pngActiveBottomImage),
                  ),
                ),
              ],
            ),
            Space.vertical(10),
            Text("User Growth", style: context.bold.copyWith(fontSize: 20)),
            Space.vertical(10),
            Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = selectedTab == index;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == tabs.length - 1 ? 0 : 14,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                          });
                          _loadChart();
                        },
                        child: Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? kPrimaryColor : kWhiteColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: isSelected ? kPrimaryColor : kGreyColor,
                            ),
                          ),
                          child: Text(
                            tabs[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: isSelected ? kWhiteColor : kBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Space.vertical(10),
            SizedBox(
              height: 200,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _buildChartBody(),
              ),
            ),
            Space.vertical(10),
            Text("Recent post", style: context.bold.copyWith(fontSize: 20)),
            Space.vertical(10),
            CustomHorizontalListViewWidget(
              items: [..._categoryItems],
              selectedItem: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            Space.vertical(20),
            _buildRecentPosts(),
            Space.vertical(20),
          ],
        ),
      ),
    );
  }
}

class _ChartPoint {
  final String label;
  final double value;

  const _ChartPoint({required this.label, required this.value});
}

class _CategoryTabItem {
  final String label;
  final int? categoryId;

  const _CategoryTabItem({required this.label, this.categoryId});
}

class InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Widget chart;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: kGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              children: [
                Image.asset(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 60,
              width: context.width * 0.5,
              child: chart,
            ),
          ),
        ],
      ),
    );
  }
}
