import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCaseContainer extends StatelessWidget {
  const CustomCaseContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreyColor),
      ),
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              Assets.pngHighlight1Image,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Space.vertical(6),
          Text("Food", style: context.bold.copyWith(fontSize: 14)),
          Space.vertical(4),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            style: context.normal.copyWith(
              overflow: TextOverflow.ellipsis,
              fontSize: 12,
              color: kDarkGreyColor,
            ),
          ),
          Space.vertical(6),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: Text(
              "Apr 30, 10:27 am",
              style: context.normal.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 12,
                color: kDarkGreyColor,
              ),
            ),
          ),
        Space.vertical(6),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  height: 45,
                  text: "Remind",
                  prefixIcon: SvgPicture.asset(Assets.svgRemindIcon),
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  onPressed: () {},
                ),
              ),
              Space.horizontal(8),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kGreyColor),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SvgPicture.asset(
                  Assets.svgDeleteIcon,
                  colorFilter: colorFilter(color: kDarkGreyColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
