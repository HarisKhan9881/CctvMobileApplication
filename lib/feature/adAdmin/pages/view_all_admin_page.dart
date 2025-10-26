import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adHome/widget/ad_post_container.dart';
import 'package:flutter/material.dart';

class ViewAllAdminPage extends StatelessWidget {
  const ViewAllAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(backgroundColor: kWhiteColor, title: Text("")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Admin", style: context.semiBold.copyWith(fontSize: 20)),
                  Text(
                    "Total 25",
                    style: context.normal.copyWith(color: kDarkGreyColor),
                  ),
                ],
              ),
              Space.vertical(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Online", style: context.normal.copyWith(fontSize: 20)),
                  Space.horizontal(4),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimaryColor, width: 2),
                    ),
                  ),
                ],
              ),
              Space.vertical(16),
              AdPostContainer(),
              Space.vertical(10),
              AdPostContainer(),
              Space.vertical(10),
              AdPostContainer(),
              Space.vertical(10),
              AdPostContainer(),
              Space.vertical(10),
              AdPostContainer(),
              Space.vertical(20),
            ],
          ),
        ),
      ),
    );
  }
}
