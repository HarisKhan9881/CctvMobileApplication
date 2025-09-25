import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/home/widgets/custom_profile_post.dart';
import 'package:flutter/material.dart';

class PublicProfilePage extends StatelessWidget {
  const PublicProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Profile", style: context.bold.copyWith(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(Assets.pngUser1Image),
                ),
                Space.horizontal(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hannah Flores",
                      style: context.bold.copyWith(fontSize: 18),
                    ),
                    Text("Online"),
                  ],
                ),
              ],
            ),
            Space.vertical(15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hannah Flores",
                  style: context.bold.copyWith(fontSize: 18),
                ),
                Text("The description of profile"),
              ],
            ),
            Space.vertical(15),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kDarkGreyColor),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(Assets.pngUser2Image),
                      ),
                    ),
                    Text("First"),
                  ],
                ),
                Space.horizontal(12),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kDarkGreyColor),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(Assets.pngUser1Image),
                      ),
                    ),
                    Text("Second"),
                  ],
                ),
              ],
            ),
            Space.vertical(14),
            Row(
              children: [
                Expanded(child: CustomProfilePost()),
                Space.horizontal(12),
                Expanded(child: CustomProfilePost()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
