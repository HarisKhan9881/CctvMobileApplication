import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/profile/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarHeader extends StatelessWidget {
  const SearchBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kGreyColor),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  Assets.svgMenuIcon,
                  colorFilter: ColorFilter.mode(
                    kDarkGreyColor,
                    BlendMode.srcIn,
                  ),
                  width: 15,
                  height: 15,
                ),
              ),
            );
          },
        ),

        Space.horizontal(10),
        Expanded(
          child: CustomTextField(
            topPadding: 10,
            bottomPadding: 10,
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
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kGreyColor),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              Assets.svgNotificationIcon,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
    );
  }
}
