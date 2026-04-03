import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/models/general_parameter_option.dart';
import 'package:cctv_app/core/network/models/post_report.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/network/services/general_parameter_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/app_date_time.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/communityFeedback/pages/feedback_view.dart';
import 'package:cctv_app/feature/communityFeedback/widget/community_feedback_widget.dart';
import 'package:flutter/material.dart';

import '../../../core/components/custom_horizontal_listview_widget.dart';

class CommunityFeedback extends StatefulWidget {
  const CommunityFeedback({super.key});

  @override
  State<CommunityFeedback> createState() => _CommunityFeedbackState();
}

class _CommunityFeedbackState extends State<CommunityFeedback> {
  int selectedIndex = 0;
  bool _isLoading = false;
  String? _loadError;
  int? _selectedCategoryId;
  List<_CategoryTabItem> _categoryTabs = const [_CategoryTabItem(label: 'All')];
  List<GeneralParameterOption> _categories = const [];
  List<PostReport> _reports = const [];
  Map<int, int?> _postCategoryIds = const {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final results = await Future.wait([
        const GeneralParameterService().getByHeaderName(
          headerName: 'CASE_CATEGORY',
          accessToken: accessToken,
        ),
        CasePostService().getPostReports(accessToken: accessToken, status: 'P'),
        CasePostService().getAllRecentPosts(accessToken: accessToken),
      ]);

      if (!mounted) return;
      setState(() {
        _categories = results[0] as List<GeneralParameterOption>;
        _reports = results[1] as List<PostReport>;
        final posts = results[2] as List<ActivePost>;
        _postCategoryIds = {
          for (final post in posts)
            post.postId: post.caseDetail?.caseCategoryId,
        };
        _categoryTabs = _buildCategoryTabs(_categories);
        if (selectedIndex >= _categoryTabs.length) {
          selectedIndex = 0;
          _selectedCategoryId = null;
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Failed to load feedback reports';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectCategory(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        _selectedCategoryId = null;
      } else {
        _selectedCategoryId = _categoryTabs[index].categoryId;
      }
    });
  }

  List<_CategoryTabItem> _buildCategoryTabs(
    List<GeneralParameterOption> options,
  ) {
    final seenIds = <int>{};
    final tabs = <_CategoryTabItem>[const _CategoryTabItem(label: 'All')];
    for (final option in options) {
      if (option.paramLabel.trim().isEmpty ||
          seenIds.contains(option.paramDetailId)) {
        continue;
      }
      seenIds.add(option.paramDetailId);
      tabs.add(
        _CategoryTabItem(
          label: option.paramLabel.trim(),
          categoryId: option.paramDetailId,
        ),
      );
    }
    return tabs;
  }

  String _formatDate(String? value) {
    return AppDateTime.formatShortDateTime(value);
  }

  @override
  Widget build(BuildContext context) {
    final categoryItems = _categoryTabs.map((tab) => tab.label).toList();
    final categoryLabelById = {
      for (final category in _categories)
        category.paramDetailId: category.paramLabel,
    };

    final filteredReports = _selectedCategoryId == null
        ? _reports
        : _reports
              .where(
                (report) =>
                    _postCategoryIds[report.postId] == _selectedCategoryId,
              )
              .toList();

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Community Feedback"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomHorizontalListViewWidget(
              items: categoryItems,
              selectedItem: selectedIndex,
              onTap: (index) {
                _selectCategory(index);
              },
            ),
          ),
          Space.vertical(15),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: CircularProgressIndicator(),
            )
          else if (_loadError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    _loadError!,
                    style: const TextStyle(color: kRedColor, fontSize: 12),
                  ),
                  TextButton(
                    onPressed: _loadInitialData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: filteredReports.length,
                separatorBuilder: (_, __) => Space.vertical(8),
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
                  final categoryLabel =
                      categoryLabelById[_postCategoryIds[report.postId]];

                  return CommunityFeedbackWidget(
                    title: report.reportAdditionalInformation.isEmpty
                        ? 'Report #${report.reportId}'
                        : report.reportAdditionalInformation,
                    categoryLabel: categoryLabel,
                    createdAt: _formatDate(report.createdAt),
                    onView: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedbackView(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryTabItem {
  final String label;
  final int? categoryId;

  const _CategoryTabItem({required this.label, this.categoryId});
}
