import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/custom_menu_button.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adminHome/pages/report_and_suspend.dart';
import 'package:cctv_app/feature/home/widgets/comment_container.dart';
import 'package:cctv_app/feature/home/widgets/vote_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePostContainer extends StatefulWidget {
  final bool isAdmin;
  final VoidCallback onClickProfile;
  const HomePostContainer({
    super.key,
    required this.isAdmin,
    required this.onClickProfile,
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

  @override
  Widget build(BuildContext context) {
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
                            Text("Hannah Flores", style: context.semiBold),
                            Text("2 mints ago", style: context.normal),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Who's Right", style: context.bold.copyWith(fontSize: 20)),
                Text(
                  "6 hours left",
                  style: context.normal.copyWith(color: kDarkGreyColor),
                ),
              ],
            ),
            Space.vertical(20),
            Row(
              children: [
                Expanded(child: Image.asset(Assets.pngPost1Image)),
                Space.horizontal(20),
                Expanded(child: Image.asset(Assets.pngPost1Image)),
              ],
            ),
            Space.vertical(15),
            VotingResultExample(),
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
                  text: "42",
                  onTap: () {
                    setState(() {
                      areCommentsVisible = !areCommentsVisible;
                    });
                  },
                  icon: Icons.message,
                ),
                reactionContainer(
                  text: "09",
                  onTap: () {},
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
                                  Text("12"),
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
              CommentContainer(),
              Space.vertical(10),
              CommentContainer(),
              Space.vertical(10),

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
                      color: Colors.black.withOpacity(0.1),
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

  void _hideReactionPopup() {
    setState(() {
      isReactionPopupVisible = false;
    });
    reactionOverlay?.remove();
    reactionOverlay = null;
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

  @override
  void dispose() {
    reactionOverlay?.remove();
    super.dispose();
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
