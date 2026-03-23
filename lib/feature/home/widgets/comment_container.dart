import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final String authorName;
  final String comment;
  final String timeText;

  const CommentContainer({
    super.key,
    this.authorName = '',
    this.comment = '',
    this.timeText = '',
  });

  const CommentContainer.dynamic({
    super.key,
    required this.authorName,
    required this.comment,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedAuthor = authorName.isEmpty ? "Maude Hell" : authorName;
    final resolvedComment = comment.isEmpty
        ? "The standard lorem ipsum passage has been a printer's friend for centuries. Like stock photos today, it served as a placeholder for actual content. "
        : comment;
    final resolvedTime = timeText.isEmpty ? "14 min" : timeText;

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(Assets.pngUser1Image),
            ),
            Space.horizontal(12),
            Text(resolvedAuthor, style: context.bold),
            Space.horizontal(12),
            Text(
              resolvedTime,
              style: context.normal.copyWith(color: kDarkGreyColor),
            ),
          ],
        ),
        Space.vertical(10),
        Text(
          resolvedComment,
          style: context.normal,
        ),
        Space.vertical(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("1 Like", style: context.normal),
                Space.horizontal(12),
                Row(
                  children: [
                    Icon(Icons.reply, color: kDarkGreyColor),
                    Text("Reply", style: context.normal),
                  ],
                ),
              ],
            ),
            Icon(Icons.thumb_up_off_alt, color: kDarkGreyColor),
          ],
        ),
      ],
    );
  }
}
