import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class AdPostContainer extends StatelessWidget {
  const AdPostContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: kGreyColor),
      ),
      padding: EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(Assets.pngHighlight1Image),
          ),
          Space.horizontal(10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "I need your support, not criticism.",
                  style: context.bold.copyWith(fontSize: 14),
                ),
                Space.vertical(8),
                Row(
                  children: [
                    Text(
                      "Online",
                      overflow: TextOverflow.ellipsis,
                      style: context.semiBold.copyWith(
                        fontSize: 14,
                        color: kBlackColor,
                      ),
                    ),
                    Space.horizontal(6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: kBlackColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Space.horizontal(6),
                    Text(
                      "Jul 7, 2025 7:16 am",
                      overflow: TextOverflow.ellipsis,
                      style: context.normal.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Space.horizontal(10),
          Icon(Icons.more_vert, color: kDarkGreyColor),
        ],
      ),
    );
  }
}
