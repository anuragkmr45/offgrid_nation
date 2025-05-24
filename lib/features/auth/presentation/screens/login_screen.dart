import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/features/auth/presentation/widgets/login_widgest/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    // );

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: AppColors.textPrimary,
    //     systemNavigationBarColor: AppColors.primary,
    //     systemNavigationBarIconBrightness: Brightness.light,
    //     statusBarIconBrightness: Brightness.light,
    //   ),
    // );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: AppColors.primary,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: AppColors.primary,
        ),
        child: const LoginForm(),
      );
    } else {
      return Scaffold(
        backgroundColor: AppColors.primary,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const LoginForm(),
      );
    }
  }
}
