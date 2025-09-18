import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:cctv_app/feature/bottomNavBar/user_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: "First Name",
            controller: firstNameController,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.firstName(value);
            },
            suffix: const Icon(Icons.person_outline, color: kDarkGreyColor),
          ),
          Space.vertical(16),
          CustomTextField(
            hintText: "Last Name",
            controller: lastNameController,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.lastName(value);
            },
            suffix: const Icon(Icons.person_outline, color: kDarkGreyColor),
          ),
          Space.vertical(16),
          CustomTextField(
            hintText: "Email",
            controller: emailController,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.email(value);
            },
            suffix: const Icon(Icons.email_outlined, color: kDarkGreyColor),
          ),
          Space.vertical(16),
          CustomTextField(
            hintText: "Password",
            controller: passwordController,
            obscureText: obscurePassword,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              return Validators.password(value);
            },
            suffix: CupertinoButton(
              child: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.remove_red_eye_outlined,
                color: kDarkGreyColor,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
          Space.vertical(16),
          CustomTextField(
            hintText: "Confirm Password",
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword,
            hintTextColor: kDarkGreyColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              if (passwordController.text != confirmPasswordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
            suffix: CupertinoButton(
              child: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.remove_red_eye_outlined,
                color: kDarkGreyColor,
              ),
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
            ),
          ),
          Space.vertical(30),
          PrimaryButton(
            text: "Signup",
            isMainAxisSizeMin: true,
            padding: EdgeInsets.symmetric(horizontal: 50),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserBottomNavBar(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
