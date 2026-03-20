import 'package:cctv_app/core/components/custom_drawer.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/utils.dart';
import 'package:cctv_app/feature/adminHome/pages/admin_home_page.dart';
import 'package:cctv_app/feature/announcement/pages/announcement_page.dart';
import 'package:cctv_app/feature/home/pages/home_page.dart';
import 'package:cctv_app/feature/profile/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AdminBottomNavBar extends StatefulWidget {
  final int initialIndex;
  const AdminBottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  late int selectedIndex;

  final List<Widget> pages = [
    AdminHomePage(),
    HomePage(isAdmin: true),
    AnnouncementPage(),
    NotificationPage(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex.clamp(0, pages.length - 1);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    const AuthStorage().saveLastTabIndex(DashboardType.admin, index);
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
                  Assets.svgCommunityIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 1 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgAnnouncementIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 2 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Announce',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgNotifyIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 3 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Notify',
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
