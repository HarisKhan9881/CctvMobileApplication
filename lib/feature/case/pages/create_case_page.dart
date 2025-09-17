import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/plain_selection_widget.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({super.key});

  @override
  State<CreateCasePage> createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  bool isPublicSelected = false;
  bool isPrivateSelected = false;
  bool is24HoursSelected = false;
  bool isWeekSelected = false;
  bool isMonthSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create Case", style: context.bold.copyWith(fontSize: 24)),
            Space.vertical(20),
            Text("Case title", style: context.normal),
            Space.vertical(8),
            CustomTextField(
              hintText: "Enter case title",
              hintTextColor: kDarkGreyColor,
            ),
            Space.vertical(16),
            Text("Description", style: context.normal),
            Space.vertical(8),
            CustomTextField(
              hintText: "Enter case description",
              hintTextColor: kDarkGreyColor,
              maxLine: 5,
            ),
            Space.vertical(16),
            Text("Tag user defendants", style: context.normal),
            Space.vertical(8),
            CustomTextField(
              hintText: "@Jasan cole",
              hintTextColor: kDarkGreyColor,
            ),
            Space.vertical(16),
            Text("You want to post", style: context.normal),
            Space.vertical(8),
            Row(
              children: [
                Expanded(
                  child: PlainSelectionWidget(
                    onChange: () {
                      setState(() {
                        isPublicSelected = !isPublicSelected;
                      });
                    },
                    isSelected: isPublicSelected,
                    title: "Public",
                    subTitle: "",
                  ),
                ),
                Expanded(
                  child: PlainSelectionWidget(
                    onChange: () {
                      setState(() {
                        isPrivateSelected = !isPrivateSelected;
                      });
                    },
                    isSelected: isPrivateSelected,
                    title: "Private",
                    subTitle: "",
                  ),
                ),
              ],
            ),
            Space.vertical(16),
            Text("Post publicly available", style: context.normal),
            Space.vertical(8),
            Row(
              children: [
                Expanded(
                  child: PlainSelectionWidget(
                    onChange: () {
                      setState(() {
                        is24HoursSelected = !is24HoursSelected;
                      });
                    },
                    isSelected: is24HoursSelected,
                    title: "24 hours",
                    subTitle: "",
                  ),
                ),
                Expanded(
                  child: PlainSelectionWidget(
                    onChange: () {
                      setState(() {
                        isWeekSelected = !isWeekSelected;
                      });
                    },
                    isSelected: isWeekSelected,
                    title: "Week",
                    subTitle: "",
                  ),
                ),
                Expanded(
                  child: PlainSelectionWidget(
                    onChange: () {
                      setState(() {
                        isMonthSelected = !isMonthSelected;
                      });
                    },
                    isSelected: isMonthSelected,
                    title: "Month",
                    subTitle: "",
                  ),
                ),
              ],
            ),
            Space.vertical(20),
            PrimaryButton(text: "Submit Case", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
