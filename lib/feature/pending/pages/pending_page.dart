import 'package:cctv_app/core/components/search_bar_header.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/feature/pending/widget/custom_case_container.dart';
import 'package:flutter/material.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarHeader(),
          Space.vertical(12),
          Text("Case Pending", style: context.bold.copyWith(fontSize: 24)),
          Space.vertical(20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: CustomCaseContainer()),
                      Space.horizontal(12),
                      Expanded(child: CustomCaseContainer()),
                    ],
                  ),
                  Space.vertical(16),
                  Row(
                    children: [
                      Expanded(child: CustomCaseContainer()),
                      Space.horizontal(12),
                      Expanded(child: CustomCaseContainer()),
                    ],
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
