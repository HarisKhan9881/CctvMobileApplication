import 'package:cctv_app/core/network/models/uploaded_media.dart';

class PendingCase {
  final int caseId;
  final int? userId;
  final String caseTitle;
  final String caseDescription;
  final String? caseStatus;
  final int? caseCategoryId;
  final String? caseIsActive;
  final String? caseCreatedAt;
  final UploadedMedia? applicationMeta;
  final PendingCaseDefendant? defendant;

  const PendingCase({
    required this.caseId,
    this.userId,
    required this.caseTitle,
    required this.caseDescription,
    this.caseStatus,
    this.caseCategoryId,
    this.caseIsActive,
    this.caseCreatedAt,
    this.applicationMeta,
    this.defendant,
  });

  bool get hasMedia => (applicationMeta?.metaUrl ?? '').trim().isNotEmpty;

  bool get isImage {
    final metaTypeId = applicationMeta?.metaTypeId;
    if (metaTypeId != null) {
      return metaTypeId == 1;
    }

    final url = applicationMeta?.metaUrl?.toLowerCase() ?? '';
    return url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.gif') ||
        url.endsWith('.webp');
  }

  factory PendingCase.fromJson(Map<String, dynamic> json) {
    final caseId = json['case_id'];

    return PendingCase(
      caseId: caseId is int ? caseId : int.parse('$caseId'),
      userId: int.tryParse('${json['user_id']}'),
      caseTitle: json['case_title'] as String? ?? '',
      caseDescription: json['case_description'] as String? ?? '',
      caseStatus: json['case_status'] as String?,
      caseCategoryId: int.tryParse('${json['case_category_id']}'),
      caseIsActive: json['case_is_active'] as String?,
      caseCreatedAt: json['case_created_at'] as String?,
      applicationMeta: json['application_meta'] is Map<String, dynamic>
          ? UploadedMedia.fromJson(json['application_meta'] as Map<String, dynamic>)
          : null,
      defendant: json['defendant'] is Map<String, dynamic>
          ? PendingCaseDefendant.fromJson(json['defendant'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PendingCaseDefendant {
  final int? defendantCaseId;
  final int? defendentId;
  final bool? isAcceptTerms;
  final String? caseResolution;
  final bool? isActive;
  final String? createdAt;
  final UploadedMedia? applicationMeta;

  const PendingCaseDefendant({
    this.defendantCaseId,
    this.defendentId,
    this.isAcceptTerms,
    this.caseResolution,
    this.isActive,
    this.createdAt,
    this.applicationMeta,
  });

  factory PendingCaseDefendant.fromJson(Map<String, dynamic> json) {
    return PendingCaseDefendant(
      defendantCaseId: int.tryParse('${json['defendant_case_id']}'),
      defendentId: int.tryParse('${json['defendent_id']}'),
      isAcceptTerms: json['is_accept_terms'] as bool?,
      caseResolution: json['case_resolution'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
      applicationMeta: json['application_meta'] is Map<String, dynamic>
          ? UploadedMedia.fromJson(json['application_meta'] as Map<String, dynamic>)
          : null,
    );
  }
}
