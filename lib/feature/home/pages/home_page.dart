import 'package:cctv_app/core/components/custom_horizontal_listview_widget.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/components/search_bar_header.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SearchBarHeader(),
          Space.vertical(20),
          CustomHorizontalListViewWidget(
            items: [
              'All',
              'Family Affairs',
              'Divorce',
              'Neighborhood conflicts',
            ],
            selectedItem: 0,
            onTap: (index) {
              // Handle item tap
            },
          ),
          Space.vertical(20),
          Expanded(
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
          Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
