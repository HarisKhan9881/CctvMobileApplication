import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CaseResponsePage extends StatelessWidget {
  const CaseResponsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Response", style: context.bold.copyWith(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create Case", style: context.bold.copyWith(fontSize: 18)),
              Space.vertical(20),
              Text(
                "Attach Video",
                style: context.normal.copyWith(fontSize: 16),
              ),
              Space.vertical(10),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 🔹 Background Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        Assets.pngHighlight2Image,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // 🔹 Semi-transparent overlay (optional)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    // 🔹 Play icon at center
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.play_arrow,
                        color: kWhiteColor,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Space.vertical(16),
              Text("Responds", style: context.normal.copyWith(fontSize: 16)),
              Space.vertical(10),
              DottedBorder(
                options: RectDottedBorderOptions(
                  color: kPrimaryColor,
                  dashPattern: [5, 5],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SvgPicture.asset(Assets.svgMusicIcon),
                        Space.vertical(15),
                        Text(
                          "Attach video and audio Max 3 min length",
                          style: context.normal.copyWith(color: kPrimaryColor),
                        ),
                        Space.vertical(15),
                        PrimaryButton(
                          height: 40,
                          isMainAxisSizeMin: true,
                          text: "Browse files",
                          buttonColor: kWhiteColor,
                          textColor: kBlackColor,
                          showBorder: true,
                          prefixIcon: Icon(Icons.attach_file),
                          borderColor: kPrimaryColor,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Space.vertical(10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "15:45 now (3:45 PM)",
                  style: context.normal.copyWith(fontSize: 14),
                ),
              ),
              Space.vertical(16),
              Text(
                "Terms and conditions",
                style: context.bold.copyWith(fontSize: 18),
              ),
              Space.vertical(10),
              Text(
                "By uploading a file, you confirm that you own the rights to the content or have permission to share it. The app is not responsible for any unauthorized, harmful, or illegal files uploaded by users. Inappropriate files may be removed and accounts suspended.",
              ),
              Space.vertical(20),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: "Clear",
                      showBorder: true,
                      buttonColor: kWhiteColor,
                      borderColor: kGreyColor,
                      textColor: kBlackColor,
                      onPressed: () {},
                    ),
                  ),
                  Space.horizontal(10),
                  Expanded(
                    child: PrimaryButton(text: "Submit Case", onPressed: () {}),
                  ),
                ],
              ),
              Space.vertical(40),
            ],
          ),
        ),
      ),
    );
  }
}
