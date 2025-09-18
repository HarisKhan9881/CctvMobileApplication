import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:cctv_app/feature/bottomNavBar/admin_bottom_nav_bar.dart';
import 'package:cctv_app/feature/bottomNavBar/user_bottom_nav_bar.dart';
import 'package:cctv_app/feature/forgotPassword/pages/forgot_pasword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
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
          Align(
            alignment: Alignment.centerRight,
            child: CupertinoButton(
              child: Text(
                "Forget password",
                style: context.medium.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasword(),
                  ),
                );
              },
            ),
          ),
          Space.vertical(30),
          PrimaryButton(
            text: "Login",
            isMainAxisSizeMin: true,
            padding: EdgeInsets.symmetric(horizontal: 50),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (emailController.text.trim() == "admin@gmail.com" &&
                    passwordController.text.trim() == "12345678") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminBottomNavBar(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserBottomNavBar(),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
