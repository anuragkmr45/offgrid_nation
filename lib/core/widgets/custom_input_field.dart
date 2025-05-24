import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // Wrap CupertinoTextField in a FormField for validation
      return FormField<String>(
        initialValue: controller.text,
        validator: validator,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoTextField(
                controller: controller,
                placeholder: placeholder,
                obscureText: obscureText,
                keyboardType: keyboardType,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        field.hasError ? AppColors.accent : Colors.transparent,
                  ),
                ),
                onChanged: (value) {
                  field.didChange(value);
                },
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    } else {
      // Use TextFormField for Android
      return TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: placeholder,
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      );
    }
  }
}
