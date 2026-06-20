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
import 'package:cctv_app/feature/profile/pages/settings_page.dart';
import 'package:cctv_app/feature/profile/pages/terms_and_policies.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name = _cachedName();
  late String _email = _cachedEmail();
  String? _profileImageUrl = AuthStorage.cachedProfileImageUrl;

  String _cachedName() {
    final first = AuthStorage.cachedFirstName?.trim() ?? '';
    final last = AuthStorage.cachedLastName?.trim() ?? '';
    final name = [
      if (first.isNotEmpty) first,
      if (last.isNotEmpty) last,
    ].join(' ');
    return name.isEmpty ? 'User' : name;
  }

  String _cachedEmail() {
    final email = AuthStorage.cachedEmail?.trim() ?? '';
    return email.isEmpty ? 'No username' : email;
  }

  @override
  void initState() {
    super.initState();
    _loadCachedProfileInfo();
    _refreshUserProfile();
  }

  Future<void> _loadCachedProfileInfo() async {
    final info = await _loadFallbackProfileInfo();
    if (!mounted) return;
    setState(() {
      _name = info['name'] ?? 'User';
      _email = info['email'] ?? 'No username';
      _profileImageUrl = info['profileImageUrl'];
    });
  }

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

  Future<void> _refreshUserProfile() async {
    final profile = await _loadUserProfile();
    if (profile == null) return;

    final profileImageUrl = profile.applicationMeta?.metaUrl?.trim();
    final name = [
      if (profile.firstName.trim().isNotEmpty) profile.firstName.trim(),
      if (profile.lastName.trim().isNotEmpty) profile.lastName.trim(),
    ].join(' ');
    final email = profile.email.trim();

    final storage = const AuthStorage();
    final currentDashboardType = await storage.readDashboardType();
    await storage.saveAuth(
      accessToken: (await storage.readAccessToken()) ?? '',
      userId: profile.userId,
      roleId: profile.roleId,
      roleDescription: profile.roleDescription,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: email,
      profileImageUrl: profileImageUrl,
      dashboardType: currentDashboardType ?? DashboardType.user,
    );

    if (!mounted) return;
    setState(() {
      _name = name.isEmpty ? 'User' : name;
      _email = email.isEmpty ? 'No username' : email;
      _profileImageUrl = profileImageUrl;
    });
  }

  Future<Map<String, String>> _loadFallbackProfileInfo() async {
    final storage = const AuthStorage();
    final first = (await storage.readFirstName() ?? '').trim();
    final last = (await storage.readLastName() ?? '').trim();
    final email = (await storage.readEmail() ?? '').trim();
    final profileImageUrl = (await storage.readProfileImageUrl() ?? '').trim();
    final name = [
      if (first.isNotEmpty) first,
      if (last.isNotEmpty) last,
    ].join(' ');
    return {
      'name': name.isEmpty ? 'User' : name,
      'email': email.isEmpty ? 'No username' : email,
      'profileImageUrl': profileImageUrl,
    };
  }

  Widget _buildProfileHeader(BuildContext context) {
    final imageUrl = _profileImageUrl?.trim() ?? '';

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => Image.asset(
                    Assets.pngHighlight1Image,
                    width: 62,
                    height: 62,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  Assets.pngHighlight1Image,
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                ),
        ),
        Space.vertical(8),
        Text(
          _name,
          style: context.bold.copyWith(fontSize: 18),
        ),
        Text(
          _email,
          style: context.normal.copyWith(
            fontSize: 13,
            color: kDarkGreyColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space.vertical(12),
            SizedBox(
              height: 42,
              child: Row(
                children: [
                  _buildTopIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "My Profile",
                        style: context.bold.copyWith(fontSize: 18),
                      ),
                    ),
                  ),
                  _buildTopIconButton(
                    icon: Icons.settings_outlined,
                    iconSize: 22,
                    iconColor: kDarkGreyColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Space.vertical(8),
            Center(child: _buildProfileHeader(context)),
            Space.vertical(16),
            Text(
              "Account setting",
              style: context.bold.copyWith(fontSize: 22),
            ),
            Space.vertical(12),
            _buildSettingRow(
              icon: Icons.person_outline,
              text: "Edit profile",
              onTap: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
                if (updated == true) {
                  await _loadCachedProfileInfo();
                  await _refreshUserProfile();
                }
              },
            ),
            _buildSettingRow(
              icon: Icons.help_outline,
              text: "Help & Support",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpAndSupport(),
                  ),
                );
              },
            ),
            _buildSettingRow(
              icon: Icons.info_outline,
              text: "Terms and Policies",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndPolicies(),
                  ),
                );
              },
            ),
            _buildSettingRow(
              icon: Icons.logout,
              text: "Log out",
              onTap: () {
                showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIconButton({
    required IconData icon,
    required VoidCallback onTap,
    double iconSize = 24,
    Color iconColor = kBlackColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Row(
              children: [
                Icon(icon, color: kPrimaryColor, size: 23),
                Space.horizontal(20),
                Text(
                  text,
                  style: context.normal.copyWith(
                    fontSize: 14,
                    color: kBlackColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEDEDED)),
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
