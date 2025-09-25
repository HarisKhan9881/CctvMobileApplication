import 'package:cctv_app/core/components/admin_top_header.dart';
import 'package:cctv_app/core/components/custom_horizontal_listview_widget.dart';
import 'package:cctv_app/core/components/custom_menu_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/components/search_bar_header.dart';
import 'package:cctv_app/feature/home/pages/public_profile_page.dart';
import 'package:cctv_app/feature/home/widgets/home_post_container.dart';
import 'package:flutter/material.dart';

final List<HighlightItem> highlights = [
  HighlightItem(
    isAdd: true,
    highlightImage: Assets.pngHighlight1Image,
    label: 'Add highlight',
  ),
  HighlightItem(
    userImage: Assets.pngUser1Image,
    highlightImage: Assets.pngHighlight1Image,
    label: 'Chris Glasser',
  ),
  HighlightItem(
    userImage: Assets.pngUser2Image,
    highlightImage: Assets.pngHighlight2Image,
    label: 'Jerry Helfer',
  ),
  HighlightItem(
    userImage: Assets.pngUser1Image,
    highlightImage: Assets.pngHighlight1Image,
    label: 'Brad',
  ),
];

class HighlightItem {
  final bool isAdd;
  final String label;
  final String? userImage;
  final String? highlightImage;
  HighlightItem({
    this.isAdd = false,
    required this.label,
    this.userImage,
    this.highlightImage,
  });
}

class HomePage extends StatefulWidget {
  final bool isAdmin;
  const HomePage({super.key, required this.isAdmin});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          widget.isAdmin ? AdminTopHeader() : SearchBarHeader(),
          Space.vertical(20),
          CustomHorizontalListViewWidget(
            items: [
              'All',
              'Family Affairs',
              'Divorce',
              'Neighborhood conflicts',
            ],
            selectedItem: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Space.vertical(20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 170,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: highlights.length,
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final item = highlights[index];
                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 100,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: kBlackColor.withOpacity(0.08),
                                        blurRadius: 12,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(item.highlightImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // child: item.userImage == null
                                  //     ? Icon(Icons.add, size: 48, color: kBlackColor)
                                  //     : null,
                                ),
                                item.isAdd
                                    ? Positioned(
                                        bottom: -20,
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor: kBlackColor,
                                          child: Icon(
                                            Icons.add,
                                            color: kWhiteColor,
                                            size: 32,
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        bottom: -20,
                                        child: CircleAvatar(
                                          radius: 24,
                                          backgroundColor: kWhiteColor,
                                          child: Image.asset(
                                            item.userImage!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            Space.vertical(24),
                            Text(item.label, style: context.normal),
                          ],
                        );
                      },
                    ),
                  ),
                  Space.vertical(20),
                  HomePostContainer(),
                  Space.vertical(20),
                  HomePostContainer(),
                  Space.vertical(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
