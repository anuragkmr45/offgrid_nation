import 'dart:io';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/reset_password_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/screens/product_details_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/notification_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/user_profile_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/notification/notification_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/privacy_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/user_profile/profile_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/settings_screen.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/screens/create_listing_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/user_profile/user_profile_screen.dart';
import 'package:offgrid_nation_app/injection_container.dart' as di show sl;
import 'package:device_preview/device_preview.dart' show DevicePreview;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:offgrid_nation_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:offgrid_nation_app/features/auth/presentation/screens/login_screen.dart';
import 'package:offgrid_nation_app/features/auth/presentation/screens/signup_scrceen.dart';
import 'package:offgrid_nation_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/chat/conversation_screen.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/screens/marketplace_screen.dart';
import 'package:offgrid_nation_app/core/widgets/wrapper/root_screen.dart';

import 'package:offgrid_nation_app/core/navigation/global_navigator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    bool isIOS = false;
    if (kIsWeb) {
      isIOS = DevicePreview.platform(context) == TargetPlatform.iOS;
    } else {
      isIOS = Platform.isIOS;
    }

    if (isIOS) {
      return CupertinoApp(
        title: 'OffGrid Nation',
        theme: _buildCupertinoTheme(),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/auth/login':
              (context) => BlocProvider<LoginBloc>(
                create: (_) => di.sl<LoginBloc>(),
                child: const LoginScreen(),
              ),
          '/auth/signup':
              (context) => BlocProvider<SignupBloc>(
                create: (_) => di.sl<SignupBloc>(),
                child: const SignupScreen(),
              ),
          '/auth/reset':
              (context) => BlocProvider<ResetPasswordBloc>(
                create: (_) => di.sl<ResetPasswordBloc>(),
                child: const ResetPasswordScreen(),
              ),
          '/home': (context) => const RootScreen(),
          '/conversation': (context) => const ConversationScreen(),
          '/marketplace': (context) => const MarketplaceScreen(),
          '/marketplace/create-listing':
              (context) => BlocProvider<MarketplaceBloc>(
                create: (_) => di.sl<MarketplaceBloc>(),
                child: const CreateListingScreen(),
              ),
          '/product-details': (context) {
            final productId =
                ModalRoute.of(context)!.settings.arguments as String;
            return ProductDetailsScreen(productId: productId);
          },
          '/settings': (context) => const SettingsPage(),
          '/profile':
              (context) => BlocProvider<UserProfileBloc>(
                create: (_) => di.sl<UserProfileBloc>(),
                child: const MyProfileScreen(),
              ),
          '/user-profile':
              (context) => BlocProvider<UserProfileBloc>(
                create: (_) => di.sl<UserProfileBloc>(),
                child: const UserProfileScreen(),
              ),
          '/privacy':
              (context) => BlocProvider<UserProfileBloc>(
                create: (_) => di.sl<UserProfileBloc>(),
                child: const PrivacyScreen(),
              ),
          '/notifications':
              (context) => BlocProvider<NotificationBloc>(
                create: (_) => di.sl<NotificationBloc>(),
                child: const NotificationScreen(),
              ),
        },
      );
    } else {
      return MaterialApp(
        title: 'OffGrid Nation',
        theme: AppTheme.materialTheme(),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/auth/login':
              (context) => BlocProvider<LoginBloc>(
                create: (_) => di.sl<LoginBloc>(),
                child: const LoginScreen(),
              ),

          '/auth/signup':
              (context) => BlocProvider<SignupBloc>(
                create: (_) => di.sl<SignupBloc>(),
                child: const SignupScreen(),
              ),
          '/auth/reset':
              (context) => BlocProvider<ResetPasswordBloc>(
                create: (_) => di.sl<ResetPasswordBloc>(),
                child: const ResetPasswordScreen(),
              ),
          '/home': (context) => const RootScreen(),
          '/conversation': (context) => const ConversationScreen(),
          '/marketplace': (context) => const MarketplaceScreen(),
          '/marketplace/create-listing':
              (context) => BlocProvider<MarketplaceBloc>(
                create: (_) => di.sl<MarketplaceBloc>(),
                child: const CreateListingScreen(),
              ),

          '/product-details': (context) {
            final productId =
                ModalRoute.of(context)!.settings.arguments as String;
            return ProductDetailsScreen(productId: productId);
          },

          '/settings': (context) => const SettingsPage(),
          '/profile':
              (context) => BlocProvider<UserProfileBloc>(
                create: (_) => di.sl<UserProfileBloc>(),
                child: const MyProfileScreen(),
              ),
          '/user-profile':
              (context) => BlocProvider<UserProfileBloc>(
                create: (_) => di.sl<UserProfileBloc>(),
                child: const UserProfileScreen(),
              ),
          '/privacy':
              (context) => BlocProvider<UserProfileBloc>(
                create: (_) => di.sl<UserProfileBloc>(),
                child: const PrivacyScreen(),
              ),
          '/notifications':
              (context) => BlocProvider<NotificationBloc>(
                create: (_) => di.sl<NotificationBloc>(),
                child: const NotificationScreen(),
              ),
        },
      );
    }
  }

  CupertinoThemeData _buildCupertinoTheme() {
    return CupertinoThemeData(
      primaryColor: AppTheme.cupertinoTheme().primaryColor,
      barBackgroundColor: AppTheme.cupertinoTheme().primaryColor,
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      textTheme: const CupertinoTextThemeData(
        textStyle: TextStyle(fontFamily: 'San Francisco'),
      ),
    );
  }
}
