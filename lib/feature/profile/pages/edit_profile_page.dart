import 'package:cctv_app/core/components/custom_dropdown.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = "Shaq";
    lastNameController.text = "Josh";
    emailController.text = "shaq.josh@example.com";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Edit Profile"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "First Name",
                  style: context.normal.copyWith(fontSize: 16),
                ),
                Space.vertical(8),
                CustomTextField(
                  hintText: "Enter first name",
                  controller: firstNameController,
                  suffix: Icon(Icons.person_outlined, color: kDarkGreyColor),
                  validator: (val) {
                    return Validators.userName(val);
                  },
                ),
                Space.vertical(16),
                Text("Last Name", style: context.normal.copyWith(fontSize: 16)),
                Space.vertical(8),
                CustomTextField(
                  hintText: "Enter last name",
                  controller: lastNameController,
                  suffix: Icon(Icons.person_outlined, color: kDarkGreyColor),
                  validator: (val) {
                    return Validators.userName(val);
                  },
                ),
                Space.vertical(16),
                Text("Email", style: context.normal.copyWith(fontSize: 16)),
                Space.vertical(8),
                CustomTextField(
                  hintText: "Enter email",
                  controller: emailController,
                  suffix: Icon(Icons.email_outlined, color: kDarkGreyColor),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    return Validators.email(val);
                  },
                ),
                Space.vertical(16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gender",
                            style: context.normal.copyWith(fontSize: 16),
                          ),
                          Space.vertical(8),
                          CustomDropdown(
                            value: "Select gender",
                            items: [],
                            hint: "Select gender",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                          ),
                        ],
                      ),
                    ),
                    Space.horizontal(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "State",
                            style: context.normal.copyWith(fontSize: 16),
                          ),
                          Space.vertical(8),
                          CustomDropdown(
                            value: "Select state",
                            items: [],
                            hint: "Select state",
                            screenWidth: screenWidth,
                            isSmallScreen: isSmallScreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Space.vertical(30),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: "Cancel",
                        borderColor: kPrimaryColor,
                        buttonColor: kWhiteColor,
                        textColor: kBlackColor,
                        showBorder: true,
                        onPressed: () {},
                      ),
                    ),
                    Space.horizontal(10),
                    Expanded(
                      child: PrimaryButton(text: "Update", onPressed: () {}),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
