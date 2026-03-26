import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/custom_menu_button.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adminHome/pages/report_and_suspend.dart';
import 'package:cctv_app/feature/home/pages/repost_screen.dart';
import 'package:cctv_app/feature/home/widgets/comment_container.dart';
import 'package:cctv_app/feature/home/widgets/vote_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class HomePostContainer extends StatefulWidget {
  final bool isAdmin;
  final VoidCallback onClickProfile;
  final ActivePost post;
  const HomePostContainer({
    super.key,
    required this.isAdmin,
    required this.onClickProfile,
    required this.post,
  });

  @override
  State<HomePostContainer> createState() => _HomePostContainerState();
}

class _HomePostContainerState extends State<HomePostContainer> {
  bool areCommentsVisible = false;
  bool isMuted = false;
  bool isWarning = false;
  String? selectedReaction;
  bool isReactionPopupVisible = false;
  OverlayEntry? reactionOverlay;
  bool _isSubmittingVote = false;
  bool _isSubmittingReaction = false;
  bool _isSubmittingComment = false;
  int _reactionCountDelta = 0;
  String? _selectedVote;
  late final TextEditingController _commentController;
  late List<ActivePostComment> _comments;

  int get _reactionCount =>
      (widget.post.reactionSummary?.totalReactions ?? widget.post.reactions.length) +
      _reactionCountDelta;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _comments = List<ActivePostComment>.from(widget.post.comments);
    _loadCurrentUserReaction();
  }

  @override
  void didUpdateWidget(covariant HomePostContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.postId != widget.post.postId) {
      _reactionCountDelta = 0;
      _comments = List<ActivePostComment>.from(widget.post.comments);
      _commentController.clear();
      _loadCurrentUserReaction();
    }
  }

  String _timeLabel(String? value) {
    if (value == null || value.trim().isEmpty) return '';
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

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final author = post.createdByUserInfo?.fullName.isNotEmpty == true
        ? post.createdByUserInfo!.fullName
        : 'Unknown User';
    final timeText = _timeLabel(post.createdAt);
    final defendant = post.defendantDetails.isNotEmpty
        ? post.defendantDetails.first
        : null;
    final ownerName = post.createdByUserInfo?.fullName.isNotEmpty == true
        ? post.createdByUserInfo!.fullName
        : 'Owner';
    final defendantName = defendant?.userInfo?.fullName ?? 'Defendant';

    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: kGreyColor),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onClickProfile,
                  child: Container(
                    decoration: BoxDecoration(color: kTransparentColor),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(Assets.pngUser1Image),
                        ),
                        Space.horizontal(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(author, style: context.semiBold),
                            Text(
                              timeText.isEmpty ? "Just now" : timeText,
                              style: context.normal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                widget.isAdmin
                    ? GestureDetector(
                        onTap: () {
                          AppBottomSheet.show(
                            context,
                            body: StatefulBuilder(
                              builder: (context, setStateBottomSheet) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CircleAvatar(
                                          backgroundColor: kLightGreyColor,
                                          child: SvgPicture.asset(
                                            Assets.svgCancelIcon,
                                          ),
                                        ),
                                      ),
                                      Space.vertical(10),
                                      Text(
                                        'Take action against post or Profile. ',
                                        style: context.normal.copyWith(
                                          fontSize: 16,
                                          color: kDarkGreyColor,
                                        ),
                                      ),
                                      Space.vertical(20),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isMuted = true;
                                          });
                                          setStateBottomSheet(() {});
                                        },
                                        child: Container(
                                          color: kTransparentColor,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                Assets.svgMuteIcon,
                                              ),
                                              Space.horizontal(12),
                                              Text(
                                                'Mute conversation',
                                                style: context.normal.copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Space.vertical(8),
                                      Divider(),
                                      Space.vertical(8),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isWarning = true;
                                          });
                                          setStateBottomSheet(() {});
                                        },
                                        child: Container(
                                          color: kTransparentColor,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                Assets.svgWarningIcon,
                                              ),
                                              Space.horizontal(12),
                                              Text(
                                                'Send Warning',
                                                style: context.normal.copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Space.vertical(8),
                                      Divider(),
                                      Space.vertical(8),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportAndSuspend(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: kTransparentColor,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                Assets.svgBlockIcon,
                                              ),
                                              Space.horizontal(12),
                                              Text(
                                                'Block',
                                                style: context.normal.copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isWarning) ...[
                                        Space.vertical(16),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.svgWarningIcon,
                                            ),
                                            Space.horizontal(20),
                                            Text(
                                              'Warning has been send',
                                              style: context.normal.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (isMuted) ...[
                                        Space.vertical(16),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Assets.svgWarningIcon,
                                              color: kPrimaryColor,
                                            ),
                                            Space.horizontal(12),
                                            Text(
                                              'Conversation is Muted now',
                                              style: context.normal.copyWith(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      Space.vertical(40),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            border: Border.all(color: kDarkGreyColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.more_horiz, color: kBlackColor),
                        ),
                      )
                    : Directionality(
                        textDirection: TextDirection.rtl,
                        child: MenuAnchor(
                          alignmentOffset: const Offset(0, 10),
                          style: MenuStyle(
                            backgroundColor: WidgetStateProperty.all(
                              kWhiteColor,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: kLightGreyColor),
                              ),
                            ),
                            elevation: WidgetStateProperty.all(4),
                            alignment: AlignmentDirectional.bottomStart,
                            visualDensity: VisualDensity.compact,
                          ),
                          builder:
                              (
                                BuildContext context,
                                MenuController controller,
                                Widget? child,
                              ) {
                                return GestureDetector(
                                  onTap: () {
                                    if (controller.isOpen) {
                                      controller.close();
                                    } else {
                                      controller.open();
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kWhiteColor,
                                      border: Border.all(color: kGreyColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: kBlackColor,
                                    ),
                                  ),
                                );
                              },
                          menuChildren: [
                            CustomMenuButton(
                              onTap: () {},
                              icon: Icon(Icons.bookmark_add_outlined),
                              iconSize: 15,
                              title: 'Save',
                            ),
                            CustomMenuButton(
                              onTap: () {},
                              icon: Icon(Icons.copy_all),
                              iconSize: 15,
                              title: 'Copy Link',
                            ),
                            CustomMenuButton(
                              onTap: () {},
                              icon: Icon(Icons.report, color: kRedColor),
                              iconSize: 15,
                              textColor: kRedColor,
                              title: 'Report',
                            ),
                          ],
                        ),
                      ),
              ],
            ),
            Space.vertical(20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    post.caseDetail?.caseTitle.isNotEmpty == true
                        ? post.caseDetail!.caseTitle
                        : "Who's Right",
                    style: context.bold.copyWith(fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Space.vertical(20),
            _PostComparisonPreview(
              leftMedia: post.caseDetail?.meta,
              rightMedia: defendant?.meta,
            ),
            Space.vertical(15),
            VotingResultExample(
              leftLabel: 'A.',
              leftText: ownerName,
              rightLabel: 'B.',
              rightText: defendantName,
              leftVotes: post.casePollCount?.ownerCount ?? 0,
              rightVotes: post.casePollCount?.defendantCount ?? 0,
              selectedOption: _selectedVote,
              isSubmitting: _isSubmittingVote,
              onLeftTap: () => _confirmVote(
                context,
                post: post,
                selectedVote: 'owner',
                selectedName: ownerName,
              ),
              onRightTap: () => _confirmVote(
                context,
                post: post,
                selectedVote: 'defendant',
                selectedName: defendantName,
              ),
            ),
            Space.vertical(15),
            PrimaryButton(
              height: 40,
              text: "Resolutions",
              onPressed: () {
                _showSimpleDialog(context, post);
              },
            ),
            Space.vertical(14),
            _buildReactionSummaryRow(post),
            const Divider(height: 20),
            _buildPostActionRow(post),
            Space.vertical(20),
            const SizedBox(height: 16),
            if (areCommentsVisible) ...[
              if (_comments.isEmpty)
                Text(
                  "No comments yet",
                  style: context.normal.copyWith(color: kDarkGreyColor),
                )
              else
                ..._comments.map((comment) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CommentContainer.dynamic(
                      authorName:
                          comment.userInfo?.fullName.isNotEmpty == true
                          ? comment.userInfo!.fullName
                          : 'User',
                      comment: comment.commentContent,
                      timeText: _timeLabel(comment.createdAt),
                    ),
                  );
                }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _commentController,
                      hintText: "Write comment here",
                      hintTextColor: kDarkGreyColor,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                  Space.horizontal(8),
                  SizedBox(
                    height: 58,
                    child: PrimaryButton(
                      text: _isSubmittingComment ? "..." : "Send",
                      isMainAxisSizeMin: true,
                      inactive: _isSubmittingComment,
                      processing: _isSubmittingComment,
                      onPressed: () {
                        _submitComment();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    reactionOverlay?.remove();
    _commentController.dispose();
    super.dispose();
  }

  Widget reactionContainer({
    required String text,
    required VoidCallback? onTap,
    required IconData icon,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kGreyColor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, color: kPrimaryColor),
            Space.horizontal(8),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(String emoji) {
    return GestureDetector(
      onTap: () {
        _hideReactionPopup();
        _submitReaction(_reactionTypeFromEmoji(emoji));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        child: Text(emoji, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  IconData _getReactionIcon() {
    switch (selectedReaction) {
      case "Love":
        return Icons.favorite;
      case "Haha":
        return Icons.emoji_emotions;
      case "Wow":
        return Icons.sentiment_neutral;
      case "Sad":
        return Icons.sentiment_very_dissatisfied;
      case "Angry":
        return Icons.sentiment_very_dissatisfied;
      case "Like":
        return Icons.thumb_up;
      default:
        return Icons.thumb_up_outlined;
    }
  }

  void _hideReactionPopup() {
    setState(() {
      isReactionPopupVisible = false;
    });
    reactionOverlay?.remove();
    reactionOverlay = null;
  }

  void _showReactionPopup(Offset position) {
    if (reactionOverlay != null || _isSubmittingReaction) return;

    setState(() {
      isReactionPopupVisible = true;
    });

    reactionOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Tap outside to close popup
              _hideReactionPopup();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx - 50,
            top: position.dy - 80,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildReactionButton("❤️"),
                    _buildReactionButton("😂"),
                    _buildReactionButton("😮"),
                    _buildReactionButton("😢"),
                    _buildReactionButton("😡"),
                    _buildReactionButton("👍"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(reactionOverlay!);
  }

  void _showSimpleDialog(BuildContext context, ActivePost post) {
    final caseDetail = post.caseDetail;
    final description = caseDetail?.caseDescription?.trim().isNotEmpty == true
        ? caseDetail!.caseDescription.trim()
        : post.postDescription.trim();
    final resolution = caseDetail?.caseResolution?.trim().isNotEmpty == true
        ? caseDetail!.caseResolution!.trim()
        : 'No resolution details available.';
    final title = caseDetail?.caseTitle.trim().isNotEmpty == true
        ? caseDetail!.caseTitle.trim()
        : 'Resolution';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kWhiteColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(Assets.svgCancelIcon),
                ),
              ),
              Text(title, style: context.bold),
              SizedBox(height: 12),
              Text(
                description.isNotEmpty
                    ? description
                    : 'No case description available.',
                style: context.normal,
              ),
              SizedBox(height: 12),
              Text(
                resolution,
                style: context.normal.copyWith(color: kDarkGreyColor),
              ),
              SizedBox(height: 20),
              PrimaryButton(
                text: "Close",
                isMainAxisSizeMin: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitReaction(String reaction) async {
    if (_isSubmittingReaction) return;

    final previousReaction = selectedReaction;
    setState(() {
      _isSubmittingReaction = true;
      selectedReaction = reaction;
    });

    try {
      final authStorage = const AuthStorage();
      final accessToken = await authStorage.readAccessToken();
      final userId = await authStorage.readUserId();

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('User id not found');
      }

      await CasePostService().createPostReaction(
        accessToken: accessToken,
        postId: widget.post.postId,
        userId: userId,
        reactionType: reaction,
      );

      if (!mounted) return;
      setState(() {
        if (previousReaction == null) {
          _reactionCountDelta += 1;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_reactionLabel(reaction)} reaction added')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        selectedReaction = previousReaction;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        selectedReaction = previousReaction;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit reaction')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingReaction = false;
      });
    }
  }

  String _reactionLabel(String? reaction) {
    return _normalizeReactionType(reaction);
  }

  Future<void> _loadCurrentUserReaction() async {
    final userId = await const AuthStorage().readUserId();
    if (!mounted) return;

    final userReaction = _findUserReaction(userId);
    setState(() {
      selectedReaction = userReaction;
    });
  }

  String? _findUserReaction(int? userId) {
    if (userId == null) return null;

    for (final reaction in widget.post.reactions.reversed) {
      if (reaction.userId == userId) {
        return _normalizeReactionType(reaction.reactionType);
      }
    }
    return null;
  }

  Widget _buildReactionSummaryIcons() {
    final reactionTypes = _topReactionTypes();
    if (reactionTypes.isEmpty) {
      return const Icon(Icons.thumb_up_alt_outlined, color: kPrimaryColor);
    }

    return SizedBox(
      width: 44,
      height: 20,
      child: Stack(
        children: [
          for (var index = 0; index < reactionTypes.length; index++)
            Positioned(
              left: index * 12,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: kWhiteColor, width: 1.5),
                ),
                child: Text(
                  _emojiForReaction(reactionTypes[index]),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReactionSummaryRow(ActivePost post) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              _buildReactionSummaryIcons(),
              Space.horizontal(8),
              Flexible(
                child: Text(
                  _reactionCount > 0 ? '$_reactionCount' : 'Be the first to react',
                  style: context.normal.copyWith(color: kDarkGreyColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Space.horizontal(12),
        Text(
          '${_comments.length} comments',
          style: context.normal.copyWith(color: kDarkGreyColor),
        ),
      ],
    );
  }

  Widget _buildPostActionRow(ActivePost post) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onLongPressStart: (details) {
              _showReactionPopup(details.globalPosition);
            },
            child: _buildActionButton(
              text: _reactionLabel(selectedReaction),
              onTap: isReactionPopupVisible ? null : () => _submitReaction('Like'),
              icon: _getReactionIcon(),
              isLoading: _isSubmittingReaction,
              isSelected: selectedReaction != null,
            ),
          ),
        ),
        Expanded(
          child: _buildActionButton(
            text: 'Comment',
            onTap: () {
              setState(() {
                areCommentsVisible = !areCommentsVisible;
              });
            },
            icon: Icons.mode_comment_outlined,
          ),
        ),
        Expanded(child: _buildShareActionButton()),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onTap,
    required IconData icon,
    bool isLoading = false,
    bool isSelected = false,
  }) {
    final foregroundColor = isSelected ? kPrimaryColor : kDarkGreyColor;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, color: foregroundColor, size: 20),
            Space.horizontal(6),
            Flexible(
              child: Text(
                text,
                style: context.semiBold.copyWith(
                  color: foregroundColor,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareActionButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MenuAnchor(
        alignmentOffset: const Offset(0, 10),
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(kWhiteColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: kLightGreyColor),
            ),
          ),
          elevation: WidgetStateProperty.all(4),
          alignment: AlignmentDirectional.bottomStart,
          visualDensity: VisualDensity.compact,
        ),
        builder: (
          BuildContext context,
          MenuController controller,
          Widget? child,
        ) {
          return _buildActionButton(
            text: 'Share',
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: Icons.share_outlined,
          );
        },
        menuChildren: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 26, bottom: 8),
            child: Text(
              "Quick Actions",
              style: context.normal.copyWith(color: kDarkGreyColor),
            ),
          ),
          CustomMenuButton(
            onTap: () {},
            icon: SvgPicture.asset(Assets.svgCopyIcon),
            iconSize: 15,
            title: 'Whatsapp',
          ),
          CustomMenuButton(
            onTap: () {},
            icon: SvgPicture.asset(Assets.svgTwitterIcon),
            iconSize: 15,
            title: 'Twitter/X',
          ),
          CustomMenuButton(
            onTap: () {},
            icon: SvgPicture.asset(Assets.svgFacebookIcon),
            iconSize: 15,
            title: 'Facebook',
          ),
          CustomMenuButton(
            onTap: () {},
            icon: SvgPicture.asset(Assets.svgCopyIcon),
            iconSize: 15,
            title: 'CopyLink',
          ),
        ],
      ),
    );
  }

  List<String> _topReactionTypes() {
    final summary = widget.post.reactionSummary?.byType;
    if (summary == null || summary.isEmpty) {
      return widget.post.reactions
          .map((reaction) => _normalizeReactionType(reaction.reactionType))
          .where((reaction) => reaction.isNotEmpty)
          .toSet()
          .take(3)
          .toList();
    }

    final entries = summary.entries.toList()
      ..sort((a, b) {
        final left = int.tryParse('${a.value}') ?? 0;
        final right = int.tryParse('${b.value}') ?? 0;
        return right.compareTo(left);
      });

    return entries
        .map((entry) => _normalizeReactionType(entry.key))
        .where((reaction) => reaction.isNotEmpty)
        .take(3)
        .toList();
  }

  String _normalizeReactionType(String? reaction) {
    final value = (reaction ?? '').trim().toLowerCase();
    switch (value) {
      case '👍':
      case 'like':
        return 'Like';
      case '❤️':
      case 'heart':
      case 'love':
        return 'Love';
      case '😂':
      case 'haha':
      case 'laugh':
      case 'laughing':
        return 'Haha';
      case '😮':
      case 'wow':
        return 'Wow';
      case '😢':
      case 'sad':
        return 'Sad';
      case '😡':
      case 'angry':
        return 'Angry';
      default:
        return reaction?.trim().isNotEmpty == true ? reaction!.trim() : 'Like';
    }
  }

  String _emojiForReaction(String reaction) {
    switch (_normalizeReactionType(reaction)) {
      case 'Love':
        return '❤️';
      case 'Haha':
        return '😂';
      case 'Wow':
        return '😮';
      case 'Sad':
        return '😢';
      case 'Angry':
        return '😡';
      case 'Like':
      default:
        return '👍';
    }
  }

  String _reactionTypeFromEmoji(String emoji) {
    switch (emoji) {
      case '❤️':
        return 'Love';
      case '😂':
        return 'Haha';
      case '😮':
        return 'Wow';
      case '😢':
        return 'Sad';
      case '😡':
        return 'Angry';
      case '👍':
      default:
        return 'Like';
    }
  }

  Future<void> _submitComment() async {
    if (_isSubmittingComment) return;

    final commentContent = _commentController.text.trim();
    if (commentContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a comment')),
      );
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      final authStorage = const AuthStorage();
      final accessToken = await authStorage.readAccessToken();
      final userId = await authStorage.readUserId();
      final firstName = await authStorage.readFirstName();
      final lastName = await authStorage.readLastName();

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('User id not found');
      }

      await CasePostService().createPostComment(
        accessToken: accessToken,
        postId: widget.post.postId,
        userId: userId,
        commentContent: commentContent,
      );

      if (!mounted) return;

      setState(() {
        _comments = [
          ..._comments,
          ActivePostComment(
            commentContent: commentContent,
            createdAt: DateTime.now().toIso8601String(),
            userInfo: ActivePostUserInfo(
              firstName: firstName ?? '',
              lastName: lastName ?? '',
            ),
          ),
        ];
        _commentController.clear();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment added')));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add comment')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingComment = false;
      });
    }
  }

  Future<void> _confirmVote(
    BuildContext context, {
    required ActivePost post,
    required String selectedVote,
    required String selectedName,
  }) async {
    if (_isSubmittingVote) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: kWhiteColor,
          title: const Text('Confirm Vote'),
          content: Text('Are you sure to cast the vote for $selectedName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final caseId = post.caseDetail?.caseId;
    if (caseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Case id not found for this post')),
      );
      return;
    }

    setState(() {
      _isSubmittingVote = true;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      await CasePostService().submitCasePollVote(
        accessToken: accessToken,
        caseId: caseId,
        endPoll: false,
        ownerVote: selectedVote == 'owner' ? 'Y' : 'N',
        defendantVote: selectedVote == 'defendant' ? 'Y' : 'N',
      );

      if (!mounted) return;
      setState(() {
        _selectedVote = selectedVote;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your vote is polled')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cast vote')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingVote = false;
      });
    }
  }
}

class _PostComparisonPreview extends StatelessWidget {
  final ActivePostMeta? leftMedia;
  final ActivePostMeta? rightMedia;

  const _PostComparisonPreview({
    required this.leftMedia,
    required this.rightMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ComparisonMediaTile(
            media: leftMedia,
            fallbackAsset: Assets.pngPost1Image,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ComparisonMediaTile(
            media: rightMedia,
            fallbackAsset: Assets.pngHighlight1Image,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonMediaTile extends StatefulWidget {
  final ActivePostMeta? media;
  final String fallbackAsset;
  final BorderRadius borderRadius;

  const _ComparisonMediaTile({
    required this.media,
    required this.fallbackAsset,
    required this.borderRadius,
  });

  @override
  State<_ComparisonMediaTile> createState() => _ComparisonMediaTileState();
}

class _ComparisonMediaTileState extends State<_ComparisonMediaTile> {
  VideoPlayerController? _videoController;
  Future<void>? _videoInitialization;
  VoidCallback? _videoListener;

  @override
  void initState() {
    super.initState();
    _setupVideo();
  }

  @override
  void didUpdateWidget(covariant _ComparisonMediaTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media?.metaUrl != widget.media?.metaUrl) {
      _disposeVideoController();
      _setupVideo();
    }
  }

  void _setupVideo() {
    final media = widget.media;
    if (media == null || !media.hasMedia || media.isImage) {
      return;
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(media.metaUrl!));
    _videoController = controller;
    _videoListener = () {
      if (!mounted) return;
      setState(() {});
    };
    controller.addListener(_videoListener!);
    _videoInitialization = controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMedia(),
            if (widget.media != null &&
                widget.media!.hasMedia &&
                !widget.media!.isImage)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openMediaFullscreen(context, widget.media!),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.25),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.play_arrow,
                        color: kWhiteColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia() {
    final media = widget.media;
    if (media == null || !media.hasMedia) {
      return Image.asset(
        widget.fallbackAsset,
        fit: BoxFit.cover,
      );
    }

    if (!media.isImage) {
      if (_videoController == null || _videoInitialization == null) {
        return Image.asset(
          widget.fallbackAsset,
          fit: BoxFit.cover,
        );
      }

      return FutureBuilder<void>(
        future: _videoInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !_videoController!.value.isInitialized) {
            return Container(
              color: kBlackColor.withValues(alpha: 0.85),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: kWhiteColor),
            );
          }

          return FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController!.value.size.width == 0
                  ? 16
                  : _videoController!.value.size.width,
              height: _videoController!.value.size.height == 0
                  ? 9
                  : _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openMediaFullscreen(context, media),
        child: Image.network(
          media.metaUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Image.asset(
            widget.fallbackAsset,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _disposeVideoController() {
    if (_videoController != null && _videoListener != null) {
      _videoController!.removeListener(_videoListener!);
    }
    _videoController?.dispose();
    _videoController = null;
    _videoInitialization = null;
    _videoListener = null;
  }

  void _openMediaFullscreen(BuildContext context, ActivePostMeta media) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FullscreenMediaViewer(
            mediaUrl: media.metaUrl!,
            fallbackAsset: widget.fallbackAsset,
            isImage: media.isImage,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }
}

class _FullscreenMediaViewer extends StatefulWidget {
  final String mediaUrl;
  final String fallbackAsset;
  final bool isImage;

  const _FullscreenMediaViewer({
    required this.mediaUrl,
    required this.fallbackAsset,
    required this.isImage,
  });

  @override
  State<_FullscreenMediaViewer> createState() => _FullscreenMediaViewerState();
}

class _FullscreenMediaViewerState extends State<_FullscreenMediaViewer> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;

  @override
  void initState() {
    super.initState();
    if (!widget.isImage) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl));
      _initialization = _controller!.initialize().then((_) {
        _controller!.play();
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.isImage ? _buildImage() : _buildVideo(),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: kWhiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Image.network(
          widget.mediaUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) =>
              Image.asset(widget.fallbackAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    if (_controller == null || _initialization == null) {
      return Center(
        child: Image.asset(widget.fallbackAsset, fit: BoxFit.contain),
      );
    }

    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !_controller!.value.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(color: kWhiteColor),
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio == 0
                      ? 16 / 9
                      : _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
              AnimatedOpacity(
                opacity: _controller!.value.isPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    Icons.play_arrow,
                    color: kWhiteColor,
                    size: 42,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
