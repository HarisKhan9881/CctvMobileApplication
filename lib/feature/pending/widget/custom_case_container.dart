import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCaseContainer extends StatelessWidget {
  const CustomCaseContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreyColor),
      ),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              Assets.pngHighlight1Image,
              width: double.infinity,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
          Space.vertical(6),
          Text("Food", style: context.bold.copyWith(fontSize: 14)),
          Space.vertical(4),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            style: context.normal.copyWith(
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              color: kDarkGreyColor,
            ),
          ),
          Space.vertical(6),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: Text(
              "Apr 30, 10:27 am",
              style: context.normal.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 12,
                color: kDarkGreyColor,
              ),
            ),
          ),
          Space.vertical(6),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  height: 45,
                  text: "Remind",
                  prefixIcon: SvgPicture.asset(Assets.svgRemindIcon),
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  onPressed: () {
                    _openReminderSheet(context);
                  },
                ),
              ),
              Space.horizontal(8),
              GestureDetector(
                onTap: () {
                  showDeleteDialog(context);
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kGreyColor),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    Assets.svgDeleteIcon,
                    colorFilter: colorFilter(color: kDarkGreyColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: kWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔴 Title Text
                const Text(
                  "Are you sure you want\nto delete?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // ❌ Cancel Button
                PrimaryButton(
                  text: "No",
                  borderColor: kGreyColor,
                  textColor: kBlackColor,
                  buttonColor: kWhiteColor,
                  showBorder: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Space.vertical(12),

                // ✅ Yes Button
                PrimaryButton(text: "Yes", onPressed: () {}),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openReminderSheet(BuildContext context) {
    AppBottomSheet.show(
      context,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: CupertinoButton(
                child: SvgPicture.asset(Assets.svgCancelIcon),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Text("Pending post"),
            Space.vertical(10),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                width: double.infinity,
                height: 200,
                Assets.pngHighlight2Image,
                fit: BoxFit.cover,
              ),
            ),
            Space.vertical(12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: kDarkGreyColor),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mention your friend or competitor"),
                  Space.vertical(6),
                  Text("@ali", style: context.bold),
                ],
              ),
            ),
            Space.vertical(12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kWhiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color of the shadow
                    spreadRadius: 2, // How much the shadow spreads
                    blurRadius: 3, // How blurry the shadow is
                    offset: Offset(0, 1), // Offset of the shadow (x, y)
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(12),
              child: Text("#Friends #newcase #viral post"),
            ),
            Space.vertical(12),
            Align(alignment: Alignment.centerRight, child: Text("5 min")),
            Space.vertical(12),
            PrimaryButton(text: "Send Reminder", onPressed: () {}),
            Space.vertical(30),
          ],
        ),
      ),
    );
  }
}
