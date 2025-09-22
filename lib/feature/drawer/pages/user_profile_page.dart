import 'package:cctv_app/core/components/custom_dropdown.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/plain_selection_widget.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isPublicSelected = false;
  bool isPrivateSelected = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(backgroundColor: kWhiteColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(Assets.pngUser1Image),
                        ),
                        Space.horizontal(16),
                        Text(
                          "Upload Profile Photo",
                          style: context.normal.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                    Space.vertical(20),
                    Text("First Name", style: context.semiBold),
                    Space.vertical(6),
                    CustomTextField(
                      hintText: "First Name",
                      hintTextColor: kDarkGreyColor,
                    ),
                    Space.vertical(10),
                    Text("Last Name", style: context.semiBold),
                    Space.vertical(6),
                    CustomTextField(
                      hintText: "Last Name",
                      hintTextColor: kDarkGreyColor,
                    ),
                    Space.vertical(10),
                    Text("Phone Number", style: context.semiBold),
                    Space.vertical(6),
                    CustomTextField(
                      hintText: "Phone Number",
                      hintTextColor: kDarkGreyColor,
                    ),
                    Space.vertical(10),
                    Text("Location", style: context.semiBold),
                    Space.vertical(6),
                    CustomDropdown(
                      value: "Select Location",
                      items: [],
                      hint: "Select Location",
                      screenWidth: screenWidth,
                      isSmallScreen: isSmallScreen,
                    ),
                    Space.vertical(10),
                    Text("Birthday", style: context.semiBold),
                    Space.vertical(6),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            value: "Month",
                            items: [],
                            hint: "Month",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        Space.horizontal(6),
                        Expanded(
                          child: CustomDropdown(
                            value: "Day",
                            items: [],
                            hint: "Day",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                        Space.horizontal(6),
                        Expanded(
                          child: CustomDropdown(
                            value: "Year",
                            items: [],
                            hint: "Year",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                    Space.vertical(10),
                    Text("Profile", style: context.semiBold),
                    Space.vertical(6),
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
                    Space.vertical(10),
                    Text("Gender", style: context.semiBold),
                    Space.vertical(6),
                    CustomDropdown(
                      value: "Select Gender",
                      items: [],
                      hint: "Select Gender",
                      screenWidth: screenWidth,
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
              ),
            ),

            Space.vertical(20),
            PrimaryButton(text: "Save", onPressed: () {}),
            Space.vertical(30),
          ],
        ),
      ),
    );
  }
}
