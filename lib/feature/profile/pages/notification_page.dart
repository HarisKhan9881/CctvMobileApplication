import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Notifications"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(Assets.svgDoubleTickIcon),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Space.vertical(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: AssetImage(Assets.pngUser1Image)),
                Space.horizontal(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hannah Flores",
                        style: context.bold.copyWith(fontSize: 16),
                      ),
                      Text("Someone tag please response"),
                    ],
                  ),
                ),
                Space.horizontal(12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    width: 40,
                    height: 40,
                    Assets.pngHighlight2Image,
                  ),
                ),
              ],
            ),
            Space.vertical(6),
            Divider(color: kGreyColor, thickness: 1),
            Space.vertical(6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: AssetImage(Assets.pngUser1Image)),
                Space.horizontal(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hannah Flores",
                        style: context.bold.copyWith(fontSize: 16),
                      ),
                      Text("Someone tag please response"),
                    ],
                  ),
                ),
                Space.horizontal(12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    width: 40,
                    height: 40,
                    Assets.pngHighlight2Image,
                  ),
                ),
              ],
            ),
            Space.vertical(6),
            Divider(color: kGreyColor, thickness: 1),
            Space.vertical(6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: AssetImage(Assets.pngUser1Image)),
                Space.horizontal(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hannah Flores",
                        style: context.bold.copyWith(fontSize: 16),
                      ),
                      Text("Someone tag please response"),
                    ],
                  ),
                ),
                Space.horizontal(12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    width: 40,
                    height: 40,
                    Assets.pngHighlight2Image,
                  ),
                ),
              ],
            ),
            Space.vertical(6),
            Divider(color: kGreyColor, thickness: 1),
            Space.vertical(6),
          ],
        ),
      ),
    );
  }

  Widget emptyNotification(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: SvgPicture.asset(Assets.svgNotificationImage)),
        Space.vertical(20),
        Text(
          "No new notifications",
          style: context.normal.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
