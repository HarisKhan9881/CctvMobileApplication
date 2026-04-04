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
  static const _tabs = [
    'Active Ads',
    'Pending Ads',
    'Scheduled Ads',
    'Cancel Ads',
  ];

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
            _tabs[selectedIndex],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Space.vertical(8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor.withValues(alpha: 0.1) : kWhiteColor,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: isSelected ? kPrimaryColor : kGreyColor,
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        style: context.medium.copyWith(
                          fontSize: 13,
                          color: isSelected ? kPrimaryColor : kDarkGreyColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Space.vertical(8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: selectedIndex == 0
                  ? const ActiveAdView()
                  : selectedIndex == 1
                  ? const PendingAdView()
                  : selectedIndex == 2
                  ? const ScheduleAdView()
                  : const CancelAdView(),
            ),
          ),
        ],
      ),
    );
  }
}
