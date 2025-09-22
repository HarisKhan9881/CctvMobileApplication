import 'package:cctv_app/core/components/custom_drawer.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/utils.dart';
import 'package:cctv_app/feature/case/pages/create_case_page.dart';
import 'package:cctv_app/feature/home/pages/home_page.dart';
import 'package:cctv_app/feature/pending/pages/pending_page.dart';
import 'package:cctv_app/feature/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserBottomNavBar extends StatefulWidget {
  const UserBottomNavBar({super.key});

  @override
  State<UserBottomNavBar> createState() => _UserBottomNavBarState();
}

class _UserBottomNavBarState extends State<UserBottomNavBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    HomePage(isAdmin: false),
    CreateCasePage(),
    PendingPage(),
    ProfilePage(),
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
                  Assets.svgCreateIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 1 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgPendingIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 2 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Pending',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.svgProfileIcon,
                  colorFilter: colorFilter(
                    color: selectedIndex == 3 ? kPrimaryColor : kDarkGreyColor,
                  ),
                ),
                label: 'Profile',
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
