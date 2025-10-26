import 'package:cctv_app/core/components/ad_top_header.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adAdmin/pages/add_new_admin_page.dart';
import 'package:cctv_app/feature/adAdmin/pages/view_all_admin_page.dart';
import 'package:cctv_app/feature/adAdmin/widget/admin_container_widget.dart';
import 'package:cctv_app/feature/adAdmin/widget/view_all_widget.dart';
import 'package:cctv_app/feature/adHome/widget/ad_post_container.dart';
import 'package:flutter/material.dart';

class AdAdminPage extends StatelessWidget {
  const AdAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AdTopHeader(),
            Space.vertical(16),
            Align(
              alignment: Alignment.centerRight,
              child: PrimaryButton(
                height: 34,
                isMainAxisSizeMin: true,
                text: "Add new Admin",
                postfixIcon: Icon(Icons.person, color: kWhiteColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNewAdminPage()),
                  );
                },
              ),
            ),
            Space.vertical(4),
            ViewAllWidget(
              text: "Recent add",
              onClickViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllAdminPage(),
                  ),
                );
              },
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AdminContainerWidget(),
                  Space.horizontal(12),
                  AdminContainerWidget(),
                  Space.horizontal(12),
                  AdminContainerWidget(),
                  Space.horizontal(12),
                  AdminContainerWidget(),
                ],
              ),
            ),
            Space.vertical(4),
            ViewAllWidget(
              text: "Active admin",
              onClickViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllAdminPage(),
                  ),
                );
              },
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AdminContainerWidget(showOnlineStatus: true),
                  Space.horizontal(12),
                  AdminContainerWidget(showOnlineStatus: true),
                  Space.horizontal(12),
                  AdminContainerWidget(showOnlineStatus: true),
                  Space.horizontal(12),
                  AdminContainerWidget(showOnlineStatus: true),
                  Space.horizontal(12),
                  AdminContainerWidget(showOnlineStatus: true),
                ],
              ),
            ),
            Space.vertical(4),
            ViewAllWidget(
              text: "Admin",
              onClickViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllAdminPage(),
                  ),
                );
              },
            ),
            AdPostContainer(),
            Space.vertical(4),
            AdPostContainer(),
            Space.vertical(4),
            AdPostContainer(),
            Space.vertical(4),
            AdPostContainer(),
            Space.vertical(4),
            AdPostContainer(),
            Space.vertical(20),
          ],
        ),
      ),
    );
  }
}
