import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

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
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: kLightGreyColor,
                        backgroundImage: const AssetImage(
                          Assets.pngHighlight1Image,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
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
                          "Patricia Sanders",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kBlackColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "2323 Dancing Dove Lane, Long Island City, NY 11101",
                          style: TextStyle(
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
                    prefixIcon: Icon(Icons.delete, color: kWhiteColor),
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
                    "abc@gmail.com",
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
                    "Active",
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
                  Text("Date Joined", style: context.semiBold),
                  Text(
                    "Apr 20, 2025",
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
                    "May 2, 2025 5:00 pm",
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
                    "305",
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
                  Text("Share profile", style: context.semiBold),
                  Icon(Icons.upload_file_sharp, color: kDarkGreyColor),
                ],
              ),
              Space.vertical(10),
              Divider(thickness: 1),
              Space.vertical(20),
              Text("Important note", style: context.semiBold),
              Space.vertical(10),
              CustomTextField(maxLine: 5, hintText: "Notes"),
            ],
          ),
        ),
      ),
    );
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(color: kRedColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
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
                  Space.horizontal(10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kRedColor,
                        border: Border.all(color: kRedColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
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
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
