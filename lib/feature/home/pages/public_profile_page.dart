import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/home/widgets/home_post_container.dart';
import 'package:flutter/material.dart';

class PublicProfilePage extends StatefulWidget {
  final int userId;
  final String userName;
  final String? avatarUrl;

  const PublicProfilePage({
    super.key,
    required this.userId,
    required this.userName,
    this.avatarUrl,
  });

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<ActivePost> _posts = const [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final posts = await CasePostService().getPostsByUserId(
        accessToken: accessToken,
        userId: widget.userId,
      );

      if (!mounted) return;
      setState(() {
        _posts = posts;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load profile posts';
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
        title: Text('Profile', style: context.bold.copyWith(fontSize: 18)),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPosts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ProfileAvatar(
                    avatarUrl: widget.avatarUrl,
                    userName: widget.userName,
                    radius: 28,
                  ),
                  Space.horizontal(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: context.bold.copyWith(fontSize: 16),
                        ),
                        Text(
                          'Online',
                          style: context.normal.copyWith(
                            fontSize: 12,
                            color: kDarkGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Space.vertical(16),
              Text(
                widget.userName,
                style: context.bold.copyWith(fontSize: 18),
              ),
              Text(
                'The description of my profile',
                style: context.normal.copyWith(color: kDarkGreyColor),
              ),
              Space.vertical(16),
              Text(
                'Total post',
                style: context.semiBold.copyWith(fontSize: 14),
              ),
              Space.vertical(10),
              _buildBody(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: context.normal.copyWith(color: kRedColor),
            ),
            Space.vertical(8),
            TextButton(onPressed: _loadPosts, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No posts found',
          style: context.normal.copyWith(color: kDarkGreyColor),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.66,
      ),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        return _ProfilePostCard(post: _posts[index]);
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String userName;
  final double radius;

  const _ProfileAvatar({
    required this.avatarUrl,
    required this.userName,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = avatarUrl?.trim();
    if (normalizedUrl != null && normalizedUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: kLightGreyColor,
        backgroundImage: NetworkImage(normalizedUrl),
      );
    }

    final initials = userName
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: radius,
      backgroundColor: kTextfieldBlueColor,
      child: Text(
        initials.isEmpty ? 'U' : initials,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: kPrimaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfilePostCard extends StatelessWidget {
  final ActivePost post;

  const _ProfilePostCard({required this.post});

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    final parsed = DateTime.tryParse(value)?.toLocal();
    if (parsed == null) {
      return value.replaceFirst('T', ' ');
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = months[parsed.month - 1];
    final minute = parsed.minute.toString().padLeft(2, '0');
    final suffix = parsed.hour >= 12 ? 'pm' : 'am';
    final hour = parsed.hour == 0
        ? 12
        : parsed.hour > 12
        ? parsed.hour - 12
        : parsed.hour;
    return '$month ${parsed.day}, $hour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final media = post.caseDetail?.meta;
    final title = post.caseDetail?.caseTitle.trim().isNotEmpty == true
        ? post.caseDetail!.caseTitle
        : 'Untitled';
    final description = post.postDescription.trim().isNotEmpty
        ? post.postDescription
        : (post.caseDetail?.caseDescription ?? '');

    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreyColor),
      ),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: _ProfilePostMedia(media: media),
            ),
          ),
          Space.vertical(6),
          Text(
            title,
            style: context.bold.copyWith(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Space.vertical(4),
          Expanded(
            child: Text(
              description,
              style: context.normal.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 12,
                color: kDarkGreyColor,
              ),
              maxLines: 3,
            ),
          ),
          Space.vertical(6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _formatDate(post.createdAt),
              style: context.normal.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 12,
                color: kDarkGreyColor,
              ),
            ),
          ),
          Space.vertical(6),
          PrimaryButton(
            height: 42,
            text: 'View Post',
            padding: const EdgeInsets.symmetric(horizontal: 2),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    backgroundColor: kWhiteColor,
                    appBar: AppBar(
                      backgroundColor: kWhiteColor,
                      foregroundColor: kBlackColor,
                      title: const Text('View Post'),
                    ),
                    body: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: [
                        HomePostContainer(
                          isAdmin: false,
                          post: post,
                          onClickProfile: () {},
                          onPostUpdated: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfilePostMedia extends StatelessWidget {
  final ActivePostMeta? media;

  const _ProfilePostMedia({required this.media});

  @override
  Widget build(BuildContext context) {
    if (media == null || !media!.hasMedia) {
      return Container(
        color: kLightGreyColor,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: kDarkGreyColor),
      );
    }

    if (!media!.isImage) {
      return Container(
        color: kBlackColor,
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_circle_fill_rounded,
          color: kWhiteColor,
          size: 34,
        ),
      );
    }

    return Image.network(
      media!.metaUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: kLightGreyColor,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined, color: kDarkGreyColor),
      ),
    );
  }
}
