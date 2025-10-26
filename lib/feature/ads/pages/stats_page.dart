import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/ads/widget/region_container.dart';
import 'package:cctv_app/feature/ads/widget/stats_chart_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(backgroundColor: kWhiteColor, title: Text("")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Over view", style: context.semiBold.copyWith(fontSize: 20)),
              Space.vertical(16),
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      icon: Assets.pngViewImage,
                      title: "Total view",
                      value: "325,461",
                      chart: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                        ),
                        child: Image.asset(Assets.pngRegisterBottomImage),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      icon: Assets.pngRegisterTopImage,
                      title: "Revenue",
                      value: "5,430",
                      chart: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                        ),
                        child: Image.asset(Assets.pngRegisterBottomImage),
                      ),
                    ),
                  ),
                ],
              ),
              Space.vertical(20),
              StatsChartContainer(),
              Space.vertical(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Most view by regions",
                    style: context.semiBold.copyWith(fontSize: 20),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kGreyColor),
                    ),
                    padding: EdgeInsets.all(8),
                    child: SvgPicture.asset(Assets.svgFilterIcon),
                  ),
                ],
              ),
              Space.vertical(20),
              RegionContainer(),
              Space.vertical(10),
              RegionContainer(),
              Space.vertical(10),
              RegionContainer(),
              Space.vertical(10),
              RegionContainer(),
              Space.vertical(20),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Widget chart;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: kGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Image.asset(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 60,
              width: context.width * 0.5,
              child: chart,
            ),
          ),
        ],
      ),
    );
  }
}
