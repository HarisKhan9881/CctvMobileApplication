import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/ads/pages/stats_page.dart';
import 'package:flutter/material.dart';

class PendingAdContainer extends StatelessWidget {
  const PendingAdContainer({super.key});

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
                "New Arrivals Just Dropped!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Space.vertical(4),
              Text(
                "Linked Page:-x3",

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Space.vertical(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Space.vertical(6),
                      Text(
                        "End Date",
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
                        "May 1, 2025",
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
                    text: "Resume",
                    height: 32,
                    isMainAxisSizeMin: true,
                    buttonColor: kGreenColor,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {},
                  ),
                  Space.horizontal(10),
                  PrimaryButton(
                    text: "End",
                    height: 32,
                    isMainAxisSizeMin: true,
                    showBorder: true,
                    buttonColor: kWhiteColor,
                    borderColor: kGreyColor,
                    textColor: kBlackColor,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () {},
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
}
