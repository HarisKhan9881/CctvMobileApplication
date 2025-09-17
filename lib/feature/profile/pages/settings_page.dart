import 'package:cctv_app/core/components/custom_switch_button.dart';
import 'package:cctv_app/core/components/space.dart';
import 'package:cctv_app/core/extensions/context.dart';
import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // yahan sab switches ke liye variables
  bool generalNotification = false;
  bool sound = false;
  bool vibrate = false;
  bool appUpdates = false;
  bool billReminder = false;
  bool promotion = false;
  bool discountAvailable = false;
  bool paymentRequest = false;
  bool newServiceAvailable = false;
  bool newTipsAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Common", style: context.semiBold.copyWith(fontSize: 18)),
              Space.vertical(12),

              // General Notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "General Notification",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        generalNotification = val;
                      });
                    },
                    isToggled: generalNotification,
                  ),
                ],
              ),
              Space.vertical(16),

              // Sound
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sound", style: context.normal.copyWith(fontSize: 16)),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        sound = val;
                      });
                    },
                    isToggled: sound,
                  ),
                ],
              ),
              Space.vertical(16),

              // Vibrate
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Vibrate", style: context.normal.copyWith(fontSize: 16)),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        vibrate = val;
                      });
                    },
                    isToggled: vibrate,
                  ),
                ],
              ),

              Space.vertical(20),
              Text(
                "System & services update",
                style: context.semiBold.copyWith(fontSize: 18),
              ),
              Space.vertical(12),

              // App Updates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "App updates",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        appUpdates = val;
                      });
                    },
                    isToggled: appUpdates,
                  ),
                ],
              ),
              Space.vertical(16),

              // Bill Reminder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bill Reminder",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        billReminder = val;
                      });
                    },
                    isToggled: billReminder,
                  ),
                ],
              ),
              Space.vertical(16),

              // Promotion
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Promotion",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        promotion = val;
                      });
                    },
                    isToggled: promotion,
                  ),
                ],
              ),
              Space.vertical(16),

              // Discount Available
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discount Available",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        discountAvailable = val;
                      });
                    },
                    isToggled: discountAvailable,
                  ),
                ],
              ),
              Space.vertical(16),

              // Payment Request
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Request",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        paymentRequest = val;
                      });
                    },
                    isToggled: paymentRequest,
                  ),
                ],
              ),

              Space.vertical(20),
              Text("Others", style: context.semiBold.copyWith(fontSize: 18)),
              Space.vertical(12),

              // New Service Available
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New Service Available",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        newServiceAvailable = val;
                      });
                    },
                    isToggled: newServiceAvailable,
                  ),
                ],
              ),
              Space.vertical(16),

              // New Tips Available
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New Tips Available",
                    style: context.normal.copyWith(fontSize: 16),
                  ),
                  CustomSwitchButton(
                    onToggle: (val) {
                      setState(() {
                        newTipsAvailable = val;
                      });
                    },
                    isToggled: newTipsAvailable,
                  ),
                ],
              ),
              Space.vertical(16),
            ],
          ),
        ),
      ),
    );
  }
}
