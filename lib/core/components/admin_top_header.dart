import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adminHome/pages/report_and_suspend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AdminTopHeader extends StatelessWidget {
  const AdminTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(Assets.pngUser1Image),
        ),
        Space.horizontal(10),
        Expanded(
          child: CustomTextField(
            topPadding: 10,
            bottomPadding: 10,
            hintText: "Search",
            prefix: Icon(Icons.search, color: kDarkGreyColor),
            hintTextColor: kDarkGreyColor,
          ),
        ),
        Space.horizontal(10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportAndSuspend()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: kDarkGreyColor),
            ),
            padding: EdgeInsets.all(10),
            child: SvgPicture.asset(Assets.svgNoteBookIcon),
          ),
        ),
      ],
    );
  }
}
