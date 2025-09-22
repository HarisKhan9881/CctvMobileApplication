import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class TermsAndPolicies extends StatelessWidget {
  const TermsAndPolicies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(backgroundColor: kWhiteColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AGREEMENT",
                style: context.normal.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 14,
                ),
              ),
              Space.vertical(10),
              Text(
                "Terms of Service",
                style: context.bold.copyWith(fontSize: 18),
              ),
              Space.vertical(10),
              Text(
                "Last updated on 5/08/2025",
                style: context.semiBold.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 16,
                ),
              ),
              Space.vertical(10),
              Divider(color: kGreyColor, thickness: 1),
              Space.vertical(10),
              Text("Clause 1", style: context.bold.copyWith(fontSize: 24)),
              Space.vertical(10),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.",
                style: context.normal.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 14,
                ),
              ),
              Space.vertical(10),
              Text("Clause 2", style: context.bold.copyWith(fontSize: 24)),
              Space.vertical(10),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra condimentum eget purus in. Consectetur eget id morbi amet amet, in. Ipsum viverra pretium tellus neque. Ullamcorper suspendisse aenean leo pharetra in sit semper et. Amet quam placerat sem.",
                style: context.normal.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 14,
                ),
              ),
              Space.vertical(10),
            ],
          ),
        ),
      ),
    );
  }
}
