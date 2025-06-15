import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/premium_state.dart';
import 'package:offgrid_nation_app/features/root/presentation/screens/premium/webview_screen.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_feed_builder.dart';
import 'package:offgrid_nation_app/injection_container.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PremiumBloc>()..add(FetchPremiumFeedRequested()),
      child: Scaffold(
        backgroundColor: const Color(0xFFFbbc06),
        body: BlocConsumer<PremiumBloc, PremiumState>(
          listener: (context, state) {
            if (state is CreateCheckoutSessionFailure) {
              final error = state.message;
              Platform.isIOS
                  ? showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: const Text('Error'),
                        content: Text(error),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    )
                  : ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );
            } else if (state is CreateCheckoutSessionSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebViewScreen(url: state.checkoutUrl),
                ),
              );
            }
          },
          builder: (context, state) => const PremiumFeedBuilder(),
        ),
      ),
    );
  }
}
