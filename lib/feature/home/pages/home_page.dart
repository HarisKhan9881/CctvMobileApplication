import 'package:cctv_app/core/components/admin_top_header.dart';
import 'package:cctv_app/core/components/app_bottom_sheet.dart';
import 'package:cctv_app/core/components/custom_horizontal_listview_widget.dart';
import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/components/search_bar_header.dart';
import 'package:cctv_app/feature/home/pages/private_profile_page.dart';
import 'package:cctv_app/feature/home/pages/public_profile_page.dart';
import 'package:cctv_app/feature/home/widgets/home_post_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    return Column(
      children: [
        widget.isAdmin
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AdminTopHeader(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchBarHeader(),
              ),
        Space.vertical(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomHorizontalListViewWidget(
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
        ),
        Space.vertical(20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 4),
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha:0.5), // Shadow color
                        spreadRadius: 2, // Kitna wide shadow ho
                        blurRadius: 7, // Shadow blur
                        offset: Offset(
                          0,
                          3,
                        ), // X aur Y direction mein shadow ka move
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: highlights.length,
                    separatorBuilder: (_, __) => SizedBox(width: 16),
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    itemBuilder: (context, index) {
                      final item = highlights[index];
                      return GestureDetector(
                        onTap: index == 0
                            ? () {
                                AppBottomSheet.show(
                                  context,
                                  body: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 12),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: CupertinoButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: SvgPicture.asset(
                                              Assets.svgCancelIcon,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: kWhiteColor,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withValues(alpha:
                                                  0.5,
                                                ), // Shadow color
                                                spreadRadius:
                                                    2, // Kitna wide shadow ho
                                                blurRadius: 7, // Shadow blur
                                                offset: Offset(
                                                  0,
                                                  3,
                                                ), // X aur Y direction mein shadow ka move
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Uploaded video"),
                                              SizedBox(height: 12),
                                              DottedBorder(
                                                options:
                                                    RectDottedBorderOptions(
                                                      color: kPrimaryColor,
                                                      dashPattern: [5, 5],
                                                    ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        SvgPicture.asset(
                                                          Assets.svgMusicIcon,
                                                        ),
                                                        Space.vertical(15),
                                                        Text(
                                                          "Attach video and audio Max 3 min length",
                                                          style: context.normal
                                                              .copyWith(
                                                                color:
                                                                    kBlackColor,
                                                              ),
                                                        ),
                                                        Space.vertical(15),
                                                        PrimaryButton(
                                                          height: 40,
                                                          isMainAxisSizeMin:
                                                              true,
                                                          text: "Browse files",
                                                          buttonColor:
                                                              kWhiteColor,
                                                          textColor:
                                                              kBlackColor,
                                                          showBorder: true,
                                                          prefixIcon: Icon(
                                                            Icons.attach_file,
                                                          ),
                                                          borderColor:
                                                              kPrimaryColor,
                                                          onPressed: () {},
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Space.vertical(15),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Mentions your friends or competitor",
                                          ),
                                        ),
                                        Space.vertical(10),
                                        CustomTextField(
                                          hintText: "@ Tag someone",
                                        ),

                                        Space.vertical(10),
                                        CustomTextField(
                                          hintText: "#social_media",
                                        ),
                                        Space.vertical(6),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "Min 5",
                                            style: context.normal.copyWith(
                                              color: kDarkGreyColor,
                                            ),
                                          ),
                                        ),
                                        Space.vertical(15),
                                        PrimaryButton(
                                          text: "Upload",
                                          buttonColor: kDarkGreyColor,
                                          onPressed: () {},
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            : () {},
                        child: Container(
                          decoration: BoxDecoration(color: kTransparentColor),
                          child: Column(
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
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kBlackColor.withValues(alpha:0.08),
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Space.vertical(20),
                HomePostContainer(
                  isAdmin: widget.isAdmin,
                  onClickProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicProfilePage(),
                      ),
                    );
                  },
                ),
                Space.vertical(20),
                HomePostContainer(
                  isAdmin: widget.isAdmin,
                  onClickProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivateProfilePage(),
                      ),
                    );
                  },
                ),
                Space.vertical(20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
