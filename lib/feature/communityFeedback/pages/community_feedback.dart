import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
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
  @override
  Widget build(BuildContext context) {
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
              items: [
                'All',
                'Family Affairs',
                'Divorce',
                'Neighborhood conflicts',
              ],
              selectedItem: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
          Space.vertical(15),
          CommunityFeedbackWidget(),
          Space.vertical(8),
          CommunityFeedbackWidget(),
        ],
      ),
    );
  }
}
