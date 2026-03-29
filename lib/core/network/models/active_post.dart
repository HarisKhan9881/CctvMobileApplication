class ActivePost {
  final int postId;
  final String postDescription;
  final String? createdAt;
  final ActivePostUserInfo? createdByUserInfo;
  final ActivePostCaseDetail? caseDetail;
  final List<ActivePostDefendantDetail> defendantDetails;
  final List<ActivePostComment> comments;
  final List<ActivePostReaction> reactions;
  final ActivePostReactionSummary? reactionSummary;
  final ActivePostPollCount? casePollCount;

  const ActivePost({
    required this.postId,
    required this.postDescription,
    this.createdAt,
    this.createdByUserInfo,
    this.caseDetail,
    required this.defendantDetails,
    required this.comments,
    required this.reactions,
    this.reactionSummary,
    this.casePollCount,
  });

  factory ActivePost.fromJson(Map<String, dynamic> json) {
    final postId = json['post_id'];

    return ActivePost(
      postId: postId is int ? postId : int.parse('$postId'),
      postDescription: json['post_description'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      createdByUserInfo:
          json['created_by_user_info'] is Map<String, dynamic>
          ? ActivePostUserInfo.fromJson(
              json['created_by_user_info'] as Map<String, dynamic>,
            )
          : null,
      caseDetail: json['case_detail'] is Map<String, dynamic>
          ? ActivePostCaseDetail.fromJson(
              json['case_detail'] as Map<String, dynamic>,
            )
          : null,
      defendantDetails: (json['defendant_details'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ActivePostDefendantDetail.fromJson)
          .toList(),
      comments: (json['comments'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ActivePostComment.fromJson)
          .toList(),
      reactions: (json['reactions'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ActivePostReaction.fromJson)
          .toList(),
      reactionSummary:
          json['reaction_summary'] is Map<String, dynamic>
          ? ActivePostReactionSummary.fromJson(
              json['reaction_summary'] as Map<String, dynamic>,
            )
          : null,
      casePollCount: json['case_poll_count'] is Map<String, dynamic>
          ? ActivePostPollCount.fromJson(
              json['case_poll_count'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ActivePostUserInfo {
  final String firstName;
  final String lastName;
  final String? userEmail;

  const ActivePostUserInfo({
    required this.firstName,
    required this.lastName,
    this.userEmail,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ActivePostUserInfo.fromJson(Map<String, dynamic> json) {
    return ActivePostUserInfo(
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      userEmail: json['user_email'] as String?,
    );
  }
}

class ActivePostMeta {
  final String? metaUrl;
  final String? metaTypeId;

  const ActivePostMeta({
    this.metaUrl,
    this.metaTypeId,
  });

  bool get hasMedia => (metaUrl ?? '').trim().isNotEmpty;

  bool get isImage {
    final normalizedType = metaTypeId?.trim();
    if (normalizedType == '1') return true;
    if (normalizedType == '2') return false;

    final url = (metaUrl ?? '').toLowerCase();
    return url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.gif') ||
        url.endsWith('.webp');
  }

  factory ActivePostMeta.fromJson(Map<String, dynamic> json) {
    return ActivePostMeta(
      metaUrl: json['meta_url'] as String?,
      metaTypeId: json['meta_type_id']?.toString(),
    );
  }
}

class ActivePostCaseDetail {
  final int caseId;
  final String caseTitle;
  final String caseDescription;
  final int? caseCategoryId;
  final String? caseResolution;
  final ActivePostMeta? meta;

  const ActivePostCaseDetail({
    required this.caseId,
    required this.caseTitle,
    required this.caseDescription,
    this.caseCategoryId,
    this.caseResolution,
    this.meta,
  });

  factory ActivePostCaseDetail.fromJson(Map<String, dynamic> json) {
    final caseId = json['case_id'];

    return ActivePostCaseDetail(
      caseId: caseId is int ? caseId : int.parse('$caseId'),
      caseTitle: json['case_title'] as String? ?? '',
      caseDescription: json['case_description'] as String? ?? '',
      caseCategoryId: int.tryParse('${json['case_category_id']}'),
      caseResolution: json['case_resolution'] as String?,
      meta: json['meta'] is Map<String, dynamic>
          ? ActivePostMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ActivePostDefendantDetail {
  final int? defendantCaseId;
  final int? defendentId;
  final String? caseResolution;
  final ActivePostUserInfo? userInfo;
  final ActivePostMeta? meta;

  const ActivePostDefendantDetail({
    this.defendantCaseId,
    this.defendentId,
    this.caseResolution,
    this.userInfo,
    this.meta,
  });

  factory ActivePostDefendantDetail.fromJson(Map<String, dynamic> json) {
    return ActivePostDefendantDetail(
      defendantCaseId: int.tryParse('${json['defendant_case_id']}'),
      defendentId: int.tryParse('${json['defendent_id']}'),
      caseResolution: json['case_resolution'] as String?,
      userInfo: json['user_info'] is Map<String, dynamic>
          ? ActivePostUserInfo.fromJson(json['user_info'] as Map<String, dynamic>)
          : null,
      meta: json['meta'] is Map<String, dynamic>
          ? ActivePostMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ActivePostComment {
  final int? commentId;
  final int? postId;
  final int? userId;
  final int? parentCommentId;
  final String commentContent;
  final String? isActive;
  final String? createdAt;
  final String? updatedAt;
  final ActivePostUserInfo? userInfo;
  final List<ActivePostComment> childComments;

  const ActivePostComment({
    this.commentId,
    this.postId,
    this.userId,
    this.parentCommentId,
    required this.commentContent,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.userInfo,
    this.childComments = const [],
  });

  factory ActivePostComment.fromJson(Map<String, dynamic> json) {
    return ActivePostComment(
      commentId: int.tryParse('${json['comment_id']}'),
      postId: int.tryParse('${json['post_id']}'),
      userId: int.tryParse('${json['user_id']}'),
      parentCommentId: int.tryParse('${json['parent_comment_id']}'),
      commentContent: json['comment_content'] as String? ?? '',
      isActive: json['is_active'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      userInfo: json['user_info'] is Map<String, dynamic>
          ? ActivePostUserInfo.fromJson(json['user_info'] as Map<String, dynamic>)
          : null,
      childComments: (json['child_comments'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ActivePostComment.fromJson)
          .toList(),
    );
  }
}

class ActivePostReaction {
  final int? reactionId;
  final int? postId;
  final int? userId;
  final String reactionType;
  final String? createdAt;
  final ActivePostUserInfo? userInfo;

  const ActivePostReaction({
    this.reactionId,
    this.postId,
    this.userId,
    required this.reactionType,
    this.createdAt,
    this.userInfo,
  });

  factory ActivePostReaction.fromJson(Map<String, dynamic> json) {
    return ActivePostReaction(
      reactionId: int.tryParse('${json['reaction_id']}'),
      postId: int.tryParse('${json['post_id']}'),
      userId: int.tryParse('${json['user_id']}'),
      reactionType: json['reaction_type'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      userInfo: json['user_info'] is Map<String, dynamic>
          ? ActivePostUserInfo.fromJson(json['user_info'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ActivePostReactionSummary {
  final int totalReactions;
  final Map<String, dynamic> byType;

  const ActivePostReactionSummary({
    required this.totalReactions,
    required this.byType,
  });

  factory ActivePostReactionSummary.fromJson(Map<String, dynamic> json) {
    return ActivePostReactionSummary(
      totalReactions: int.tryParse('${json['total_reactions']}') ?? 0,
      byType: json['by_type'] is Map<String, dynamic>
          ? json['by_type'] as Map<String, dynamic>
          : const {},
    );
  }
}

class ActivePostPollCount {
  final int ownerCount;
  final int defendantCount;
  final int totalCount;
  final String? pollStartDate;
  final String? pollEndDate;
  final String? lastVoteAt;

  const ActivePostPollCount({
    required this.ownerCount,
    required this.defendantCount,
    required this.totalCount,
    this.pollStartDate,
    this.pollEndDate,
    this.lastVoteAt,
  });

  factory ActivePostPollCount.fromJson(Map<String, dynamic> json) {
    return ActivePostPollCount(
      ownerCount: int.tryParse('${json['owner_count']}') ?? 0,
      defendantCount: int.tryParse('${json['defendant_count']}') ?? 0,
      totalCount: int.tryParse('${json['total_count']}') ?? 0,
      pollStartDate: json['poll_start_date'] as String?,
      pollEndDate: json['poll_end_date'] as String?,
      lastVoteAt: json['last_vote_at'] as String?,
    );
  }
}
