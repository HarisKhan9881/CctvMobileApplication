import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/communityFeedback/pages/feedback_view.dart';
import 'package:flutter/material.dart';

class CommunityFeedbackWidget extends StatelessWidget {
  const CommunityFeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kGreyColor),
      ),
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: kBlackColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(Assets.pngHighlight2Image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Space.horizontal(10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    "Culpa aliquam consequnntur veritatis at",
                    style: context.semiBold.copyWith(fontSize: 18),
                  ),
                  Text(
                    "Culpa aliquam consequnntur veritatis at",
                    style: context.semiBold.copyWith(
                      fontSize: 12,
                      color: kTransparentColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Apr 30, 10:27 am",
                          style: context.normal.copyWith(
                            fontSize: 14,
                            color: kDarkGreyColor,
                          ),
                        ),
                        Space.horizontal(16),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackView(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Text(
                              "View",
                              style: context.normal.copyWith(
                                fontSize: 14,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
