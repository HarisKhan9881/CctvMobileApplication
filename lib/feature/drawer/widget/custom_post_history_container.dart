import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomPostHistoryContainer extends StatelessWidget {
  const CustomPostHistoryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                Assets.pngHighlight2Image,
                width: 80, // fixed width de do
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Space.horizontal(10),
            Expanded(
              // yaha Expanded add karo
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Food", style: context.bold.copyWith(fontSize: 14)),
                  Space.vertical(4),
                  RichText(
                    text: TextSpan(
                      text:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                      style: context.normal.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' 2:00 pm',
                          style: context.normal.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: kDarkGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Space.vertical(6),
        Divider(color: kGreyColor, thickness: 1),
      ],
    );
  }
}
