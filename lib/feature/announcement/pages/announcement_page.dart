import 'package:cctv_app/core/components/custom_dropdown.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/search_bar_header.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBarHeader(),
            Space.vertical(20),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kGreyColor),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history),
                    Space.horizontal(4),
                    Text("History", style: context.normal),
                  ],
                ),
              ),
            ),
            Space.vertical(10),
            Center(
              child: Text(
                "Send Alerts",
                style: context.bold.copyWith(fontSize: 24),
              ),
            ),
            Space.vertical(10),
            Text("Select Category", style: context.normal),
            Space.vertical(10),
            CustomDropdown(
              value: "Select category",
              items: [],
              hint: "Select category",
              screenWidth: screenWidth,
              isSmallScreen: isSmallScreen,
            ),
            Space.vertical(20),
            Text("Important Note", style: context.normal),
            Space.vertical(10),
            CustomTextField(
              hintText: "Write message",
              hintTextColor: kDarkGreyColor,
              maxLine: 6,
            ),
            Space.vertical(20),
            Text("IAttached file (Optional)", style: context.normal),
            Space.vertical(10),
            CustomTextField(
              hintText: "",
              hintTextColor: kDarkGreyColor,
              suffix: Icon(Icons.attach_file),
            ),
            Space.vertical(20),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: "Clear",
                    buttonColor: kWhiteColor,
                    textColor: kBlackColor,
                    borderColor: kGreyColor,
                    showBorder: true,
                    onPressed: () {},
                  ),
                ),
                Space.horizontal(10),
                Expanded(
                  child: PrimaryButton(text: "Submit", onPressed: () {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
