import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/premium_state.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_feed_android.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_feed_error.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_feed_ios.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_feed_loader.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_subscribe_overlay.dart';

class PremiumFeedBuilder extends StatelessWidget {
  const PremiumFeedBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PremiumBloc>().state;

    if (state is PremiumFeedLoading) {
      return const PremiumFeedLoader();
    }

    if (state is PremiumUserNotSubscribed) {
      return const PremiumSubscribeOverlay();
    }

    if (state is PremiumFeedLoaded) {
      return Platform.isIOS
          ? PremiumFeedIOS(posts: state.posts)
          : PremiumFeedAndroid(posts: state.posts);
    }

    if (state is PremiumFeedFailure) {
      return PremiumFeedError(message: state.message);
    }

    return const SizedBox.shrink();
  }
}
