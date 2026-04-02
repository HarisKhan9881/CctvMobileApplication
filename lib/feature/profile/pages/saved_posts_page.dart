import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/home/widgets/home_post_container.dart';
import 'package:flutter/material.dart';

class SavedPostsPage extends StatefulWidget {
  const SavedPostsPage({super.key});

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<ActivePost> _posts = const [];

  @override
  void initState() {
    super.initState();
    _loadSavedPosts();
  }

  Future<void> _loadSavedPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final storage = const AuthStorage();
      final accessToken = await storage.readAccessToken();
      final userId = await storage.readUserId();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('User id not found');
      }

      final posts = await CasePostService().getSavedPostByUserId(
        accessToken: accessToken,
        userId: userId,
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
        _errorMessage = 'Failed to load saved posts';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        foregroundColor: kBlackColor,
        leadingWidth: 96,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: Text(
              'Back',
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: context.normal.copyWith(fontSize: 14, color: kBlackColor),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Saved posts',
          style: context.bold.copyWith(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadSavedPosts,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: context.normal.copyWith(color: kRedColor),
          ),
          Space.vertical(8),
          TextButton(onPressed: _loadSavedPosts, child: const Text('Retry')),
        ],
      );
    }

    if (_posts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'No saved posts yet',
            textAlign: TextAlign.center,
            style: context.normal.copyWith(color: kDarkGreyColor),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      itemCount: _posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final post = _posts[index];
        return HomePostContainer(
          isAdmin: false,
          post: post,
          onClickProfile: () {},
          onPostUpdated: _loadSavedPosts,
        );
      },
    );
  }
}
