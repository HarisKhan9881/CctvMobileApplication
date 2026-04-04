import 'dart:async';

import 'package:cctv_app/core/components/admin_top_header.dart';
import 'package:cctv_app/core/components/custom_horizontal_listview_widget.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/components/search_bar_header.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/models/active_reel.dart';
import 'package:cctv_app/core/network/models/general_parameter_option.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/network/services/general_parameter_service.dart';
import 'package:cctv_app/core/network/services/user_case_service.dart';
import 'package:cctv_app/core/realtime/app_websocket_event.dart';
import 'package:cctv_app/core/realtime/app_websocket_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/home/pages/create_reel_page.dart';
import 'package:cctv_app/feature/home/pages/public_profile_page.dart';
import 'package:cctv_app/feature/home/widgets/home_post_container.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;
  const HomePage({super.key, required this.isAdmin});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _CategoryTabItem {
  final String label;
  final int? categoryId;

  const _CategoryTabItem({required this.label, this.categoryId});
}

class _FeedPostItem {
  final ActivePost post;
  final ActivePostRepost? repost;

  const _FeedPostItem({
    required this.post,
    this.repost,
  });
}

class _HomePageState extends State<HomePage> {
  static List<ActivePost> _postsCache = const [];
  static List<ActiveReel> _reelsCache = const [];
  static List<_CategoryTabItem> _categoryTabsCache = const [
    _CategoryTabItem(label: 'All'),
  ];

  int selectedIndex = 0;
  bool _isLoadingPosts = true;
  bool _isLoadingReels = true;
  String? _postsError;
  String? _reelsError;
  List<ActivePost> _posts = const [];
  List<ActiveReel> _reels = const [];
  List<_CategoryTabItem> _categoryTabs = const [_CategoryTabItem(label: 'All')];
  StreamSubscription<AppWebSocketEvent>? _postsEventSubscription;
  StreamSubscription<AppWebSocketEvent>? _reelsEventSubscription;
  bool _postsRefreshQueued = false;
  bool _reelsRefreshQueued = false;
  final Map<int, GlobalKey> _postKeys = <int, GlobalKey>{};
  int? _highlightedPostId;

  List<String> get _categoryItems =>
      _categoryTabs.map((tab) => tab.label).toList();

  List<_FeedPostItem> get _filteredPosts {
    if (selectedIndex < 0 || selectedIndex >= _categoryTabs.length) {
      return _expandPosts(_posts);
    }

    final selectedCategoryId = _categoryTabs[selectedIndex].categoryId;
    if (selectedCategoryId == null) {
      return _expandPosts(_posts);
    }

    final filteredPosts = _posts.where((post) {
      return post.caseDetail?.caseCategoryId == selectedCategoryId;
    }).toList();
    return _expandPosts(filteredPosts);
  }

  List<_FeedPostItem> _expandPosts(List<ActivePost> posts) {
    final items = <_FeedPostItem>[];
    for (final post in posts) {
      for (final repost in post.reposts) {
        items.add(_FeedPostItem(post: post, repost: repost));
      }
      items.add(_FeedPostItem(post: post));
    }
    return items;
  }

  Future<void> _focusPostInFeed(int postId) async {
    if (!mounted) return;

    if (_filteredPosts.every((item) => item.post.postId != postId)) {
      return;
    }

    setState(() {
      _highlightedPostId = postId;
    });

    await WidgetsBinding.instance.endOfFrame;
    final targetContext = _postKeys[postId]?.currentContext;
    if (targetContext != null && mounted) {
      await Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
        alignment: 0.12,
      );
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || _highlightedPostId != postId) return;
      setState(() {
        _highlightedPostId = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _posts = _postsCache;
    _reels = _reelsCache;
    _categoryTabs = _categoryTabsCache;
    _isLoadingPosts = _posts.isEmpty;
    _isLoadingReels = _reels.isEmpty;
    _bindWebSocketEvents();
    _loadInitialData();
  }

  @override
  void dispose() {
    _postsEventSubscription?.cancel();
    _reelsEventSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([_loadPostsAndCategories(), _loadReels()]);
  }

  void _bindWebSocketEvents() {
    _postsEventSubscription?.cancel();
    _reelsEventSubscription?.cancel();

    _postsEventSubscription = AppWebSocketService.instance
        .eventsFor(postRefreshEventTypes)
        .listen((_) => _schedulePostsRefresh());

    _reelsEventSubscription = AppWebSocketService.instance
        .eventsFor(reelRefreshEventTypes)
        .listen((_) => _scheduleReelsRefresh());
  }

  void _schedulePostsRefresh() {
    if (!mounted) return;
    if (_isLoadingPosts) {
      _postsRefreshQueued = true;
      return;
    }
    _loadPostsAndCategories();
  }

  void _scheduleReelsRefresh() {
    if (!mounted) return;
    if (_isLoadingReels) {
      _reelsRefreshQueued = true;
      return;
    }
    _loadReels();
  }

  Future<void> _loadPostsAndCategories() async {
    setState(() {
      _isLoadingPosts = _posts.isEmpty;
      _postsError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final postService = CasePostService();
      final parameterService = const GeneralParameterService();
      final results = await Future.wait([
        postService.getAllActivePosts(accessToken: accessToken),
        parameterService.getByHeaderName(
          headerName: 'CASE_CATEGORY',
          accessToken: accessToken,
        ),
      ]);

      final posts = results[0] as List<ActivePost>;
      final categoryOptions = results[1] as List<GeneralParameterOption>;
      final seenIds = <int>{};
      final categoryTabs = <_CategoryTabItem>[
        const _CategoryTabItem(label: 'All'),
      ];
      for (final option in categoryOptions) {
        if (option.paramLabel.trim().isEmpty ||
            seenIds.contains(option.paramDetailId)) {
          continue;
        }
        seenIds.add(option.paramDetailId);
        categoryTabs.add(
          _CategoryTabItem(
            label: option.paramLabel.trim(),
            categoryId: option.paramDetailId,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _posts = posts;
        _categoryTabs = categoryTabs;
        if (selectedIndex >= _categoryTabs.length) {
          selectedIndex = 0;
        }
        _postsCache = posts;
        _categoryTabsCache = categoryTabs;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _postsError = e.message;
        _categoryTabs = const [_CategoryTabItem(label: 'All')];
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _postsError = 'Failed to load posts';
        _categoryTabs = const [_CategoryTabItem(label: 'All')];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingPosts = false;
      });
      if (_postsRefreshQueued) {
        _postsRefreshQueued = false;
        _loadPostsAndCategories();
      }
    }
  }

  Future<void> _loadReels() async {
    setState(() {
      _isLoadingReels = _reels.isEmpty;
      _reelsError = null;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      final reels = await UserCaseService().getAllActiveReels(
        accessToken: accessToken,
      );

      if (!mounted) return;
      setState(() {
        _reels = reels;
        _reelsCache = reels;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _reelsError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _reelsError = 'Failed to load reels';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingReels = false;
      });
      if (_reelsRefreshQueued) {
        _reelsRefreshQueued = false;
        _loadReels();
      }
    }
  }

  Widget _buildReelsSection() {
    if (_isLoadingReels && _reels.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_reelsError != null && _reels.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _reelsError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kRedColor),
            ),
            TextButton(onPressed: _loadReels, child: const Text('Retry reels')),
          ],
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _reels.length + 1,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      padding: const EdgeInsets.only(left: 16, right: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _AddReelCard(
            onTap: () async {
              final created = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => const CreateReelPage()),
              );
              if (created == true) {
                _loadReels();
              }
            },
          );
        }

        final reel = _reels[index - 1];
        return _ActiveReelCard(reel: reel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.isAdmin
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AdminTopHeader(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchBarHeader(),
              ),
        Space.vertical(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomHorizontalListViewWidget(
            items: _categoryItems,
            selectedItem: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
        Space.vertical(20),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadPostsAndCategories();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 4),
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(
                            alpha: 0.5,
                          ), // Shadow color
                          spreadRadius: 2, // Kitna wide shadow ho
                          blurRadius: 7, // Shadow blur
                          offset: Offset(
                            0,
                            3,
                          ), // X aur Y direction mein shadow ka move
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: _buildReelsSection(),
                  ),
                  Space.vertical(20),
                  if (_isLoadingPosts && _filteredPosts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_postsError != null && _filteredPosts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            _postsError!,
                            style: context.normal.copyWith(color: kRedColor),
                          ),
                          Space.vertical(8),
                          TextButton(
                            onPressed: _loadInitialData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else if (_filteredPosts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        selectedIndex == 0
                            ? 'No active posts yet'
                            : 'No posts found for this category',
                        style: context.normal.copyWith(color: kDarkGreyColor),
                      ),
                    )
                  else
                    ..._filteredPosts.map((item) {
                      final post = item.post;
                      final postKey = _postKeys.putIfAbsent(
                        post.postId,
                        () => GlobalKey(),
                      );
                      return Padding(
                        key: item.repost == null ? postKey : null,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: HomePostContainer(
                          isAdmin: widget.isAdmin,
                          post: post,
                          repost: item.repost,
                          onOpenOriginalPostInFeed: item.repost != null
                              ? () => _focusPostInFeed(post.postId)
                              : null,
                          highlightPost:
                              item.repost == null &&
                              _highlightedPostId == post.postId,
                          onClickProfile: () {
                            final repostUserId = item.repost?.userId;
                            final authorUserId = repostUserId ?? post.authorUserId;
                            if (authorUserId == null) {
                              return;
                            }

                            final repostName =
                                item.repost?.repostUserDetail?.fullName.trim() ??
                                '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PublicProfilePage(
                                  userId: authorUserId,
                                  userName: repostName.isNotEmpty
                                      ? repostName
                                      : post.authorDisplayName,
                                  avatarUrl: post.authorAvatarUrl,
                                ),
                              ),
                            );
                          },
                          onPostUpdated: _loadPostsAndCategories,
                        ),
                      );
                    }),
                  Space.vertical(20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddReelCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddReelCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(color: kTransparentColor),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: kBlackColor.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage(Assets.pngHighlight1Image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: kBlackColor,
                    child: const Icon(Icons.add, color: kWhiteColor, size: 32),
                  ),
                ),
              ],
            ),
            Space.vertical(24),
            Text('Add Reel', style: context.normal),
          ],
        ),
      ),
    );
  }
}

class _ActiveReelCard extends StatelessWidget {
  final ActiveReel reel;

  const _ActiveReelCard({required this.reel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => _FullscreenReelViewer(reel: reel)),
        );
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: kBlackColor.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _ReelMediaPreview(reel: reel),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: kWhiteColor,
                    child: _ReelUserAvatar(reel: reel, radius: 20),
                  ),
                ),
              ],
            ),
            Space.vertical(24),
            Text(
              reel.displayName,
              style: context.normal,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReelUserAvatar extends StatelessWidget {
  final ActiveReel reel;
  final double radius;

  const _ReelUserAvatar({required this.reel, required this.radius});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = reel.userAvatarUrl;
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: kLightGreyColor,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: kPrimaryColor.withValues(alpha: 0.12),
      child: Text(
        _buildInitials(reel.displayName),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: kPrimaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _buildInitials(String name) {
    final parts = name
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) return 'U';
    return parts.map((part) => part[0].toUpperCase()).join();
  }
}

class _FullscreenReelViewer extends StatefulWidget {
  final ActiveReel reel;

  const _FullscreenReelViewer({required this.reel});

  @override
  State<_FullscreenReelViewer> createState() => _FullscreenReelViewerState();
}

class _FullscreenReelViewerState extends State<_FullscreenReelViewer> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;

  bool get _isImage => widget.reel.isImage;

  @override
  void initState() {
    super.initState();
    if (!_isImage && widget.reel.mediaUrl != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.reel.mediaUrl!),
      );
      _initialization = _controller!.initialize().then((_) {
        _controller!
          ..setLooping(true)
          ..play();
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _isImage ? _buildImage() : _buildVideo()),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.25),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.72),
                      ],
                      stops: const [0, 0.45, 1],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black.withValues(alpha: 0.35),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: kWhiteColor),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _ReelUserAvatar(reel: widget.reel, radius: 20),
                      Space.horizontal(10),
                      Expanded(
                        child: Text(
                          widget.reel.displayName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: kWhiteColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Space.vertical(10),
                  Text(
                    widget.reel.reelDescription.trim().isEmpty
                        ? 'No description'
                        : widget.reel.reelDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kWhiteColor,
                      height: 1.4,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final mediaUrl = widget.reel.mediaUrl;
    if (mediaUrl == null || mediaUrl.trim().isEmpty) {
      return const Center(
        child: Icon(Icons.broken_image_outlined, color: kWhiteColor, size: 48),
      );
    }

    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Image.network(
          mediaUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.broken_image_outlined,
            color: kWhiteColor,
            size: 48,
          ),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    if (_controller == null || _initialization == null) {
      return const Center(
        child: Icon(Icons.videocam_off_outlined, color: kWhiteColor, size: 48),
      );
    }

    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !_controller!.value.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(color: kWhiteColor),
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio == 0
                      ? 9 / 16
                      : _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
              AnimatedOpacity(
                opacity: _controller!.value.isPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: const Icon(
                    Icons.play_arrow,
                    color: kWhiteColor,
                    size: 42,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReelMediaPreview extends StatelessWidget {
  final ActiveReel reel;

  const _ReelMediaPreview({required this.reel});

  @override
  Widget build(BuildContext context) {
    final mediaUrl = reel.mediaUrl;
    if (mediaUrl == null || mediaUrl.trim().isEmpty) {
      return _buildFallback(icon: Icons.hide_image_outlined, label: 'No media');
    }

    if (reel.isImage) {
      return SizedBox.expand(
        child: Image.network(
          mediaUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return _buildFallback(
              icon: Icons.image_outlined,
              label: 'Loading image',
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (_, _, _) => _buildFallback(
            icon: Icons.broken_image_outlined,
            label: 'Image failed',
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: kBlackColor),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryColor.withValues(alpha: 0.2),
                kBlackColor.withValues(alpha: 0.92),
              ],
            ),
          ),
        ),
        const Center(
          child: Icon(
            Icons.play_circle_fill_rounded,
            color: kWhiteColor,
            size: 36,
          ),
        ),
        Positioned(
          left: 8,
          right: 8,
          bottom: 8,
          child: Text(
            reel.reelDescription.trim().isEmpty
                ? 'Video reel'
                : reel.reelDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.normal.copyWith(color: kWhiteColor, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildFallback({
    required IconData icon,
    required String label,
    Widget? child,
  }) {
    return Container(
      color: kLightGreyColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child ?? Icon(icon, color: kDarkGreyColor, size: 28),
          Space.vertical(6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: kDarkGreyColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
