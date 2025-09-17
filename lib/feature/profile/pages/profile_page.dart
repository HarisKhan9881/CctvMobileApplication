import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/profile/widget/profile_tile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Edit", style: context.normal.copyWith(fontSize: 20)),
              Text("Profile", style: context.bold.copyWith(fontSize: 20)),
              Icon(Icons.settings),
            ],
          ),
          Space.vertical(20),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              Assets.pngHighlight1Image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Space.vertical(15),
          Text("Shaq Josh", style: context.bold.copyWith(fontSize: 20)),
          Text(
            "abcdefgh586@gmail.com",
            style: context.normal.copyWith(fontSize: 20),
          ),
          Space.vertical(15),
          ProfileTile(),
        ],
      ),
    );
  }
}
