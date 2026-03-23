import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/custom_menu_button.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
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
  VideoPlayerController? _videoController;
  Future<void>? _videoInitialization;
  VoidCallback? _videoListener;

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
  void initState() {
    super.initState();
    final media = widget.post.caseDetail?.meta;
    if (media != null && media.hasMedia && !media.isImage) {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(media.metaUrl!),
      );
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
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final author = post.createdByUserInfo?.fullName.isNotEmpty == true
        ? post.createdByUserInfo!.fullName
        : 'Unknown User';
    final timeText = _timeLabel(post.createdAt);
    final media = post.caseDetail?.meta;
    final firstDefendant = post.defendantDetails.isNotEmpty
        ? post.defendantDetails.first.userInfo?.fullName ?? 'Defendant'
        : 'Defendant';
    final secondLabel = post.createdByUserInfo?.fullName.isNotEmpty == true
        ? post.createdByUserInfo!.fullName
        : 'Creator';

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
            _PostMediaPreview(
              media: media,
              videoController: _videoController,
              videoInitialization: _videoInitialization,
            ),
            if (post.postDescription.trim().isNotEmpty) ...[
              Space.vertical(12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  post.postDescription,
                  style: context.normal,
                ),
              ),
            ],
            Space.vertical(15),
            VotingResultExample(
              leftLabel: 'A.',
              leftText: firstDefendant,
              rightLabel: 'B.',
              rightText: secondLabel,
            ),
            Space.vertical(15),
            PrimaryButton(
              height: 40,
              text: "Resolutions",
              onPressed: () {
                _showSimpleDialog(context);
              },
            ),
            Space.vertical(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onLongPressStart: (details) {
                    _showReactionPopup(details.globalPosition);
                  },
                  child: reactionContainer(
                    text: selectedReaction ?? "Like",
                    onTap: () {
                      if (isReactionPopupVisible) {
                        // If popup is visible, don't toggle reaction
                        return;
                      }
                      if (selectedReaction != null) {
                        setState(() {
                          selectedReaction = null;
                        });
                      } else {
                        setState(() {
                          selectedReaction = "Like";
                        });
                      }
                    },
                    icon: _getReactionIcon(),
                  ),
                ),
                reactionContainer(
                  text: "${post.comments.length}",
                  onTap: () {
                    setState(() {
                      areCommentsVisible = !areCommentsVisible;
                    });
                  },
                  icon: Icons.message,
                ),
                reactionContainer(
                  text: "${post.reactions.length}",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RepostScreen()),
                    );
                  },
                  icon: Icons.replay_circle_filled,
                ),
                Directionality(
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "${post.reactionSummary?.totalReactions ?? post.reactions.length}",
                                  ),
                                  Space.horizontal(8),
                                  Icon(Icons.share, color: kPrimaryColor),
                                ],
                              ),
                            ),
                          );
                        },
                    menuChildren: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          right: 26,
                          bottom: 8,
                        ),
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
                ),
                // reactionContainer(text: "13", onTap: () {}, icon: Icons.share),
              ],
            ),
            SizedBox(height: 16),
            if (areCommentsVisible) ...[
              if (post.comments.isEmpty)
                Text(
                  "No comments yet",
                  style: context.normal.copyWith(color: kDarkGreyColor),
                )
              else
                ...post.comments.map((comment) {
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
              CustomTextField(
                hintText: "Write comment here",
                hintTextColor: kDarkGreyColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_videoController != null && _videoListener != null) {
      _videoController!.removeListener(_videoListener!);
    }
    _videoController?.dispose();
    reactionOverlay?.remove();
    super.dispose();
  }

  Widget reactionContainer({
    required String text,
    required VoidCallback onTap,
    required IconData icon,
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
            Icon(icon, color: kPrimaryColor),
            Space.horizontal(8),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(String emoji, String reaction) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReaction = reaction;
          isReactionPopupVisible = false;
        });
        _hideReactionPopup();
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
    if (reactionOverlay != null) return;

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
                    _buildReactionButton("❤️", "Love"),
                    _buildReactionButton("😂", "Haha"),
                    _buildReactionButton("😮", "Wow"),
                    _buildReactionButton("😢", "Sad"),
                    _buildReactionButton("😡", "Angry"),
                    _buildReactionButton("👍", "Like"),
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

  void _showSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kWhiteColor,

          content: Column(
            mainAxisSize: MainAxisSize.min,
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
              Text('David Elson', style: context.bold),
              SizedBox(height: 10),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.......',
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.......',
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.......',
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
}

class _PostMediaPreview extends StatelessWidget {
  final ActivePostMeta? media;
  final VideoPlayerController? videoController;
  final Future<void>? videoInitialization;

  const _PostMediaPreview({
    required this.media,
    required this.videoController,
    required this.videoInitialization,
  });

  @override
  Widget build(BuildContext context) {
    if (media == null || !media!.hasMedia) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          Assets.pngPost1Image,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
      );
    }

    if (media!.isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 220,
          width: double.infinity,
          color: kBlackColor.withValues(alpha: 0.04),
          child: Image.network(
            media!.metaUrl!,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Image.asset(
              Assets.pngPost1Image,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    if (videoController == null || videoInitialization == null) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kBlackColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.videocam, color: kWhiteColor, size: 40),
      );
    }

    return FutureBuilder<void>(
      future: videoInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !videoController!.value.isInitialized) {
          return Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kBlackColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: kWhiteColor),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoController!.value.size.width == 0
                          ? 16
                          : videoController!.value.size.width,
                      height: videoController!.value.size.height == 0
                          ? 9
                          : videoController!.value.size.height,
                      child: VideoPlayer(videoController!),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (videoController!.value.isPlaying) {
                          videoController!.pause();
                        } else {
                          videoController!.play();
                        }
                      },
                      child: videoController!.value.isPlaying
                          ? const SizedBox.shrink()
                          : Container(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
