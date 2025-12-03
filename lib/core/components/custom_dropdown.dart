import 'package:cctv_app/core/utils/color_constants.dart';
import 'package:cctv_app/core/utils/validators.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hint;
  final double screenWidth;
  final bool isSmallScreen;
  final ValueChanged<T?>? onChanged;
  final Color? borderColor;
  final Color? fillColor;
  final Color? dropdownColor;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.screenWidth,
    required this.isSmallScreen,
    this.onChanged,
    this.borderColor,
    this.fillColor,
    this.dropdownColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? kGreyColor;
    final effectiveFillColor = fillColor ?? kWhiteColor;
    final effectiveDropdownColor = dropdownColor ?? kWhiteColor;

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      validator: (value) {
        return Validators.required(value?.toString());
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.02,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: effectiveBorderColor),
        ),
      ),
      style: TextStyle(fontSize: screenWidth * 0.04),
      dropdownColor: effectiveDropdownColor,
    );
  }
}
