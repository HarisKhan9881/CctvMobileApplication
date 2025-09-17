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
      ),
      body: Column(
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
      ),
    );
  }
}
