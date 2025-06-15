import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/premium_state.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_content_card.dart';

class PremiumSubscribeOverlay extends StatelessWidget {
  const PremiumSubscribeOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PremiumBloc>().state;
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
        Container(
          color: Color(0xFFFbbc06),
          child: Center(
            child: PremiumContentCard(
              onPayTap:
                  () => context.read<PremiumBloc>().add(
                    CreateCheckoutSessionRequested(),
                  ),
              isLoading: state is CreateCheckoutSessionLoading,
            ),
          ),
        ),
      ],
    );
  }
}
