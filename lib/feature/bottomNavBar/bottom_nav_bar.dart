import 'package:cctv_app/core/components/custom_drawer.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/case/pages/create_case_page.dart';
import 'package:cctv_app/feature/home/pages/home_page.dart';
import 'package:cctv_app/feature/pending/pages/pending_page.dart';
import 'package:cctv_app/feature/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    HomePage(),
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_alt),
                label: 'Pending',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
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
