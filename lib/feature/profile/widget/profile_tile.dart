import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.search),
            Space.horizontal(20),
            Text("Edit profile", style: context.normal.copyWith(fontSize: 16)),
          ],
        ),
        Space.vertical(12),
        Divider(color: kDarkGreyColor, thickness: 2),
      ],
    );
  }
}
