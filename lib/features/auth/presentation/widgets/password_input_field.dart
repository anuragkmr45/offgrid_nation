import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/form_validation/login_form_validation.dart';
import 'package:offgrid_nation_app/core/widgets/custom_input_field.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CustomInputField(
          controller: widget.controller,
          placeholder: 'Password',
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          validator: LoginFormValidation.validatePassword,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () {
              // Haptic Feedback (only on iOS)
              if (Platform.isIOS) {
                HapticFeedback.mediumImpact();
              }

              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child:
                  Platform.isIOS
                      ? Icon(
                        _obscurePassword
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        key: ValueKey(_obscurePassword),
                        color: CupertinoColors.systemGrey,
                      )
                      : Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        key: ValueKey(_obscurePassword),
                        color: AppColors.textSecondary,
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
