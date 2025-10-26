import 'package:cctv_app/core/components/custom_drawer.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/utils.dart';
import 'package:cctv_app/feature/adAdmin/pages/ad_admin_page.dart';
import 'package:cctv_app/feature/adHome/pages/ad_home_page.dart';
import 'package:cctv_app/feature/ads/pages/ads_page.dart';
import 'package:cctv_app/feature/announcement/pages/announcement_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AdBottomNavBar extends StatefulWidget {
  const AdBottomNavBar({super.key});

  @override
  State<AdBottomNavBar> createState() => _AdBottomNavBarState();
}

class _AdBottomNavBarState extends State<AdBottomNavBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    AdHomePage(),
    AdsPage(),
    AdAdminPage(),
    AnnouncementPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: SafeArea(bottom: false, child: pages[selectedIndex]),
      backgroundColor: kWhiteColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kBlackColor.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            scaffoldBackgroundColor: kWhiteColor,
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            backgroundColor: kWhiteColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgHomeIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 0 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgAdsIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 1 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Ads',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgAdminIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 2 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Admins',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgAnnouncementIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 3 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Announce',
              ),
            ],
            currentIndex: selectedIndex,
            unselectedItemColor: kDarkGreyColor,
            unselectedLabelStyle: context.normal.copyWith(
              color: kDarkGreyColor,
            ),
            selectedLabelStyle: context.normal.copyWith(color: kPrimaryColor),
            selectedItemColor: kPrimaryColor,
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }
}
