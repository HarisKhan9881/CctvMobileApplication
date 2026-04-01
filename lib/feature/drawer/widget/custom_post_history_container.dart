import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomPostHistoryContainer extends StatelessWidget {
  final ActivePost post;

  const CustomPostHistoryContainer({super.key, required this.post});

  String _timeLabel(String? value) {
    if (value == null || value.trim().isEmpty) return 'Just now';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value.replaceFirst('T', ' ');
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[parsed.month - 1];
    final hour = parsed.hour == 0
        ? 12
        : parsed.hour > 12
        ? parsed.hour - 12
        : parsed.hour;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final suffix = parsed.hour >= 12 ? 'PM' : 'AM';
    return '$month ${parsed.day}, ${parsed.year} • $hour:$minute $suffix';
  }

  Widget _buildThumbnail(String? url, bool isImage) {
    if (url == null || url.trim().isEmpty || !isImage) {
      return Image.asset(
        Assets.pngHighlight2Image,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          Assets.pngHighlight2Image,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final caseDetail = post.caseDetail;
    final meta = caseDetail?.meta;
    final title = (caseDetail?.caseTitle ?? '').trim().isNotEmpty
        ? caseDetail!.caseTitle
        : 'Post #${post.postId}';
    final description = post.postDescription.trim().isNotEmpty
        ? post.postDescription
        : (caseDetail?.caseDescription ?? '');
    final timeText = _timeLabel(post.createdAt);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildThumbnail(meta?.metaUrl, meta?.isImage ?? true),
            ),
            Space.horizontal(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.bold.copyWith(fontSize: 14)),
                  Space.vertical(4),
                  RichText(
                    text: TextSpan(
                      text: description.isEmpty
                          ? 'No description available.'
                          : description,
                      style: context.normal.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '  $timeText',
                          style: context.normal.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: kDarkGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Space.vertical(6),
        Divider(color: kGreyColor, thickness: 1),
      ],
    );
  }
}
