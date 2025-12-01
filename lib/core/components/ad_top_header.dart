import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/home/pages/history_screen.dart';
import 'package:cctv_app/feature/profile/pages/ad_profile_page.dart';
import 'package:cctv_app/feature/profile/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AdTopHeader extends StatelessWidget {
  const AdTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdProfilePage()),
            );
          },
          child: CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(Assets.pngUser1Image),
          ),
        ),
        Space.horizontal(10),
        Expanded(
          child: CustomTextField(
            topPadding: 10,
            bottomPadding: 10,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
            hintText: "Search",
            prefix: Icon(Icons.search, color: kDarkGreyColor),
            hintTextColor: kDarkGreyColor,
          ),
        ),
        Space.horizontal(10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: kDarkGreyColor),
            ),
            padding: EdgeInsets.all(10),
            child: SvgPicture.asset(Assets.svgNotificationIcon),
          ),
        ),
      ],
    );
  }
}
