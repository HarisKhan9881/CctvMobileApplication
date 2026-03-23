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
  final String? caseResolution;
  final ActivePostMeta? meta;

  const ActivePostCaseDetail({
    required this.caseId,
    required this.caseTitle,
    required this.caseDescription,
    this.caseResolution,
    this.meta,
  });

  factory ActivePostCaseDetail.fromJson(Map<String, dynamic> json) {
    final caseId = json['case_id'];

    return ActivePostCaseDetail(
      caseId: caseId is int ? caseId : int.parse('$caseId'),
      caseTitle: json['case_title'] as String? ?? '',
      caseDescription: json['case_description'] as String? ?? '',
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
  final String commentContent;
  final String? createdAt;
  final ActivePostUserInfo? userInfo;

  const ActivePostComment({
    this.commentId,
    required this.commentContent,
    this.createdAt,
    this.userInfo,
  });

  factory ActivePostComment.fromJson(Map<String, dynamic> json) {
    return ActivePostComment(
      commentId: int.tryParse('${json['comment_id']}'),
      commentContent: json['comment_content'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      userInfo: json['user_info'] is Map<String, dynamic>
          ? ActivePostUserInfo.fromJson(json['user_info'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ActivePostReaction {
  final int? reactionId;
  final String reactionType;

  const ActivePostReaction({
    this.reactionId,
    required this.reactionType,
  });

  factory ActivePostReaction.fromJson(Map<String, dynamic> json) {
    return ActivePostReaction(
      reactionId: int.tryParse('${json['reaction_id']}'),
      reactionType: json['reaction_type'] as String? ?? '',
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
