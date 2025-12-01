import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(backgroundColor: kWhiteColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton(
                  text: "View Post",
                  height: 40,
                  isMainAxisSizeMin: true,
                  onPressed: () {},
                ),
              ),
              Space.vertical(20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Culpa aliquam consequnntur veritatis at",
                  style: context.semiBold.copyWith(fontSize: 18),
                ),
              ),
              Space.vertical(20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  Assets.pngHighlight2Image,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Space.vertical(12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Important note",
                  style: context.semiBold.copyWith(fontSize: 18),
                ),
              ),
              Space.vertical(10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kGreyColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(10),
                child: Text(
                  "Donec a eros justo. Fusce egestas tristique ultrices. Nam tempor, augue nec tincidunt molestie, massa nunc varius arcu, at scelerisque elit erat a magna. Donec quis erat at libero ultrices mollis. In hac habitasse platea dictumst. Vivamus vehicula leo dui, at porta nisi facilisis finibus. In euismod augue vitae nisi ultricies, non aliquet urna tincidunt. Integer in nisi eget nulla commodo faucibus efficitur quis massa. Praesent felis est, finibus et nisi ac, hendrerit venenatis libero. Donec consectetur faucibus ipsum id gravida.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
