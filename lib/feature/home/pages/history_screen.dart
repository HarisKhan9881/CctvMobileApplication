import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Automatically focus text field after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.arrow_back, color: kBlackColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Space.horizontal(20),
                  Expanded(
                    child: CustomTextField(
                      controller: _controller,
                      focusNode: _focusNode, // 👈 focus node added
                      topPadding: 10,
                      bottomPadding: 10,
                      hintText: "Search",
                      prefix: const Icon(Icons.search, color: kDarkGreyColor),
                      hintTextColor: kDarkGreyColor,
                    ),
                  ),
                ],
              ),
              Space.vertical(20),
              Row(
                children: [
                  SvgPicture.asset(Assets.svgHistoryIcon),
                  Space.horizontal(15),
                  const Expanded(
                    child: Text(
                      "iPhone 15 vs Samsung S24 – Which One Looks Better",
                    ),
                  ),
                ],
              ),
              Space.vertical(10),
              Row(
                children: [
                  SvgPicture.asset(Assets.svgHistoryIcon),
                  Space.horizontal(15),
                  const Expanded(
                    child: Text(
                      "iPhone 15 vs Samsung S24 – Which One Looks Better",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
