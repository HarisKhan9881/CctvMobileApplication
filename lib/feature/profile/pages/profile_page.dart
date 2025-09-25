import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/auth/pages/auth_page.dart';
import 'package:cctv_app/feature/drawer/pages/user_profile_page.dart';
import 'package:cctv_app/feature/profile/pages/edit_profile_page.dart';
import 'package:cctv_app/feature/profile/pages/help_and_support.dart';
import 'package:cctv_app/feature/profile/pages/settings_page.dart';
import 'package:cctv_app/feature/profile/pages/terms_and_policies.dart';
import 'package:cctv_app/feature/profile/widget/profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: Text(
                  "Edit",
                  style: context.normal.copyWith(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              Text("Profile", style: context.bold.copyWith(fontSize: 20)),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                child: SvgPicture.asset(Assets.svgSettingsIcon),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Space.vertical(20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      Assets.pngHighlight1Image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Space.vertical(15),
                  Text("Shaq Josh", style: context.bold.copyWith(fontSize: 20)),
                  Text(
                    "abcdefgh586@gmail.com",
                    style: context.normal.copyWith(fontSize: 18),
                  ),
                  Space.vertical(20),
                  ProfileTile(
                    text: "Edit profile",
                    icon: Assets.svgEditProfileIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfilePage(),
                        ),
                      );
                    },
                  ),
                  Space.vertical(8),
                  ProfileTile(
                    text: "Help & Support",
                    icon: Assets.svgHelpAndSupportIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpAndSupport(),
                        ),
                      );
                    },
                  ),
                  Space.vertical(8),
                  ProfileTile(
                    text: "Terms and Policies",
                    icon: Assets.svgTermAndPoliciesIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsAndPolicies(),
                        ),
                      );
                    },
                  ),
                  Space.vertical(8),
                  ProfileTile(
                    text: "Logout",
                    icon: Assets.svgLogoutIcon,
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                  Space.vertical(8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    AppBottomSheet.show(
      context,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔴 Title Text
            const Text(
              "Are you sure you want\nto logout?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ❌ Cancel Button
            PrimaryButton(
              text: "Cancel",
              borderColor: kGreyColor,
              textColor: kBlackColor,
              buttonColor: kWhiteColor,
              showBorder: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Space.vertical(12),

            // ✅ Yes Button
            PrimaryButton(
              text: "Logout",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,

    //   builder: (BuildContext context) {
    //     return Dialog(
    //       backgroundColor: kWhiteColor,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       child: Padding(
    //         padding: const EdgeInsets.all(20),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             // 🔴 Title Text
    //             const Text(
    //               "Are you sure you want\nto logout?",
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 color: Colors.red,
    //                 fontSize: 18,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             const SizedBox(height: 20),

    //             // ❌ Cancel Button
    //             PrimaryButton(
    //               text: "Cancel",
    //               borderColor: kGreyColor,
    //               textColor: kBlackColor,
    //               buttonColor: kWhiteColor,
    //               showBorder: true,
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //             ),
    //             Space.vertical(12),

    //             // ✅ Yes Button
    //             PrimaryButton(
    //               text: "Logout",
    //               onPressed: () {
    //                 Navigator.push(
    //                   context,
    //                   MaterialPageRoute(builder: (context) => AuthPage()),
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
