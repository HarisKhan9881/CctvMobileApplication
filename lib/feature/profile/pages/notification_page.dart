import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/app_notification_item.dart';
import 'package:cctv_app/core/network/services/notification_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/profile/pages/case_response_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<AppNotificationItem> _notifications = const [];

  String _notificationThumbnailUrl(AppNotificationItem notification) {
    return notification.parsedMeta?.mediaUrl?.trim() ?? '';
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = await const AuthStorage().readUserId();
      final accessToken = await const AuthStorage().readAccessToken();
      if (userId == null || accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session user not found');
      }

      final service = NotificationService();
      final notifications = await service.getAppNotificationsByUserId(
        userId: userId,
        accessToken: accessToken,
        limit: 50,
        offset: 0,
      );

      if (!mounted) return;
      setState(() {
        _notifications = notifications;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load notifications';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Notifications"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(Assets.svgDoubleTickIcon),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: context.normal.copyWith(color: kRedColor),
            ),
            Space.vertical(12),
            TextButton(
              onPressed: _loadNotifications,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return emptyNotification(context);
    }

    return ListView.separated(
      itemCount: _notifications.length,
      separatorBuilder: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Divider(color: kGreyColor, thickness: 1),
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CaseResponsePage(notification: notification),
              ),
            );
          },
          child: Container(
            color: kTransparentColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(Assets.pngUser1Image),
                ),
                Space.horizontal(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: context.bold.copyWith(fontSize: 16),
                      ),
                      Text(notification.message),
                      if ((notification.createdAt ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            notification.createdAt!,
                            style: context.normal.copyWith(
                              fontSize: 12,
                              color: kDarkGreyColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Space.horizontal(12),
                _NotificationThumbnail(
                  imageUrl: _notificationThumbnailUrl(notification),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget emptyNotification(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: SvgPicture.asset(Assets.svgNotificationImage)),
        Space.vertical(20),
        Text(
          "No Notification yet",
          style: context.normal.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}

class _NotificationThumbnail extends StatelessWidget {
  final String imageUrl;

  const _NotificationThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          Assets.pngHighlight2Image,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Image.asset(
            Assets.pngHighlight2Image,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
