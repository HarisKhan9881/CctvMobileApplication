import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomHorizontalListViewWidget extends StatelessWidget {
  final List<String> items;
  final int selectedItem;
  final ValueChanged<int> onTap;
  const CustomHorizontalListViewWidget({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = index == selectedItem;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              margin: EdgeInsets.only(right: index == items.length - 1 ? 0 : 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : kWhiteColor,
                border: Border.all(
                  color: isSelected ? kPrimaryColor : kGreyColor,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                items[index],
                style: context.semiBold.copyWith(
                  color: isSelected ? kWhiteColor : kBlackColor,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
