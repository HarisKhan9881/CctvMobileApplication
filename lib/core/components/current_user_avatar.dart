import 'package:cctv_app/core/network/models/user_profile.dart';
import 'package:cctv_app/core/network/services/user_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CurrentUserAvatar extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;

  const CurrentUserAvatar({
    super.key,
    this.radius = 24,
    this.onTap,
  });

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

  Future<String> _loadFallbackName() async {
    final storage = const AuthStorage();
    final first = (await storage.readFirstName() ?? '').trim();
    final last = (await storage.readLastName() ?? '').trim();
    final name = [if (first.isNotEmpty) first, if (last.isNotEmpty) last]
        .join(' ')
        .trim();
    return name.isEmpty ? 'User' : name;
  }

  @override
  Widget build(BuildContext context) {
    final avatar = FutureBuilder<UserProfile?>(
      future: _loadUserProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        final imageUrl = profile?.applicationMeta?.metaUrl?.trim();
        final name = [
          if ((profile?.firstName ?? '').trim().isNotEmpty)
            profile!.firstName.trim(),
          if ((profile?.lastName ?? '').trim().isNotEmpty)
            profile!.lastName.trim(),
        ].join(' ').trim();

        if (imageUrl != null && imageUrl.isNotEmpty) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: kTextfieldBlueColor,
            backgroundImage: NetworkImage(imageUrl),
          );
        }

        if (name.isNotEmpty) {
          return _InitialAvatar(radius: radius, name: name);
        }

        return FutureBuilder<String>(
          future: _loadFallbackName(),
          builder: (context, fallbackSnapshot) {
            return _InitialAvatar(
              radius: radius,
              name: fallbackSnapshot.data ?? 'User',
            );
          },
        );
      },
    );

    if (onTap == null) {
      return avatar;
    }

    return GestureDetector(onTap: onTap, child: avatar);
  }
}

class _InitialAvatar extends StatelessWidget {
  final double radius;
  final String name;

  const _InitialAvatar({
    required this.radius,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: kTextfieldBlueColor,
      child: Text(
        _buildInitials(name),
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.42,
        ),
      ),
    );
  }

  String _buildInitials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }

    if (parts.length == 1) {
      final part = parts.first;
      return part.substring(0, part.length >= 2 ? 2 : 1).toUpperCase();
    }

    return 'U';
  }
}
