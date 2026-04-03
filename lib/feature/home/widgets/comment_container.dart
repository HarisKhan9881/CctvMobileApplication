import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final String authorName;
  final String comment;
  final String timeText;
  final VoidCallback? onReplyTap;
  final String replyLabel;
  final bool isReplyActive;

  const CommentContainer({
    super.key,
    this.authorName = '',
    this.comment = '',
    this.timeText = '',
    this.onReplyTap,
    this.replyLabel = 'Reply',
    this.isReplyActive = false,
  });

  const CommentContainer.dynamic({
    super.key,
    required this.authorName,
    required this.comment,
    required this.timeText,
    this.onReplyTap,
    this.replyLabel = 'Reply',
    this.isReplyActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedAuthor = authorName.isEmpty ? "Maude Hell" : authorName;
    final resolvedComment = comment.isEmpty
        ? "The standard lorem ipsum passage has been a printer's friend for centuries. Like stock photos today, it served as a placeholder for actual content. "
        : comment;
    final resolvedTime = timeText.isEmpty ? "14 min" : timeText;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kLightGreyColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: kTextfieldBlueColor,
                backgroundImage: const AssetImage(Assets.pngUser1Image),
              ),
              Space.horizontal(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resolvedAuthor,
                      style: context.semiBold.copyWith(fontSize: 14),
                    ),
                    Space.vertical(2),
                    Text(
                      resolvedTime,
                      style: context.normal.copyWith(
                        color: kDarkGreyColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Space.vertical(12),
          Text(
            resolvedComment,
            style: context.normal.copyWith(
              height: 1.4,
              color: kBlackColor,
            ),
          ),
          Space.vertical(12),
          InkWell(
            onTap: onReplyTap,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isReplyActive
                    ? kPrimaryColor.withValues(alpha: 0.12)
                    : kWhiteColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isReplyActive ? kPrimaryColor : kGreyColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.reply_rounded,
                    size: 16,
                    color: isReplyActive ? kPrimaryColor : kDarkGreyColor,
                  ),
                  Space.horizontal(6),
                  Text(
                    replyLabel,
                    style: context.semiBold.copyWith(
                      fontSize: 12,
                      color: isReplyActive ? kPrimaryColor : kDarkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
