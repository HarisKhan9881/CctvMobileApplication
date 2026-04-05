import 'package:cctv_app/core/components/app_alert.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/network/models/user_profile.dart';
import 'package:cctv_app/core/utils/app_date_time.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatelessWidget {
  final UserProfile admin;

  const AdminProfilePage({super.key, required this.admin});

  String get _displayName {
    final fullName = '${admin.firstName} ${admin.lastName}'.trim();
    if (fullName.isNotEmpty && fullName != '-') {
      return fullName;
    }
    return admin.email;
  }

  String get _statusLabel {
    return (admin.isActive ?? '').toUpperCase() == 'Y' ? 'Active' : 'Inactive';
  }

  String get _avatarUrl => admin.applicationMeta?.metaUrl?.trim() ?? '';

  String get _locationLabel {
    final parts =
        [
              admin.cityId?.toString(),
              admin.stateId?.toString(),
              admin.countryId?.toString(),
            ]
            .where((part) => part != null && part.trim().isNotEmpty)
            .cast<String>()
            .toList();

    if (parts.isEmpty) {
      return admin.roleDescription?.trim().isNotEmpty == true
          ? admin.roleDescription!.trim()
          : 'Admin';
    }

    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      _avatarUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 40,
                              backgroundColor: kLightGreyColor,
                              backgroundImage: NetworkImage(_avatarUrl),
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundColor: kTextfieldBlueColor,
                              child: Text(
                                _buildInitials(_displayName),
                                style: context.bold.copyWith(
                                  fontSize: 24,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: kWhiteColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kBlackColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _locationLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: kDarkGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Space.vertical(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Admin profile",
                    style: context.semiBold.copyWith(fontSize: 20),
                  ),
                  PrimaryButton(
                    text: "Delete Profile",
                    isMainAxisSizeMin: true,
                    height: 40,
                    buttonColor: kRedColor,
                    prefixIcon: const Icon(Icons.delete, color: kWhiteColor),
                    onPressed: () {
                      showDeleteDialog(context);
                    },
                  ),
                ],
              ),
              Space.vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Email Address", style: context.semiBold),
                  Text(
                    admin.email.isEmpty ? '-' : admin.email,
                    style: context.normal.copyWith(color: kDarkGreyColor),
                  ),
                ],
              ),
              Space.vertical(10),
              Divider(thickness: 1),
              Space.vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Account Status", style: context.semiBold),
                  Text(
                    _statusLabel,
                    style: context.normal.copyWith(
                      color: _statusLabel == 'Active'
                          ? Colors.green
                          : kDarkGreyColor,
                    ),
                  ),
                ],
              ),
              Space.vertical(10),
              Divider(thickness: 1),
              Space.vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date Joined", style: context.semiBold),
                  Text(
                    AppDateTime.formatDateTime(
                      admin.createdAt,
                      fallback: 'Unknown date',
                    ),
                    style: context.normal.copyWith(color: kDarkGreyColor),
                  ),
                ],
              ),
              Space.vertical(10),
              Divider(thickness: 1),
              Space.vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Last Login Date & Time", style: context.semiBold),
                  Text(
                    AppDateTime.formatDateTime(
                      admin.createdAt,
                      fallback: 'Unknown',
                    ),
                    style: context.normal.copyWith(color: kDarkGreyColor),
                  ),
                ],
              ),
              Space.vertical(10),
              Divider(thickness: 1),
              Space.vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tasks or Projects Done", style: context.semiBold),
                  Text(
                    "${admin.userId}",
                    style: context.normal.copyWith(color: kDarkGreyColor),
                  ),
                ],
              ),
              Space.vertical(10),
              Divider(thickness: 1),
              Space.vertical(20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Share profile", style: context.semiBold),
              //     GestureDetector(
              //       onTap: () {
              //         AppAlert.showInfo(
              //           context,
              //           admin.email.isEmpty ? _displayName : admin.email,
              //         );
              //       },
              //       child: const Icon(
              //         Icons.upload_file_sharp,
              //         color: kDarkGreyColor,
              //       ),
              //     ),
              //   ],
              // ),
              // Space.vertical(10),
              // Divider(thickness: 1),
              // Space.vertical(20),
              // Text("Important note", style: context.semiBold),
              // Space.vertical(10),
              // CustomTextField(
              //   maxLine: 5,
              //   hintText:
              //       "Role: ${admin.roleDescription ?? 'Admin'}\nDOB: ${admin.dob ?? '-'}\nUser ID: ${admin.userId}",
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildInitials(String value) {
    final parts = value
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) return 'A';
    return parts.map((part) => part[0].toUpperCase()).join();
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: kWhiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Space.vertical(10),
              const Text(
                "Want to delete admin profile?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              Space.vertical(20),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          border: Border.all(color: kRedColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "No",
                          style: context.normal.copyWith(color: kBlackColor),
                        ),
                      ),
                    ),
                  ),
                  Space.horizontal(10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogContext);
                        AppAlert.showWarning(
                          context,
                          'Delete admin is not connected yet',
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kRedColor,
                          border: Border.all(color: kRedColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Yes",
                          style: context.normal.copyWith(color: kWhiteColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
