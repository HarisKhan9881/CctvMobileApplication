import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/endpoints.dart';
import 'package:cctv_app/core/network/models/active_post.dart';
import 'package:cctv_app/core/network/models/post_report.dart';

class CasePostService {
  final ApiClient _client;

  CasePostService({ApiClient? client})
    : _client = client ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<List<ActivePost>> getAllActivePosts({
    required String accessToken,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '/api/v1/case_post/get_all_active_posts',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(ActivePost.fromJson)
        .toList();
  }

  Future<List<ActivePost>> getAllRecentPosts({
    required String accessToken,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '/api/v1/case_post/getAllRecentPosts',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(ActivePost.fromJson)
        .toList();
  }

  Future<List<ActivePost>> getPostsByUserId({
    required String accessToken,
    required int userId,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final query = Uri(queryParameters: {'user_id': '$userId'}).query;
    final json = await _client.get(
      '${Endpoints.getPostsByUserId}?$query',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(ActivePost.fromJson)
        .toList();
  }

  Future<List<ActivePost>> getSavedPostByUserId({
    required String accessToken,
    required int userId,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final query = Uri(queryParameters: {'user_id': '$userId'}).query;
    final json = await _client.get(
      '${Endpoints.getSavedPostByUserId}?$query',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(ActivePost.fromJson)
        .toList();
  }

  Future<void> submitCasePollVote({
    required String accessToken,
    required int caseId,
    required bool endPoll,
    required String ownerVote,
    required String defendantVote,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    await _client.postJson(
      '/api/v1/user_case/submit_case_poll_vote',
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'case_id': caseId,
        'end_poll': endPoll,
        'owner_vote': ownerVote,
        'defendant_vote': defendantVote,
      },
    );
  }

  Future<void> createPostReaction({
    required String accessToken,
    required int postId,
    required int userId,
    required String reactionType,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    await _client.postJson(
      '/api/v1/case_post/create_post_reaction',
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'post_id': postId,
        'user_id': userId,
        'reaction_type': reactionType,
      },
    );
  }

  Future<void> createPostComment({
    required String accessToken,
    required int postId,
    required int userId,
    required String commentContent,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    await _client.postJson(
      '/api/v1/case_post/create_post_comment',
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'post_id': postId,
        'user_id': userId,
        'comment_content': commentContent,
      },
    );
  }

  Future<void> createSavedPost({
    required String accessToken,
    required int postId,
    required int userId,
    required int createdBy,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    await _client.postJson(
      Endpoints.createSavedPost,
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'post_id': postId,
        'user_id': userId,
        'created_by': createdBy,
      },
    );
  }

  Future<void> createPostRepost({
    required String accessToken,
    required int postId,
    required int userId,
    required String postDescription,
    required int createdBy,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    await _client.postJson(
      Endpoints.createPostRepost,
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'post_id': postId,
        'user_id': userId,
        'post_description': postDescription,
        'created_by': createdBy,
      },
    );
  }

  Future<void> createPostChildComment({
    required String accessToken,
    required int postId,
    required int userId,
    required int parentCommentId,
    required String commentContent,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    await _client.postJson(
      '/api/v1/case_post/create_post_child_comment',
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'post_id': postId,
        'user_id': userId,
        'parent_comment_id': parentCommentId,
        'comment_content': commentContent,
      },
    );
  }

  Future<void> createPostReport({
    required String accessToken,
    required int postId,
    required int reportReasonTypeId,
    required String reportAdditionalInformation,
    required int createdBy,
    String reportStatus = 'P',
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    await _client.postJson(
      Endpoints.createPostReport,
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'post_id': postId,
        'report_reason_type_id': reportReasonTypeId,
        'report_status': reportStatus,
        'report_additional_information': reportAdditionalInformation,
        'created_by': createdBy,
      },
    );
  }

  Future<void> remindCasePending({
    required String accessToken,
    required int caseId,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final query = Uri(queryParameters: {'case_id': '$caseId'}).query;
    await _client.postJson(
      '${Endpoints.remindCasePending}?$query',
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: const {},
    );
  }

  Future<List<PostReport>> getPostReports({
    required String accessToken,
    String status = 'P',
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final query = Uri(queryParameters: {'status': status}).query;
    final json = await _client.get(
      '/api/v1/case_post/getPostReports?$query',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(PostReport.fromJson)
        .toList();
  }
}
