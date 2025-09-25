import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/auth/widget/signin_view.dart';
import 'package:cctv_app/feature/auth/widget/signup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Space.vertical(20),
                  Image.asset(Assets.pngAppLogoImage, width: 100, height: 100),
                  Space.vertical(30),
                  Container(
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      border: Border.all(color: kGreyColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isAdmin = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isAdmin ? kPrimaryColor : kWhiteColor,
                                border: Border.all(
                                  color: isAdmin
                                      ? kTransparentColor
                                      : kGreyColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "As a Admin",
                                style: context.medium.copyWith(
                                  color: isAdmin ? kWhiteColor : kDarkGreyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Space.horizontal(10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isAdmin = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isAdmin ? kWhiteColor : kPrimaryColor,
                                border: Border.all(
                                  color: isAdmin
                                      ? kGreyColor
                                      : kTransparentColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "As a User",
                                style: context.medium.copyWith(
                                  color: isAdmin ? kDarkGreyColor : kWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Space.vertical(30),
                  isAdmin
                      ? SigninView()
                      : isLogin
                      ? SigninView()
                      : SignupView(),
                  Space.vertical(20),
                  isAdmin
                      ? SizedBox()
                      : isLogin
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "New User?",
                              style: context.medium.copyWith(
                                color: kDarkGreyColor,
                                fontSize: 14,
                              ),
                            ),
                            CupertinoButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = false;
                                });
                              },
                              padding: EdgeInsets.zero,
                              child: Text(
                                " Sign Up",
                                style: context.semiBold.copyWith(
                                  color: kBlackColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: context.medium.copyWith(
                                color: kDarkGreyColor,
                                fontSize: 14,
                              ),
                            ),
                            CupertinoButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = true;
                                });
                              },
                              padding: EdgeInsets.zero,
                              child: Text(
                                "Login",
                                style: context.semiBold.copyWith(
                                  color: kBlackColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
