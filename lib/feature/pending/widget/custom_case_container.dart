import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/services/case_post_service.dart';
import 'package:cctv_app/core/storage/auth_storage.dart';
import 'package:cctv_app/core/network/models/pending_case.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCaseContainer extends StatefulWidget {
  final PendingCase pendingCase;

  const CustomCaseContainer({super.key, required this.pendingCase});

  @override
  State<CustomCaseContainer> createState() => _CustomCaseContainerState();
}

class _CustomCaseContainerState extends State<CustomCaseContainer> {
  bool _isSendingReminder = false;

  PendingCase get pendingCase => widget.pendingCase;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreyColor),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildMediaPreview(),
          ),
          Space.vertical(6),
          Text(
            pendingCase.caseTitle.trim().isEmpty
                ? 'Untitled case'
                : pendingCase.caseTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.bold.copyWith(fontSize: 14),
          ),
          Space.vertical(2),
          Text(
            pendingCase.caseDescription.trim().isEmpty
                ? 'No description available.'
                : pendingCase.caseDescription,
            maxLines: 2,
            style: context.normal.copyWith(
              overflow: TextOverflow.ellipsis,
              fontSize: 11,
              color: kDarkGreyColor,
            ),
          ),
          Space.vertical(4),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: Text(
              _formatDate(pendingCase.caseCreatedAt),
              style: context.normal.copyWith(
                overflow: TextOverflow.ellipsis,
                fontSize: 11,
                color: kDarkGreyColor,
              ),
            ),
          ),
          const Spacer(),
          Space.vertical(6),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  height: 40,
                  text: "Reminder",
                  prefixIcon: SvgPicture.asset(Assets.svgRemindIcon),
                  prefixIconSize: 16,
                  textFontSize: 12,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  processing: _isSendingReminder,
                  inactive: _isSendingReminder,
                  onPressed: _sendReminder,
                ),
              ),
              Space.horizontal(8),
              GestureDetector(
                onTap: () {
                  showDeleteDialog(context);
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kGreyColor),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    Assets.svgDeleteIcon,
                    colorFilter: colorFilter(color: kDarkGreyColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    final mediaUrl = pendingCase.applicationMeta?.metaUrl;
    if (mediaUrl == null || mediaUrl.trim().isEmpty) {
      return Container(
        width: double.infinity,
        height: 90,
        color: kLightGreyColor,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined),
      );
    }

    if (pendingCase.isImage) {
      return Image.network(
        mediaUrl,
        width: double.infinity,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: double.infinity,
          height: 90,
          color: kLightGreyColor,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image_outlined),
        ),
      );
    }

    return Stack(
      children: [
        Container(width: double.infinity, height: 90, color: kBlackColor),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kPrimaryColor.withValues(alpha: 0.15),
                  kBlackColor.withValues(alpha: 0.92),
                ],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: kWhiteColor,
              size: 34,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value.replaceFirst('T', ' ');
    }

    final hour = parsed.hour == 0
        ? 12
        : parsed.hour > 12
        ? parsed.hour - 12
        : parsed.hour;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final suffix = parsed.hour >= 12 ? 'pm' : 'am';
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
    return '${months[parsed.month - 1]} ${parsed.day}, $hour:$minute $suffix';
  }

  Future<void> _sendReminder() async {
    if (_isSendingReminder) return;

    setState(() {
      _isSendingReminder = true;
    });

    try {
      final accessToken = await const AuthStorage().readAccessToken();
      if (accessToken == null || accessToken.trim().isEmpty) {
        throw const ApiException('Session token not found');
      }

      await CasePostService().remindCasePending(
        accessToken: accessToken,
        caseId: pendingCase.caseId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder has been sent')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reminder: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSendingReminder = false;
      });
    }
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: kWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔴 Title Text
                const Text(
                  "Are you sure you want\nto delete?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // ❌ Cancel Button
                PrimaryButton(
                  text: "No",
                  borderColor: kGreyColor,
                  textColor: kBlackColor,
                  buttonColor: kWhiteColor,
                  showBorder: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Space.vertical(12),

                // ✅ Yes Button
                PrimaryButton(text: "Yes", onPressed: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}
