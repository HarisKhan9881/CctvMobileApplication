import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/auth/pages/auth_page.dart';
import 'package:cctv_app/feature/drawer/pages/post_history.dart';
import 'package:cctv_app/feature/drawer/pages/user_profile_page.dart';
import 'package:cctv_app/feature/profile/pages/settings_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
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
            _buildDrawerItem(icon: Icons.home, text: "Home", onTap: () {}),
            _buildDrawerItem(
              icon: Icons.history,
              text: "Post History",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostHistory()),
                );
              },
            ),
            _buildDrawerItem(
              icon: Icons.group_add,
              text: "Invite Friends",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.help_outline,
              text: "Help & Support",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.settings,
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
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
}
