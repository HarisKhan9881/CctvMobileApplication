import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/adAdmin/pages/admin_profile_page.dart';
import 'package:flutter/material.dart';

class AdminContainerWidget extends StatelessWidget {
  final bool showOnlineStatus;
  const AdminContainerWidget({super.key, this.showOnlineStatus = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminProfilePage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kGreyColor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(Assets.pngHighlight1Image),
                ),
                if (showOnlineStatus)
                  Positioned(
                    bottom: 0,
                    right: 6,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            Space.vertical(6),
            Text("John Doe", style: context.semiBold.copyWith(fontSize: 16)),
            Space.vertical(2),
            Text(
              "Toronoto, Canada",
              style: context.normal.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
