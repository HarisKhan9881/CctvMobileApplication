import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class AdminPostContainer extends StatelessWidget {
  final ActivePost post;

  const AdminPostContainer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: kGreyColor),
      ),
      padding: EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildThumbnail(),
          Space.horizontal(10),
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
          Space.horizontal(10),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    final meta = post.caseDetail?.meta;
    final imageUrl = meta?.metaUrl;
    if (meta != null && meta.isImage && imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Image.asset(
        Assets.pngHighlight1Image,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
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
    final createdAt = post.createdAt?.trim();
    if (createdAt == null || createdAt.isEmpty) {
      return 'Unknown date';
    }

    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) {
      return createdAt;
    }

    return '${_two(parsed.day)}-${_two(parsed.month)}-${parsed.year} '
        '${_two(parsed.hour)}:${_two(parsed.minute)}';
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
