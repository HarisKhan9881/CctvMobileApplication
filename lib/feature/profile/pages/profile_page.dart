import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/models/user_profile.dart';
import 'package:cctv_app/core/network/services/user_service.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/drawer/pages/user_profile_page.dart';
import 'package:cctv_app/feature/profile/pages/help_and_support.dart';
import 'package:cctv_app/feature/profile/pages/saved_posts_page.dart';
import 'package:cctv_app/feature/profile/pages/settings_page.dart';
import 'package:cctv_app/feature/profile/pages/terms_and_policies.dart';
import 'package:cctv_app/feature/profile/widget/profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<UserProfile?> _loadUserProfile() async {
    final storage = const AuthStorage();
    final accessToken = await storage.readAccessToken();
    final userId = await storage.readUserId();

    if (accessToken == null ||
        accessToken.trim().isEmpty ||
        userId == null) {
      return null;
    }

    try {
      return const UserService().getUserById(
        accessToken: accessToken,
        userId: userId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, String>> _loadFallbackProfileInfo() async {
    final storage = const AuthStorage();
    final first = (await storage.readFirstName() ?? '').trim();
    final last = (await storage.readLastName() ?? '').trim();
    final email = (await storage.readEmail() ?? '').trim();
    final name = [if (first.isNotEmpty) first, if (last.isNotEmpty) last].join(' ');
    return {
      'name': name.isEmpty ? 'User' : name,
      'email': email.isEmpty ? 'No username' : email,
    };
  }

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
                    MaterialPageRoute(
                      builder: (context) => const UserProfilePage(),
                    ),
                  );
                },
              ),
              Text("My Profile", style: context.bold.copyWith(fontSize: 20)),
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
                  FutureBuilder<UserProfile?>(
                    future: _loadUserProfile(),
                    builder: (context, snapshot) {
                      final profile = snapshot.data;
                      final profileImageUrl = profile?.applicationMeta?.metaUrl;
                      final name = [
                        if ((profile?.firstName ?? '').trim().isNotEmpty)
                          profile!.firstName.trim(),
                        if ((profile?.lastName ?? '').trim().isNotEmpty)
                          profile!.lastName.trim(),
                      ].join(' ');

                      if (profile != null) {
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: profileImageUrl != null &&
                                      profileImageUrl.trim().isNotEmpty
                                  ? Image.network(
                                      profileImageUrl,
                                      width: 78,
                                      height: 78,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Image.asset(
                                        Assets.pngHighlight1Image,
                                        width: 78,
                                        height: 78,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      Assets.pngHighlight1Image,
                                      width: 78,
                                      height: 78,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Space.vertical(12),
                            Text(
                              name.isEmpty ? 'User' : name,
                              style: context.bold.copyWith(fontSize: 24),
                            ),
                            Text(
                              profile.email.trim().isEmpty
                                  ? 'No username'
                                  : profile.email,
                              style: context.normal.copyWith(
                                fontSize: 12,
                                color: kDarkGreyColor,
                              ),
                            ),
                          ],
                        );
                      }

                      return FutureBuilder<Map<String, String>>(
                        future: _loadFallbackProfileInfo(),
                        builder: (context, fallbackSnapshot) {
                          final fallbackName =
                              fallbackSnapshot.data?['name'] ?? 'User';
                          final fallbackEmail =
                              fallbackSnapshot.data?['email'] ?? 'No username';

                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  Assets.pngHighlight1Image,
                                  width: 78,
                                  height: 78,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Space.vertical(12),
                              Text(
                                fallbackName,
                                style: context.bold.copyWith(fontSize: 24),
                              ),
                              Text(
                                fallbackEmail,
                                style: context.normal.copyWith(
                                  fontSize: 12,
                                  color: kDarkGreyColor,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
                    text: "Saved Posts",
                    iconData: Icons.bookmark_border_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedPostsPage(),
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
              onPressed: () async {
                await AppSessionManager.instance.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
