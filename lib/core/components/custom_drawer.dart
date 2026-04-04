import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/services/user_service.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/drawer/pages/post_history.dart';
import 'package:cctv_app/feature/profile/pages/help_and_support.dart';
import 'package:cctv_app/feature/profile/pages/settings_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String selectedLang = "English";
  String displayName = "User";
  String displayEmail = "";
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final storage = const AuthStorage();
    final accessToken = await storage.readAccessToken();
    final userId = await storage.readUserId();
    final first = await storage.readFirstName();
    final last = await storage.readLastName();
    final email = await storage.readEmail();
    final name = [
      if (first != null && first.trim().isNotEmpty) first.trim(),
      if (last != null && last.trim().isNotEmpty) last.trim(),
    ].join(' ');
    String? resolvedProfileImageUrl;

    if (accessToken != null &&
        accessToken.trim().isNotEmpty &&
        userId != null) {
      try {
        final profile = await const UserService().getUserById(
          accessToken: accessToken,
          userId: userId,
        );
        resolvedProfileImageUrl = profile.applicationMeta?.metaUrl?.trim();
      } catch (_) {
        resolvedProfileImageUrl = null;
      }
    }

    if (!mounted) return;
    setState(() {
      displayName = name.isEmpty ? displayName : name;
      displayEmail = (email ?? '').trim();
      profileImageUrl = resolvedProfileImageUrl;
    });
  }

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
                      backgroundColor: kTextfieldBlueColor,
                      backgroundImage:
                          profileImageUrl != null && profileImageUrl!.isNotEmpty
                          ? NetworkImage(profileImageUrl!)
                          : null,
                      child:
                          profileImageUrl != null && profileImageUrl!.isNotEmpty
                          ? null
                          : Text(
                              _buildInitials(displayName),
                              style: context.bold.copyWith(
                                color: kWhiteColor,
                                fontSize: 20,
                              ),
                            ),
                    ),
                    Space.horizontal(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: context.bold.copyWith(fontSize: 24),
                        ),
                        Text(
                          displayEmail.isEmpty ? "Online" : displayEmail,
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
              leading: Image.asset(Assets.pngHomeImage, width: 22, height: 22),
              text: "Home",
              onTap: () {},
            ),
            _buildDrawerItem(
              leading: Image.asset(Assets.pngFileImage, width: 22, height: 22),
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
              leading: Image.asset(
                Assets.pngRedirectImage,
                width: 22,
                height: 22,
              ),
              text: "Invite Friends",
              onTap: () {},
            ),
            _buildDrawerItem(
              leading: Image.asset(Assets.pngInfoImage, width: 22, height: 22),
              text: "Help & Support",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpAndSupport()),
                );
              },
            ),
            _buildDrawerItem(
              leading: Image.asset(
                Assets.pngSettingImage,
                width: 22,
                height: 22,
              ),
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
                  onPressed: () async {
                    await AppSessionManager.instance.logout();
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
    required Widget leading,
    required String text,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: leading,
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
                items: [
                  DropdownMenuItem(
                    value: "English",
                    child: Row(
                      children: [
                        Image.asset(Assets.pngFlagImage, width: 18, height: 18),
                        const SizedBox(width: 8),
                        const Text("English"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "German",
                    child: Row(
                      children: [
                        Image.asset(Assets.pngFlagImage, width: 18, height: 18),
                        const SizedBox(width: 8),
                        const Text("German"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Chinese",
                    child: Row(
                      children: [
                        Image.asset(Assets.pngFlagImage, width: 18, height: 18),
                        const SizedBox(width: 8),
                        const Text("Chinese"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Russian",
                    child: Row(
                      children: [
                        Image.asset(Assets.pngFlagImage, width: 18, height: 18),
                        const SizedBox(width: 8),
                        const Text("Russian"),
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

  String _buildInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }

    if (parts.length == 1) {
      final value = parts.first;
      return value.substring(0, value.length >= 2 ? 2 : 1).toUpperCase();
    }

    return 'U';
  }
}
