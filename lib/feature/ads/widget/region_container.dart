import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class RegionContainer extends StatelessWidget {
  const RegionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(Assets.pngFlagImage),
                Space.horizontal(10),
                Text(
                  "United States",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              "8,678,989",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: kDarkGreyColor,
              ),
            ),
          ],
        ),
        Divider(color: kDarkGreyColor.withOpacity(0.2), thickness: 1),
      ],
    );
  }
}
