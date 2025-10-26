import 'package:cctv_app/core/components/ad_top_header.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adHome/widget/ad_post_container.dart';
import 'package:cctv_app/feature/adHome/widget/horizontal_graph_list.dart';
import 'package:cctv_app/feature/adHome/widget/revenue_card.dart';
import 'package:flutter/material.dart';

class AdHomePage extends StatefulWidget {
  const AdHomePage({super.key});

  @override
  State<AdHomePage> createState() => _AdHomePageState();
}

class _AdHomePageState extends State<AdHomePage> {
  int selectedYear = 2025;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdTopHeader(),
            Space.vertical(20),
            RevenueCard(
              amount: "\$5,44,370",
              year: selectedYear,
              onYearChanged: (y) => setState(() => selectedYear = y),
            ),
            Space.vertical(20),
            Text(
              "Analytics",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kBlackColor,
              ),
            ),
            Space.vertical(10),
            HorizontalGraphList(),
            Space.vertical(20),
            Text(
              "Recent add admin",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: kBlackColor,
              ),
            ),
            Space.vertical(10),
            AdPostContainer(),
            Space.vertical(10),
            AdPostContainer(),
            Space.vertical(10),
            AdPostContainer(),
            Space.vertical(10),
            AdPostContainer(),
            Space.vertical(10),
          ],
        ),
      ),
    );
  }
}
