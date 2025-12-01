import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/ads/pages/stats_page.dart';
import 'package:flutter/material.dart';

class ActiveAdContainer extends StatelessWidget {
  const ActiveAdContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kGreyColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(Assets.pngHighlight2Image, fit: BoxFit.fill),
          ),
          Space.horizontal(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Summer Sale – 30% Off",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Space.vertical(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Space.vertical(6),
                      Text(
                        "Run Days",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Space.horizontal(60),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "May 1, 2025",
                        style: TextStyle(fontSize: 14, color: kDarkGreyColor),
                      ),
                      Space.vertical(6),
                      Text(
                        "12 days",
                        style: TextStyle(fontSize: 14, color: kDarkGreyColor),
                      ),
                    ],
                  ),
                ],
              ),
              Space.vertical(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryButton(
                    text: "End",
                    height: 32,
                    isMainAxisSizeMin: true,
                    buttonColor: kRedColor,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      showEndAdDialog(context);
                    },
                  ),
                  Space.horizontal(10),
                  PrimaryButton(
                    text: "Pause",
                    height: 32,
                    isMainAxisSizeMin: true,
                    showBorder: true,
                    buttonColor: kWhiteColor,
                    borderColor: kGreyColor,
                    textColor: kBlackColor,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      showPauseAdDialog(context);
                    },
                  ),
                  Space.horizontal(10),
                  PrimaryButton(
                    text: "Stats",
                    height: 32,
                    isMainAxisSizeMin: true,
                    showBorder: true,
                    buttonColor: kWhiteColor,
                    borderColor: kGreyColor,
                    textColor: kBlackColor,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StatsPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showEndAdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: kWhiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Space.vertical(10),
              const Text(
                "Stopping this ad will immediately pause its visibility on the app. Users will no longer see it until you reactivate.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              Space.vertical(10),
              const Text(
                "Do you still want to proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              Space.vertical(20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(color: kRedColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "No",
                        style: context.normal.copyWith(color: kBlackColor),
                      ),
                    ),
                  ),
                  Space.horizontal(10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kRedColor,
                        border: Border.all(color: kRedColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes",
                        style: context.normal.copyWith(color: kWhiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showPauseAdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: kWhiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Space.vertical(10),
              const Text(
                "Pausing this ad will temporarily stop its visibility. You can resume it anytime from your dashboard.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              Space.vertical(10),
              const Text(
                "Do you still want to proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              Space.vertical(20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "No",
                        style: context.normal.copyWith(color: kBlackColor),
                      ),
                    ),
                  ),
                  Space.horizontal(10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes",
                        style: context.normal.copyWith(color: kWhiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
