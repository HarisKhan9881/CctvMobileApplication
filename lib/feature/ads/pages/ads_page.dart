import 'package:cctv_app/core/components/ad_top_header.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
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
  int _selectedIndex = 0;

  final List<String> _tabTitles = [
    'Active Ads',
    'Pending Ads',
    'Scheduled Ads',
    'Cancelled Ads',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Padding(
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
              _tabTitles[_selectedIndex],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Space.vertical(8),
            TabBar(
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              dividerColor: kTransparentColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              indicatorWeight: 2,
              labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'Pending'),
                Tab(text: 'Scheduled'),
                Tab(text: 'Cancel'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ActiveAdView(),
                  PendingAdView(),
                  ScheduleAdView(),
                  CancelAdView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
