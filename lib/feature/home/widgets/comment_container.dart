import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final String authorName;
  final String comment;
  final String timeText;
  final String? avatarUrl;
  final VoidCallback? onReplyTap;
  final String replyLabel;
  final bool isReplyActive;

  const CommentContainer({
    super.key,
    this.authorName = '',
    this.comment = '',
    this.timeText = '',
    this.avatarUrl,
    this.onReplyTap,
    this.replyLabel = 'Reply',
    this.isReplyActive = false,
  });

  const CommentContainer.dynamic({
    super.key,
    required this.authorName,
    required this.comment,
    required this.timeText,
    this.avatarUrl,
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
    final normalizedAvatarUrl = avatarUrl?.trim();
    final hasAvatar = normalizedAvatarUrl != null && normalizedAvatarUrl.isNotEmpty;
    final avatarText = _buildAvatarText(resolvedAuthor);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isReplyActive ? kPrimaryColor.withValues(alpha: 0.22) : kGreyColor,
        ),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      kPrimaryColor.withValues(alpha: 0.22),
                      kTextfieldBlueColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: kTextfieldBlueColor,
                  backgroundImage: hasAvatar ? NetworkImage(normalizedAvatarUrl) : null,
                  child: hasAvatar
                      ? null
                      : Text(
                          avatarText,
                          style: context.bold.copyWith(
                            color: kPrimaryColor,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              Space.horizontal(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resolvedAuthor,
                      style: context.bold.copyWith(
                        fontSize: 14,
                        color: kBlackColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Space.vertical(6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: kTextfieldBlueColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        resolvedTime,
                        style: context.medium.copyWith(
                          color: kPrimaryColor,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Space.vertical(8),
                    Container(
                      width: 42,
                      height: 3,
                      decoration: BoxDecoration(
                        color: isReplyActive
                            ? kPrimaryColor
                            : kPrimaryColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Space.vertical(14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              color: kLightGreyColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              resolvedComment,
              style: context.normal.copyWith(
                height: 1.55,
                color: kBlackColor,
                fontSize: 14,
              ),
            ),
          ),
          Space.vertical(14),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isReplyActive ? kPrimaryColor : kSecondaryGreyColor,
                  shape: BoxShape.circle,
                ),
              ),
              Space.horizontal(8),
              Text(
                isReplyActive ? 'Replying...' : 'Join the conversation',
                style: context.medium.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onReplyTap,
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isReplyActive
                        ? kPrimaryColor
                        : kPrimaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isReplyActive
                          ? kPrimaryColor
                          : kPrimaryColor.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.reply_rounded,
                        size: 16,
                        color: isReplyActive ? kWhiteColor : kPrimaryColor,
                      ),
                      Space.horizontal(6),
                      Text(
                        replyLabel,
                        style: context.semiBold.copyWith(
                          fontSize: 12,
                          color: isReplyActive ? kWhiteColor : kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildAvatarText(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }

    if (parts.length == 1) {
      final value = parts.first;
      return value.substring(0, value.length >= 2 ? 2 : 1).toUpperCase();
    }

    return 'U';
  }
}
