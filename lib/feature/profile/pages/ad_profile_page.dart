import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/components/current_user_avatar.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/models/user_profile.dart';
import 'package:cctv_app/core/network/services/user_service.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/drawer/pages/user_profile_page.dart';
import 'package:cctv_app/feature/profile/pages/help_and_support.dart';
import 'package:cctv_app/feature/profile/pages/terms_and_policies.dart';
import 'package:cctv_app/feature/profile/widget/profile_tile.dart';
import 'package:flutter/material.dart';

class AdProfilePage extends StatelessWidget {
  const AdProfilePage({super.key});

  Future<UserProfile?> _loadUserProfile() async {
    final storage = const AuthStorage();
    final accessToken = await storage.readAccessToken();
    final userId = await storage.readUserId();

    if (accessToken == null || accessToken.trim().isEmpty || userId == null) {
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
    final name = [if (first.isNotEmpty) first, if (last.isNotEmpty) last]
        .join(' ')
        .trim();

    return {
      'name': name.isEmpty ? 'User' : name,
      'email': email.isEmpty ? 'No username' : email,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile", style: context.bold.copyWith(fontSize: 20)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Space.vertical(20),
                      FutureBuilder<UserProfile?>(
                        future: _loadUserProfile(),
                        builder: (context, snapshot) {
                          final profile = snapshot.data;
                          final name = [
                            if ((profile?.firstName ?? '').trim().isNotEmpty)
                              profile!.firstName.trim(),
                            if ((profile?.lastName ?? '').trim().isNotEmpty)
                              profile!.lastName.trim(),
                          ].join(' ').trim();

                          if (profile != null) {
                            return Column(
                              children: [
                                const CurrentUserAvatar(radius: 50),
                                Space.vertical(15),
                                Text(
                                  name.isEmpty ? 'User' : name,
                                  style: context.bold.copyWith(fontSize: 20),
                                ),
                                Text(
                                  profile.email.trim().isEmpty
                                      ? 'No username'
                                      : profile.email,
                                  style: context.normal.copyWith(
                                    fontSize: 16,
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
                                  fallbackSnapshot.data?['email'] ??
                                  'No username';

                              return Column(
                                children: [
                                  const CurrentUserAvatar(radius: 50),
                                  Space.vertical(15),
                                  Text(
                                    fallbackName,
                                    style: context.bold.copyWith(fontSize: 20),
                                  ),
                                  Text(
                                    fallbackEmail,
                                    style: context.normal.copyWith(
                                      fontSize: 16,
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Account Settings",
                          style: context.normal.copyWith(fontSize: 22),
                        ),
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
        ),
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
