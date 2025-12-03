import 'package:cctv_app/core/components/custom_menu_button.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/home/widgets/vote_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class RepostScreen extends StatefulWidget {
  final bool? isAdmin;
  const RepostScreen({super.key, this.isAdmin});

  @override
  State<RepostScreen> createState() => _RepostScreenState();
}

class _RepostScreenState extends State<RepostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Text(
                "Repost",
                textAlign: TextAlign.left,
                style: context.bold.copyWith(fontSize: 16),
              ),
              SizedBox(height: 1.h),
              CustomTextField(hintText: "Enter your opinion", maxLine: 8),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
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
                  Text(
                    "Who's Right?",
                    style: context.bold.copyWith(fontSize: 20),
                  ),
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
              Space.vertical(15),
              PrimaryButton(
                height: 40,
                text: "Repost",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(4.3),
                  child: Image.asset(Assets.repostIcon, height: 1.h),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Space.vertical(20),
            ],
          ),
        ),
      ),
    );
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
