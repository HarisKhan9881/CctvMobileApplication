import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/utils/app_date_time.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adminHome/pages/admin_post_detail_page.dart';
import 'package:flutter/material.dart';

class AdminPostContainer extends StatelessWidget {
  final ActivePost post;
  final VoidCallback? onPostUpdated;

  const AdminPostContainer({
    super.key,
    required this.post,
    this.onPostUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhiteColor,
      borderRadius: BorderRadius.circular(15.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminPostDetailPage(
                post: post,
                onPostUpdated: onPostUpdated,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: kGreyColor),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_hasThumbnail) ...[
                _buildThumbnail(),
                Space.horizontal(10),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_titleText, style: context.bold.copyWith(fontSize: 14)),
                    Space.vertical(8),
                    Text(
                      _subtitleText,
                      overflow: TextOverflow.ellipsis,
                      style: context.normal.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final meta = post.caseDetail?.meta;
    final imageUrl = meta?.metaUrl?.trim();
    if (meta != null && meta.isImage && imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  bool get _hasThumbnail {
    final meta = post.caseDetail?.meta;
    final imageUrl = meta?.metaUrl?.trim();
    return meta != null &&
        meta.isImage &&
        imageUrl != null &&
        imageUrl.isNotEmpty;
  }

  String get _titleText {
    final caseTitle = post.caseDetail?.caseTitle.trim();
    if (caseTitle != null && caseTitle.isNotEmpty) {
      return caseTitle;
    }

    final description = post.postDescription.trim();
    return description.isEmpty ? 'Recent post' : description;
  }

  String get _subtitleText {
    return AppDateTime.formatAdminDateTime(post.createdAt);
  }
}
