import 'package:cctv_app/core/components/custom_menu_button.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class AdPostContainer extends StatefulWidget {
  final ActivePost? post;

  const AdPostContainer({super.key, this.post});

  @override
  State<AdPostContainer> createState() => _AdPostContainerState();
}

class _AdPostContainerState extends State<AdPostContainer> {
  String? selectedReaction;
  bool areCommentsVisible = false;
  bool isReactionPopupVisible = false;
  OverlayEntry? reactionOverlay;
  bool _isSubmittingReaction = false;
  bool _isSubmittingComment = false;
  bool _isSubmittingReply = false;
  int _reactionCountDelta = 0;
  int _nextLocalCommentId = -1;
  late final TextEditingController _commentController;
  late final TextEditingController _replyController;
  late final FocusNode _replyFocusNode;
  late List<ActivePostComment> _comments;
  int? _replyingToCommentId;
  String? _replyingToAuthor;

  ActivePost? get post => widget.post;

  int get _reactionCount =>
      ((post?.reactionSummary?.totalReactions ?? post?.reactions.length) ?? 0) +
      _reactionCountDelta;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _replyController = TextEditingController();
    _replyFocusNode = FocusNode();
    _comments = List<ActivePostComment>.from(post?.comments ?? const []);
    _loadCurrentUserReaction();
  }

  @override
  void didUpdateWidget(covariant AdPostContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post?.postId != widget.post?.postId) {
      _reactionCountDelta = 0;
      _comments = List<ActivePostComment>.from(post?.comments ?? const []);
      _commentController.clear();
      _replyController.clear();
      _replyFocusNode.unfocus();
      _replyingToCommentId = null;
      _replyingToAuthor = null;
      _loadCurrentUserReaction();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return _PlaceholderAdPostContainer();
    }

    final activePost = post!;
    final author = activePost.createdByUserInfo?.fullName.isNotEmpty == true
        ? activePost.createdByUserInfo!.fullName
        : 'Unknown User';
    final title = activePost.caseDetail?.caseTitle.trim().isNotEmpty == true
        ? activePost.caseDetail!.caseTitle.trim()
        : "Who's Right?";
    final ownerName = activePost.createdByUserInfo?.fullName.isNotEmpty == true
        ? activePost.createdByUserInfo!.fullName
        : _buildCaseLabel(activePost.caseDetail?.caseTitle);
    final defendant = activePost.defendantDetails.isNotEmpty
        ? activePost.defendantDetails.first
        : null;
    final defendantName = defendant?.userInfo?.fullName.isNotEmpty == true
        ? defendant!.userInfo!.fullName
        : 'Defendant';
    final createdText = _timeAgo(activePost.createdAt);
    final timeLeftText = _timeLeft(activePost.casePollCount?.pollEndDate);

    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kGreyColor),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: kLightGreyColor,
                child: Text(
                  _buildInitials(author),
                  style: context.semiBold.copyWith(
                    color: kBlackColor,
                    fontSize: 13,
                  ),
                ),
              ),
              Space.horizontal(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: context.semiBold.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      createdText,
                      style: context.normal.copyWith(
                        fontSize: 12,
                        color: kDarkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              _PostMenuButton(),
            ],
          ),
          Space.vertical(12),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.bold.copyWith(fontSize: 22),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (timeLeftText != null) ...[
                Space.horizontal(12),
                Text(
                  timeLeftText,
                  style: context.normal.copyWith(
                    fontSize: 12,
                    color: kDarkGreyColor,
                  ),
                ),
              ],
            ],
          ),
          Space.vertical(12),
          _SplitMetaRow(
            leftLabel: 'A.',
            leftName: ownerName,
            leftMedia: activePost.caseDetail?.meta,
            leftFallbackAsset: Assets.pngPost1Image,
            leftOverlayTitle: 'OWNER',
            rightLabel: 'B.',
            rightName: defendantName,
            rightMedia: defendant?.meta,
            rightFallbackAsset: Assets.pngHighlight1Image,
            rightOverlayTitle: 'DEFENDANT',
          ),
          Space.vertical(12),
          PrimaryButton(
            height: 38,
            text: 'Resolutions',
            onPressed: () => _showResolutionDialog(context, activePost),
          ),
          Space.vertical(14),
          _buildReactionSummaryRow(activePost),
          const Divider(height: 20),
          _buildPostActionRow(),
          if (areCommentsVisible) ...[
            Space.vertical(12),
            if (_comments.isEmpty)
              Text(
                'No comments yet',
                style: context.normal.copyWith(color: kDarkGreyColor),
              )
            else
              ..._comments.map(_buildCommentThread),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _commentController,
                    hintText: 'Write comment here',
                    hintTextColor: kDarkGreyColor,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submitComment(),
                  ),
                ),
                Space.horizontal(8),
                SizedBox(
                  height: 58,
                  child: PrimaryButton(
                    text: _isSubmittingComment ? '...' : 'Send',
                    isMainAxisSizeMin: true,
                    inactive: _isSubmittingComment,
                    processing: _isSubmittingComment,
                    onPressed: () {
                      _submitComment();
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
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

  String _buildCaseLabel(String? title) {
    final cleaned = title?.trim() ?? '';
    if (cleaned.isEmpty) return 'Case';
    return cleaned.length <= 18 ? cleaned : '${cleaned.substring(0, 18)}...';
  }

  String _timeAgo(String? value) {
    if (value == null || value.trim().isEmpty) return 'Just now';
    final createdAt = DateTime.tryParse(value)?.toLocal();
    if (createdAt == null) return value.replaceFirst('T', ' ');

    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    }
    if (difference.inDays < 1) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String? _timeLeft(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final pollEnd = DateTime.tryParse(value)?.toLocal();
    if (pollEnd == null) return null;

    final now = DateTime.now();
    final difference = pollEnd.difference(now);
    if (difference.isNegative) return 'Closed';
    if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} left';
    }
    final minutes = difference.inMinutes.clamp(0, 59);
    return '${minutes} min${minutes == 1 ? '' : 's'} left';
  }

  void _showResolutionDialog(BuildContext context, ActivePost post) {
    final caseDetail = post.caseDetail;
    final description = caseDetail?.caseDescription.trim().isNotEmpty == true
        ? caseDetail!.caseDescription.trim()
        : post.postDescription.trim();
    final resolution = caseDetail?.caseResolution?.trim().isNotEmpty == true
        ? caseDetail!.caseResolution!.trim()
        : 'No resolution details available.';
    final title = caseDetail?.caseTitle.trim().isNotEmpty == true
        ? caseDetail!.caseTitle.trim()
        : 'Resolution';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kWhiteColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: SvgPicture.asset(Assets.svgCancelIcon),
                ),
              ),
              Text(title, style: context.bold),
              Space.vertical(12),
              Text(
                description.isNotEmpty
                    ? description
                    : 'No case description available.',
                style: context.normal,
              ),
              Space.vertical(12),
              Text(
                resolution,
                style: context.normal.copyWith(color: kDarkGreyColor),
              ),
              Space.vertical(20),
              PrimaryButton(
                text: 'Close',
                isMainAxisSizeMin: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReactionSummaryRow(ActivePost activePost) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _reactionCount > 0 ? 'Reactions $_reactionCount' : 'Reactions 0',
            style: context.normal.copyWith(color: kDarkGreyColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Space.horizontal(12),
        Text(
          '${_comments.length} comments',
          style: context.normal.copyWith(color: kDarkGreyColor),
        ),
      ],
    );
  }

  Widget _buildPostActionRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onLongPressStart: (details) {
              _showReactionPopup(details.globalPosition);
            },
            child: _buildActionButton(
              text: _reactionLabel(selectedReaction),
              onTap: isReactionPopupVisible
                  ? null
                  : () => _submitReaction('Like'),
              icon: _getReactionIcon(),
              isLoading: _isSubmittingReaction,
              isSelected: selectedReaction != null,
            ),
          ),
        ),
        Expanded(
          child: _buildActionButton(
            text: 'Comment',
            onTap: () {
              setState(() {
                areCommentsVisible = !areCommentsVisible;
              });
            },
            icon: Icons.mode_comment_outlined,
          ),
        ),
        Expanded(
          child: _buildActionButton(
            text: 'Share',
            onTap: () {},
            icon: Icons.share_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback? onTap,
    required IconData icon,
    bool isLoading = false,
    bool isSelected = false,
  }) {
    final foregroundColor = isSelected ? kPrimaryColor : kDarkGreyColor;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(icon, color: foregroundColor, size: 20),
            Space.horizontal(6),
            Flexible(
              child: Text(
                text,
                style: context.semiBold.copyWith(
                  color: foregroundColor,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(String emoji) {
    return GestureDetector(
      onTap: () {
        _hideReactionPopup();
        _submitReaction(_reactionTypeFromEmoji(emoji));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  IconData _getReactionIcon() {
    switch (selectedReaction) {
      case 'Love':
        return Icons.favorite;
      case 'Haha':
        return Icons.emoji_emotions;
      case 'Wow':
        return Icons.sentiment_neutral;
      case 'Sad':
        return Icons.sentiment_very_dissatisfied;
      case 'Angry':
        return Icons.mood_bad;
      case 'Like':
        return Icons.thumb_up;
      default:
        return Icons.thumb_up_outlined;
    }
  }

  void _hideReactionPopup() {
    if (!mounted) return;
    setState(() {
      isReactionPopupVisible = false;
    });
    reactionOverlay?.remove();
    reactionOverlay = null;
  }

  void _showReactionPopup(Offset position) {
    if (reactionOverlay != null || _isSubmittingReaction) return;

    setState(() {
      isReactionPopupVisible = true;
    });

    reactionOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideReactionPopup,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            left: position.dx - 50,
            top: position.dy - 80,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildReactionButton('❤️'),
                    _buildReactionButton('😂'),
                    _buildReactionButton('😮'),
                    _buildReactionButton('😢'),
                    _buildReactionButton('😡'),
                    _buildReactionButton('👍'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(reactionOverlay!);
  }

  Future<void> _submitReaction(String reaction) async {
    if (_isSubmittingReaction || post == null) return;

    final previousReaction = selectedReaction;
    setState(() {
      _isSubmittingReaction = true;
      selectedReaction = reaction;
    });

    try {
      final authStorage = const AuthStorage();
      final accessToken = await authStorage.readAccessToken();
      final userId = await authStorage.readUserId();

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('User id not found');
      }

      await CasePostService().createPostReaction(
        accessToken: accessToken,
        postId: post!.postId,
        userId: userId,
        reactionType: reaction,
      );

      if (!mounted) return;
      setState(() {
        if (previousReaction == null) {
          _reactionCountDelta += 1;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_reactionLabel(reaction)} reaction added')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        selectedReaction = previousReaction;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        selectedReaction = previousReaction;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit reaction')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingReaction = false;
      });
    }
  }

  String _reactionLabel(String? reaction) {
    return _normalizeReactionType(reaction);
  }

  Future<void> _loadCurrentUserReaction() async {
    final userId = await const AuthStorage().readUserId();
    if (!mounted) return;

    final userReaction = _findUserReaction(userId);
    setState(() {
      selectedReaction = userReaction;
    });
  }

  String? _findUserReaction(int? userId) {
    if (userId == null || post == null) return null;

    for (final reaction in post!.reactions.reversed) {
      if (reaction.userId == userId) {
        return _normalizeReactionType(reaction.reactionType);
      }
    }
    return null;
  }

  String _normalizeReactionType(String? reaction) {
    final value = (reaction ?? '').trim().toLowerCase();
    switch (value) {
      case '👍':
      case 'like':
        return 'Like';
      case '❤️':
      case 'heart':
      case 'love':
        return 'Love';
      case '😂':
      case 'haha':
      case 'laugh':
      case 'laughing':
        return 'Haha';
      case '😮':
      case 'wow':
        return 'Wow';
      case '😢':
      case 'sad':
        return 'Sad';
      case '😡':
      case 'angry':
        return 'Angry';
      default:
        return reaction?.trim().isNotEmpty == true ? reaction!.trim() : 'Like';
    }
  }

  String _reactionTypeFromEmoji(String emoji) {
    switch (emoji) {
      case '❤️':
        return 'Love';
      case '😂':
        return 'Haha';
      case '😮':
        return 'Wow';
      case '😢':
        return 'Sad';
      case '😡':
        return 'Angry';
      case '👍':
      default:
        return 'Like';
    }
  }

  @override
  void dispose() {
    reactionOverlay?.remove();
    _commentController.dispose();
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_isSubmittingComment || post == null) return;

    final commentContent = _commentController.text.trim();
    if (commentContent.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a comment')));
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      final authStorage = const AuthStorage();
      final accessToken = await authStorage.readAccessToken();
      final userId = await authStorage.readUserId();
      final firstName = await authStorage.readFirstName();
      final lastName = await authStorage.readLastName();

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('User id not found');
      }

      await CasePostService().createPostComment(
        accessToken: accessToken,
        postId: post!.postId,
        userId: userId,
        commentContent: commentContent,
      );

      if (!mounted) return;

      setState(() {
        _comments = [
          ..._comments,
          ActivePostComment(
            commentId: _takeNextLocalCommentId(),
            postId: post!.postId,
            userId: userId,
            commentContent: commentContent,
            createdAt: DateTime.now().toIso8601String(),
            userInfo: ActivePostUserInfo(
              firstName: firstName ?? '',
              lastName: lastName ?? '',
            ),
          ),
        ];
        _commentController.clear();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment added')));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to add comment')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingComment = false;
      });
    }
  }

  Future<void> _submitReply(ActivePostComment parentComment) async {
    if (_isSubmittingReply || post == null || parentComment.commentId == null) {
      return;
    }

    final commentContent = _replyController.text.trim();
    if (commentContent.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a reply')));
      return;
    }

    setState(() {
      _isSubmittingReply = true;
    });

    try {
      final authStorage = const AuthStorage();
      final accessToken = await authStorage.readAccessToken();
      final userId = await authStorage.readUserId();
      final firstName = await authStorage.readFirstName();
      final lastName = await authStorage.readLastName();

      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }
      if (userId == null) {
        throw const ApiException('User id not found');
      }

      await CasePostService().createPostChildComment(
        accessToken: accessToken,
        postId: post!.postId,
        userId: userId,
        parentCommentId: parentComment.commentId!,
        commentContent: commentContent,
      );

      if (!mounted) return;

      final newReply = ActivePostComment(
        commentId: _takeNextLocalCommentId(),
        postId: post!.postId,
        userId: userId,
        parentCommentId: parentComment.commentId,
        commentContent: commentContent,
        createdAt: DateTime.now().toIso8601String(),
        userInfo: ActivePostUserInfo(
          firstName: firstName ?? '',
          lastName: lastName ?? '',
        ),
      );

      setState(() {
        _comments = _comments
            .map(
              (comment) => _appendReplyToComment(
                comment,
                parentComment.commentId!,
                newReply,
              ),
            )
            .toList();
        _replyController.clear();
        _replyFocusNode.unfocus();
        _replyingToCommentId = null;
        _replyingToAuthor = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reply added')));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to add reply')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmittingReply = false;
      });
    }
  }

  ActivePostComment _appendReplyToComment(
    ActivePostComment comment,
    int parentCommentId,
    ActivePostComment reply,
  ) {
    if (comment.commentId == parentCommentId) {
      return ActivePostComment(
        commentId: comment.commentId,
        postId: comment.postId,
        userId: comment.userId,
        parentCommentId: comment.parentCommentId,
        commentContent: comment.commentContent,
        isActive: comment.isActive,
        createdAt: comment.createdAt,
        updatedAt: comment.updatedAt,
        userInfo: comment.userInfo,
        childComments: [...comment.childComments, reply],
      );
    }

    return ActivePostComment(
      commentId: comment.commentId,
      postId: comment.postId,
      userId: comment.userId,
      parentCommentId: comment.parentCommentId,
      commentContent: comment.commentContent,
      isActive: comment.isActive,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
      userInfo: comment.userInfo,
      childComments: comment.childComments
          .map((child) => _appendReplyToComment(child, parentCommentId, reply))
          .toList(),
    );
  }

  Widget _buildCommentThread(ActivePostComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentItem(comment: comment, isReply: false),
          if (_replyingToCommentId == comment.commentId) ...[
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kLightGreyColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kGreyColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Replying to ${_replyingToAuthor ?? 'User'}',
                            style: context.semiBold.copyWith(fontSize: 12),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _replyingToCommentId = null;
                              _replyingToAuthor = null;
                              _replyController.clear();
                              _replyFocusNode.unfocus();
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: kDarkGreyColor,
                          ),
                        ),
                      ],
                    ),
                    Space.vertical(8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _replyController,
                            focusNode: _replyFocusNode,
                            autoFocus: true,
                            hintText: 'Write reply here',
                            hintTextColor: kDarkGreyColor,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _submitReply(comment),
                          ),
                        ),
                        Space.horizontal(8),
                        SizedBox(
                          height: 58,
                          child: PrimaryButton(
                            text: _isSubmittingReply ? '...' : 'Send',
                            isMainAxisSizeMin: true,
                            inactive: _isSubmittingReply,
                            processing: _isSubmittingReply,
                            onPressed: () {
                              _submitReply(comment);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (comment.childComments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 38, top: 8),
              child: Column(
                children: comment.childComments
                    .map(
                      (reply) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCommentItem(comment: reply, isReply: true),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentItem({
    required ActivePostComment comment,
    required bool isReply,
  }) {
    final authorName = comment.userInfo?.fullName.isNotEmpty == true
        ? comment.userInfo!.fullName
        : 'User';
    final timeText = _commentTimeLabel(comment.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isReply ? 15 : 17,
              backgroundImage: const AssetImage(Assets.pngUser1Image),
            ),
            Space.horizontal(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          authorName,
                          style: context.semiBold.copyWith(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Space.horizontal(10),
                      Expanded(
                        child: Text(
                          timeText,
                          style: context.normal.copyWith(
                            color: kDarkGreyColor,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Space.vertical(6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      comment.commentContent,
                      style: context.normal.copyWith(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: isReply ? 42 : 46, top: 8),
          child: Row(
            children: [
              Text(
                '1 Like',
                style: context.normal.copyWith(
                  color: kDarkGreyColor,
                  fontSize: 12,
                ),
              ),
              Space.horizontal(14),
              TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  foregroundColor: _replyingToCommentId == comment.commentId
                      ? kPrimaryColor
                      : kDarkGreyColor,
                ),
                onPressed: () => _toggleReplyBox(comment),
                icon: const Icon(Icons.reply, size: 15),
                label: Text(
                  'Reply',
                  style: context.semiBold.copyWith(fontSize: 12),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                icon: const Icon(
                  Icons.thumb_up_off_alt,
                  size: 18,
                  color: kDarkGreyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _commentTimeLabel(String? value) {
    if (value == null || value.trim().isEmpty) return 'Just now';
    final parsed = DateTime.tryParse(value)?.toLocal();
    if (parsed == null) return value.replaceFirst('T', ' ');

    final hour = parsed.hour == 0
        ? 12
        : parsed.hour > 12
        ? parsed.hour - 12
        : parsed.hour;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final suffix = parsed.hour >= 12 ? 'PM' : 'AM';
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
    return '${months[parsed.month - 1]} ${parsed.day}, ${parsed.year} - $hour:$minute $suffix';
  }

  int _takeNextLocalCommentId() {
    return _nextLocalCommentId--;
  }

  void _toggleReplyBox(ActivePostComment comment) {
    final commentId = comment.commentId;
    if (commentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reply is not available for this comment'),
        ),
      );
      return;
    }

    setState(() {
      if (_replyingToCommentId == commentId) {
        _replyingToCommentId = null;
        _replyingToAuthor = null;
        _replyController.clear();
        _replyFocusNode.unfocus();
      } else {
        _replyingToCommentId = commentId;
        _replyingToAuthor = comment.userInfo?.fullName.isNotEmpty == true
            ? comment.userInfo!.fullName
            : 'User';
        _replyController.clear();
      }
    });

    if (_replyingToCommentId == commentId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _replyFocusNode.requestFocus();
        }
      });
    }
  }
}

class _PostSideCard extends StatelessWidget {
  final String label;
  final String name;
  final ActivePostMeta? media;
  final String fallbackAsset;
  final String overlayTitle;

  const _PostSideCard({
    required this.label,
    required this.name,
    required this.media,
    required this.fallbackAsset,
    required this.overlayTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 0.78,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _SideMedia(
                  media: media,
                  fallbackAsset: fallbackAsset,
                  overlayTitle: overlayTitle,
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      overlayTitle,
                      style: context.semiBold.copyWith(
                        color: kWhiteColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Space.vertical(8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kGreyColor),
          ),
          child: Text(
            '$label $name',
            style: context.semiBold.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SplitMetaRow extends StatelessWidget {
  final String leftLabel;
  final String leftName;
  final ActivePostMeta? leftMedia;
  final String leftFallbackAsset;
  final String leftOverlayTitle;
  final String rightLabel;
  final String rightName;
  final ActivePostMeta? rightMedia;
  final String rightFallbackAsset;
  final String rightOverlayTitle;

  const _SplitMetaRow({
    required this.leftLabel,
    required this.leftName,
    required this.leftMedia,
    required this.leftFallbackAsset,
    required this.leftOverlayTitle,
    required this.rightLabel,
    required this.rightName,
    required this.rightMedia,
    required this.rightFallbackAsset,
    required this.rightOverlayTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _PostSideCard(
            label: leftLabel,
            name: leftName,
            media: leftMedia,
            fallbackAsset: leftFallbackAsset,
            overlayTitle: leftOverlayTitle,
          ),
        ),
        Space.horizontal(8),
        Expanded(
          child: _PostSideCard(
            label: rightLabel,
            name: rightName,
            media: rightMedia,
            fallbackAsset: rightFallbackAsset,
            overlayTitle: rightOverlayTitle,
          ),
        ),
      ],
    );
  }
}

class _SideMedia extends StatefulWidget {
  final ActivePostMeta? media;
  final String fallbackAsset;
  final String overlayTitle;

  const _SideMedia({
    required this.media,
    required this.fallbackAsset,
    required this.overlayTitle,
  });

  @override
  State<_SideMedia> createState() => _SideMediaState();
}

class _SideMediaState extends State<_SideMedia> {
  VideoPlayerController? _videoController;
  Future<void>? _videoInitialization;
  VoidCallback? _videoListener;

  @override
  void initState() {
    super.initState();
    _setupVideo();
  }

  @override
  void didUpdateWidget(covariant _SideMedia oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media?.metaUrl != widget.media?.metaUrl) {
      _disposeVideoController();
      _setupVideo();
    }
  }

  void _setupVideo() {
    final media = widget.media;
    if (media == null || !media.hasMedia || media.isImage) {
      return;
    }

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(media.metaUrl!),
    );
    _videoController = controller;
    _videoListener = () {
      if (!mounted) return;
      setState(() {});
    };
    controller.addListener(_videoListener!);
    _videoInitialization = controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.media;
    if (media == null || !media.hasMedia) {
      return Image.asset(widget.fallbackAsset, fit: BoxFit.cover);
    }

    if (media.isImage) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showImagePreview(context, media.metaUrl!),
          child: Image.network(
            media.metaUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Image.asset(widget.fallbackAsset, fit: BoxFit.cover),
          ),
        ),
      );
    }

    if (_videoController == null || _videoInitialization == null) {
      return Image.asset(widget.fallbackAsset, fit: BoxFit.cover);
    }

    return FutureBuilder<void>(
      future: _videoInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !_videoController!.value.isInitialized) {
          return Container(
            color: kBlackColor.withValues(alpha: 0.85),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: kWhiteColor),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _openMediaFullscreen(context, media),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width == 0
                            ? 16
                            : _videoController!.value.size.width,
                        height: _videoController!.value.size.height == 0
                            ? 9
                            : _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.28)),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.play_arrow,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                '${widget.overlayTitle} VIDEO',
                style: context.bold.copyWith(color: kWhiteColor, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }

  void _disposeVideoController() {
    if (_videoController != null && _videoListener != null) {
      _videoController!.removeListener(_videoListener!);
    }
    _videoController?.dispose();
    _videoController = null;
    _videoInitialization = null;
    _videoListener = null;
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FullscreenMediaViewer(
            mediaUrl: imageUrl,
            fallbackAsset: widget.fallbackAsset,
            isImage: true,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  void _openMediaFullscreen(BuildContext context, ActivePostMeta media) {
    if (media.isImage) {
      _showImagePreview(context, media.metaUrl!);
      return;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 220),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) {
          return _FullscreenMediaViewer(
            mediaUrl: media.metaUrl!,
            fallbackAsset: widget.fallbackAsset,
            isImage: false,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }
}

class _PostMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MenuAnchor(
        alignmentOffset: const Offset(0, 10),
        style: MenuStyle(
          backgroundColor: WidgetStateProperty.all(kWhiteColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: kLightGreyColor),
            ),
          ),
          elevation: WidgetStateProperty.all(4),
          alignment: AlignmentDirectional.bottomStart,
          visualDensity: VisualDensity.compact,
        ),
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
              return GestureDetector(
                onTap: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kGreyColor),
                  ),
                  child: Icon(Icons.more_horiz, color: kDarkGreyColor),
                ),
              );
            },
        menuChildren: [
          CustomMenuButton(
            onTap: () {},
            icon: SvgPicture.asset(Assets.svgRemoveIcon),
            iconSize: 15,
            title: 'Remove',
          ),
          CustomMenuButton(
            onTap: () {},
            icon: SvgPicture.asset(Assets.svgCopyIcon),
            iconSize: 15,
            title: 'Copy Link',
          ),
        ],
      ),
    );
  }
}

class _FullscreenMediaViewer extends StatefulWidget {
  final String mediaUrl;
  final String fallbackAsset;
  final bool isImage;

  const _FullscreenMediaViewer({
    required this.mediaUrl,
    required this.fallbackAsset,
    required this.isImage,
  });

  @override
  State<_FullscreenMediaViewer> createState() => _FullscreenMediaViewerState();
}

class _FullscreenMediaViewerState extends State<_FullscreenMediaViewer> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;

  @override
  void initState() {
    super.initState();
    if (!widget.isImage) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl),
      );
      _initialization = _controller!.initialize().then((_) {
        _controller!.play();
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: widget.isImage ? _buildImage() : _buildVideo(),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: kWhiteColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Image.network(
          widget.mediaUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) =>
              Image.asset(widget.fallbackAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    if (_controller == null || _initialization == null) {
      return Center(
        child: Image.asset(widget.fallbackAsset, fit: BoxFit.contain),
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
                      ? 16 / 9
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

class _PlaceholderAdPostContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: kGreyColor),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(Assets.pngHighlight1Image),
          ),
          Space.horizontal(10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I need your support, not criticism.',
                  style: context.bold.copyWith(fontSize: 14),
                ),
                Space.vertical(8),
                Row(
                  children: [
                    Text(
                      'Online',
                      overflow: TextOverflow.ellipsis,
                      style: context.semiBold.copyWith(
                        fontSize: 14,
                        color: kBlackColor,
                      ),
                    ),
                    Space.horizontal(6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: kBlackColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Space.horizontal(6),
                    Text(
                      'Jul 7, 2025 7:16 am',
                      overflow: TextOverflow.ellipsis,
                      style: context.normal.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Space.horizontal(10),
          _PostMenuButton(),
        ],
      ),
    );
  }
}
