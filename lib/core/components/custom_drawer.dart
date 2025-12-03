import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/auth/pages/auth_page.dart';
import 'package:cctv_app/feature/drawer/pages/post_history.dart';
import 'package:cctv_app/feature/profile/pages/help_and_support.dart';
import 'package:cctv_app/feature/profile/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String selectedLang = "English";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kWhiteColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Profile Header
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(color: kTransparentColor),
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(Assets.pngUser1Image),
                    ),
                    Space.horizontal(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shaq Jason",
                          style: context.bold.copyWith(fontSize: 24),
                        ),
                        Text(
                          "Online",
                          style: context.normal.copyWith(color: kDarkGreyColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),

            // ✅ Drawer Items
            _buildDrawerItem(
              icon: Assets.svgHomeIcon,
              text: "Home",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Assets.svgNoteBook2Icon,
              text: "Post History",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostHistory()),
                );
              },
            ),
            Space.vertical(10),
            _buildLanguageDropdown(context),
            _buildDrawerItem(
              icon: Assets.svgInviteIcon,
              text: "Invite Friends",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Assets.svgHelpAndSupport2Icon,
              text: "Help & Support",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpAndSupport()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Assets.svgSettingsIcon,
              text: "Setting",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),

            const Spacer(),

            // ✅ Logout Button at Bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showLogoutDialog(context);
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: kWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
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
      },
    );
  }

  Widget _buildDrawerItem({
    required String icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(kBlackColor, BlendMode.color),
          ),
          title: Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: const BoxDecoration(color: kWhiteColor),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLang,
                isExpanded: true,
                dropdownColor: kWhiteColor,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                items: const [
                  DropdownMenuItem(
                    value: "English",
                    child: Row(
                      children: [
                        Text("🇬🇧 "),
                        SizedBox(width: 8),
                        Text("English"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "German",
                    child: Row(
                      children: [
                        Text("🇩🇪 "),
                        SizedBox(width: 8),
                        Text("German"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Chinese",
                    child: Row(
                      children: [
                        Text("🇨🇳 "),
                        SizedBox(width: 8),
                        Text("Chinese"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Russian",
                    child: Row(
                      children: [
                        Text("🇷🇺 "),
                        SizedBox(width: 8),
                        Text("Russian"),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLang = value; // 👈 update karte hain
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
