import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/feature/drawer/widget/custom_post_history_container.dart';
import 'package:flutter/material.dart';

class PostHistory extends StatelessWidget {
  const PostHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: Text("Post History"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomPostHistoryContainer(),
              Space.vertical(6),
              CustomPostHistoryContainer(),
              Space.vertical(6),
              CustomPostHistoryContainer(),
              Space.vertical(6),
              CustomPostHistoryContainer(),
              Space.vertical(6),
              CustomPostHistoryContainer(),
              Space.vertical(6),
            ],
          ),
        ),
      ),
    );
  }
}
