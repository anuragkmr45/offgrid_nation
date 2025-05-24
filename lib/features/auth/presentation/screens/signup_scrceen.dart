import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/features/auth/presentation/widgets/signup_widgets/signup_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        backgroundColor: AppColors.primary,
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Create an Account'),
          backgroundColor: AppColors.primary.withOpacity(0.9),
        ),
        child: SafeArea(child: const SignupForm()),
      );
    } else {
      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: const Text('Create an Account'),
          backgroundColor: AppColors.primary,
        ),
        body: SafeArea(child: const SignupForm()),
      );
    }
  }
}
