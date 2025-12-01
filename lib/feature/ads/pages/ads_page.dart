import 'package:cctv_app/core/components/ad_top_header.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/ads/pages/active_ad_view.dart';
import 'package:cctv_app/feature/ads/pages/cancel_ad_view.dart';
import 'package:cctv_app/feature/ads/pages/create_ad_page.dart';
import 'package:cctv_app/feature/ads/pages/pending_ad_view.dart';
import 'package:cctv_app/feature/ads/pages/schedule_ad_view.dart';
import 'package:flutter/material.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdTopHeader(),
          Space.vertical(20),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              text: "Create new ads",
              height: 36,
              isMainAxisSizeMin: true,
              postfixIcon: Icon(Icons.add, color: kWhiteColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAdPage()),
                );
              },
            ),
          ),
          Space.vertical(20),
          Text(
            selectedIndex == 0
                ? "Active Ads"
                : selectedIndex == 1
                ? "Pending Ads"
                : selectedIndex == 2
                ? "Scheduled Ads"
                : "Cancel Ads",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Space.vertical(8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 0
                              ? kPrimaryColor
                              : kTransparentColor,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 2),
                    alignment: Alignment.center,
                    child: Text(
                      "Active Ads",
                      style: context.normal.copyWith(
                        color: selectedIndex == 0
                            ? kBlackColor
                            : kDarkGreyColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print("1 ok");
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 1
                              ? kPrimaryColor
                              : kTransparentColor,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 2),
                    alignment: Alignment.center,
                    child: Text(
                      "Pending Ads",
                      style: context.normal.copyWith(
                        color: selectedIndex == 1
                            ? kBlackColor
                            : kDarkGreyColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 2
                              ? kPrimaryColor
                              : kTransparentColor,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 2),
                    alignment: Alignment.center,
                    child: Text(
                      "Scheduled Ads",
                      style: context.normal.copyWith(
                        color: selectedIndex == 2
                            ? kBlackColor
                            : kDarkGreyColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 3
                              ? kPrimaryColor
                              : kTransparentColor,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 2),
                    alignment: Alignment.center,
                    child: Text(
                      "Cancel Ads",
                      style: context.normal.copyWith(
                        color: selectedIndex == 3
                            ? kBlackColor
                            : kDarkGreyColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Space.vertical(8),
          selectedIndex == 0
              ? ActiveAdView()
              : selectedIndex == 1
              ? PendingAdView()
              : selectedIndex == 2
              ? ScheduleAdView()
              : CancelAdView(),
        ],
      ),
    );
  }
}
