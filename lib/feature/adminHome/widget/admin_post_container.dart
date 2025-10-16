import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class AdminPostContainer extends StatelessWidget {
  const AdminPostContainer({super.key});

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
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              Assets.pngHighlight1Image,
              width: 100,
              height: 100,
            ),
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
                Text(
                  "5 May, 1 hr 30 min",
                  overflow: TextOverflow.ellipsis,
                  style: context.normal.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          Space.horizontal(10),
          Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
