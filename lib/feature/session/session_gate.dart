import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/feature/bottomNavBar/ad_bottom_nav_bar.dart';
import 'package:cctv_app/feature/bottomNavBar/admin_bottom_nav_bar.dart';
import 'package:cctv_app/feature/bottomNavBar/user_bottom_nav_bar.dart';
import 'package:cctv_app/feature/splash/splash.dart';
import 'package:flutter/material.dart';

class SessionGate extends StatelessWidget {
  const SessionGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _resolveHome(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data ?? const SplashPage();
      },
    );
  }

  Future<Widget> _resolveHome() async {
    final storage = const AuthStorage();
    final hasSession = await storage.hasSession();
    if (!hasSession) return const SplashPage();

    final dashboardType = await storage.readDashboardType();
    final roleDescription = await storage.readRoleDescription();
    final roleId = await storage.readRoleId();

    final resolvedType =
        dashboardType ??
        _dashboardTypeFromRole(roleDescription: roleDescription, roleId: roleId);
    final initialIndex = await storage.readLastTabIndex(resolvedType);

    return switch (resolvedType) {
      DashboardType.admin => AdminBottomNavBar(initialIndex: initialIndex ?? 0),
      DashboardType.ad => AdBottomNavBar(initialIndex: initialIndex ?? 0),
      DashboardType.user => UserBottomNavBar(initialIndex: initialIndex ?? 0),
    };
  }

  DashboardType _dashboardTypeFromRole({
    String? roleDescription,
    int? roleId,
  }) {
    final normalizedRole = roleDescription?.trim().toLowerCase();
    if (normalizedRole == 'admin') return DashboardType.admin;
    if (normalizedRole == 'ad') return DashboardType.ad;
    if (normalizedRole == 'user') return DashboardType.user;

    return switch (roleId) {
      2 => DashboardType.admin,
      3 => DashboardType.ad,
      1 => DashboardType.user,
      _ => DashboardType.user,
    };
  }
}
