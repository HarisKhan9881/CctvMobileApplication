import 'package:cctv_app/core/components/custom_drawer.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/utils.dart';
import 'package:cctv_app/feature/adAdmin/pages/ad_admin_page.dart';
import 'package:cctv_app/feature/adminHome/pages/admin_home_page.dart';
import 'package:cctv_app/feature/ads/pages/ads_page.dart';
import 'package:cctv_app/feature/announcement/pages/announcement_page.dart';
import 'package:cctv_app/feature/home/pages/home_page.dart';
import 'package:cctv_app/feature/profile/pages/notification_page.dart';
import 'package:cctv_app/feature/superAdmin/pages/super_admin_home_page.dart';
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
  bool _isSuperAdmin = false;
  bool _isRoleResolved = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _loadRoleAccess();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    const AuthStorage().saveLastTabIndex(DashboardType.admin, index);
  }

  Future<void> _loadRoleAccess() async {
    final storage = const AuthStorage();
    final roleDescription = (await storage.readRoleDescription() ?? '')
        .trim()
        .toLowerCase();
    final roleId = await storage.readRoleId();
    final isSuperAdmin = roleDescription == 'super admin' || roleId == 3;

    if (!mounted) return;
    setState(() {
      _isSuperAdmin = isSuperAdmin;
      _isRoleResolved = true;
      selectedIndex = widget.initialIndex.clamp(0, _pages.length - 1);
    });
  }

  List<Widget> get _pages => _isSuperAdmin
      ? [
          SuperAdminHomePage(),
          AdsPage(),
          AdAdminPage(),
          AnnouncementPage(),
        ]
      : [
          AdminHomePage(),
          HomePage(isAdmin: true),
          AnnouncementPage(),
          NotificationPage(),
        ];

  List<BottomNavigationBarItem> _buildItems() => _isSuperAdmin
      ? [
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
        ]
      : [
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
        ];

  @override
  Widget build(BuildContext context) {
    if (!_isRoleResolved) {
      return const Scaffold(
        backgroundColor: kWhiteColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: CustomDrawer(onHomeTap: () => onItemTapped(0)),
      body: SafeArea(bottom: false, child: _pages[selectedIndex]),
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
            selectedFontSize: 10,
            unselectedFontSize: 10,
            iconSize: 20,
            items: _buildItems(),
            currentIndex: selectedIndex,
            unselectedItemColor: kDarkGreyColor,
            unselectedLabelStyle: context.normal.copyWith(
              color: kDarkGreyColor,
              fontSize: 10,
            ),
            selectedLabelStyle: context.normal.copyWith(
              color: kPrimaryColor,
              fontSize: 10,
            ),
            selectedItemColor: kPrimaryColor,
            onTap: onItemTapped,
          ),
        ),
      ),
    );
  }
}
