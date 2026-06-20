import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/home/widgets/home_post_container.dart';
import 'package:flutter/material.dart';

class AdminPostDetailPage extends StatelessWidget {
  final ActivePost post;
  final VoidCallback? onPostUpdated;

  const AdminPostDetailPage({
    super.key,
    required this.post,
    this.onPostUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: const Text('Post'),
        backgroundColor: kWhiteColor,
        foregroundColor: kBlackColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          HomePostContainer(
            isAdmin: true,
            post: post,
            onClickProfile: () {},
            onPostUpdated: onPostUpdated ?? () {},
          ),
        ],
      ),
    );
  }
}
