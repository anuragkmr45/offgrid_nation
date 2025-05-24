import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/debouncer.dart';
import 'package:offgrid_nation_app/core/utils/platform_utils.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/login_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  final bool loading;
  static final Debouncer _debouncer = Debouncer(milliseconds: 500);

  const GoogleSignInButton({super.key, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Sign in with Google',
      child: CustomButton(
        onPressed: loading ? () {} : () => _handleGoogleSignIn(context),
        text: 'Continue with Google',
        backgroundColor: AppColors.background,
        // PlatformUtils.isIOS
        //     ? AppColors.background
        //     : AppColors.background,
        textColor: AppColors.textPrimary,
        // PlatformUtils.isIOS
        //     ? AppColors.textPrimary
        //     : AppColors.googleButtonText,
        height: 48,
        width: double.infinity,
        borderRadius: 8,
        icon:
            PlatformUtils.isIOS
                ? null
                : Image.asset(
                  'lib/assets/images/google-icon.png',
                  width: 24,
                  height: 24,
                ),
        loading: loading,
      ),
    );
  }

  void _handleGoogleSignIn(BuildContext context) {
    _debouncer.run(() {
      context.read<LoginBloc>().add(GoogleLoginRequested());
    });
  }
}
