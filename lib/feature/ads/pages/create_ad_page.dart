import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CreateAdPage extends StatelessWidget {
  const CreateAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: const Text("Create new ads"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select category", style: context.semiBold),
              Space.vertical(6),
              DropdownButtonFormField<String>(
                dropdownColor: kWhiteColor,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
                hint: const Text("Select"),
                items: <String>['Category 1', 'Category 2', 'Category 3'].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              Space.vertical(20),
              Text("Heading", style: context.semiBold),
              Space.vertical(10),
              CustomTextField(maxLine: 5, hintText: "Write heading"),
              Space.vertical(20),
              Text("Important note", style: context.semiBold),
              Space.vertical(10),
              CustomTextField(maxLine: 5, hintText: "Write message"),
              Space.vertical(20),
              Text("Upload cover photo", style: context.semiBold),
              Space.vertical(10),
              CustomTextField(
                hintText: "Upload",
                readOnly: true,
                onTap: () {},
                suffix: Icon(Icons.attach_file),
              ),
              Space.vertical(20),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: "Clear",
                      textColor: kBlackColor,
                      borderColor: kPrimaryColor,
                      buttonColor: kWhiteColor,
                      showBorder: true,
                      onPressed: () {},
                    ),
                  ),
                  Space.horizontal(10),
                  Expanded(
                    child: PrimaryButton(text: "Boots now", onPressed: () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
