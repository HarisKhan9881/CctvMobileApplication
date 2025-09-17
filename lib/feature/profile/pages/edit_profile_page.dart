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
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    return Validators.email(val);
                  },
                ),
                Space.vertical(30),
                PrimaryButton(text: "Update", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
