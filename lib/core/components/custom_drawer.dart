import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
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
            Padding(
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
            const Divider(),

            // ✅ Drawer Items
            _buildDrawerItem(icon: Icons.home, text: "Home", onTap: () {}),
            _buildDrawerItem(
              icon: Icons.history,
              text: "Post History",
              onTap: () {},
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
              onTap: () {},
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
                    // handle logout
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
}
