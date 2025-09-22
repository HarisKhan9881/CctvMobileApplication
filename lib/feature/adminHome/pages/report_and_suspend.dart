import 'package:cctv_app/core/components/custom_switch_button.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:flutter/material.dart';

class ReportAndSuspend extends StatefulWidget {
  const ReportAndSuspend({super.key});

  @override
  State<ReportAndSuspend> createState() => _ReportAndSuspendState();
}

class _ReportAndSuspendState extends State<ReportAndSuspend> {
  bool sendWarning = false;
  bool suspendAccount = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Block/Suspend"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subject",
                      style: context.normal.copyWith(fontSize: 16),
                    ),
                    Space.vertical(8),
                    CustomTextField(
                      hintText: "Write Subject",

                      validator: (val) {
                        return Validators.userName(val);
                      },
                    ),
                    Space.vertical(16),
                    Text(
                      "Details",
                      style: context.normal.copyWith(fontSize: 16),
                    ),
                    Space.vertical(8),
                    CustomTextField(
                      hintText: "Write Details",
                      maxLine: 6,
                      validator: (val) {
                        return Validators.userName(val);
                      },
                    ),
                    Space.vertical(16),
                    Text(
                      "Take Action",
                      style: context.semiBold.copyWith(fontSize: 16),
                    ),
                    Space.vertical(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Block/Suspends account",
                          style: context.normal.copyWith(fontSize: 16),
                        ),
                        CustomSwitchButton(
                          onToggle: (val) {
                            setState(() {
                              suspendAccount = val;
                            });
                          },
                          isToggled: suspendAccount,
                        ),
                      ],
                    ),
                    Space.vertical(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Send Warning",
                          style: context.normal.copyWith(fontSize: 16),
                        ),
                        CustomSwitchButton(
                          onToggle: (val) {
                            setState(() {
                              sendWarning = val;
                            });
                          },
                          isToggled: sendWarning,
                        ),
                      ],
                    ),
                    Space.vertical(16),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: "Cancel",
                    borderColor: kPrimaryColor,
                    buttonColor: kWhiteColor,
                    textColor: kBlackColor,
                    showBorder: true,
                    onPressed: () {},
                  ),
                ),
                Space.horizontal(10),
                Expanded(
                  child: PrimaryButton(text: "Submit", onPressed: () {}),
                ),
              ],
            ),
            Space.vertical(30),
          ],
        ),
      ),
    );
  }
}
