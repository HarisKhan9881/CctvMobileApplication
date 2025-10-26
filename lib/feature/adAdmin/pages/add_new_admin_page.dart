import 'package:cctv_app/core/components/custom_textfield.dart';
import 'package:cctv_app/core/components/primary_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/utils/assets.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class AddNewAdminPage extends StatelessWidget {
  const AddNewAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: const Text('New Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: kLightGreyColor,
                      backgroundImage: const AssetImage(
                        Assets.pngHighlight1Image,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: kWhiteColor,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Name"),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "First Name",
                prefix: Icon(Icons.person_2_outlined),
              ),

              SizedBox(height: 20),
              Text("Email"),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "First Email",
                prefix: Icon(Icons.email_outlined),
              ),

              SizedBox(height: 20),
              Text("Password"),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "Set Password",
                prefix: Icon(Icons.lock_outline),
              ),

              SizedBox(height: 20),
              Text("Birth date (Optional)"),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: kWhiteColor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text("Date"),
                      items: <String>['Category 1', 'Category 2', 'Category 3']
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: kWhiteColor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text("Month"),
                      items: <String>['Category 1', 'Category 2', 'Category 3']
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: kWhiteColor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      hint: const Text("Year"),
                      items: <String>['Category 1', 'Category 2', 'Category 3']
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Assign Role"),
              Space.vertical(6),
              DropdownButtonFormField<String>(
                dropdownColor: kWhiteColor,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
                hint: const Text("Select Role"),
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
              SizedBox(height: 20),
              Align(alignment: Alignment.centerRight, child: Text("Clear all")),
              SizedBox(height: 20),
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
                    child: PrimaryButton(text: "Add Profile", onPressed: () {}),
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
