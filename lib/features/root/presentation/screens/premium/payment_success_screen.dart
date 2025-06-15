import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/navigation/global_navigator.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  const CheckoutSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You’ve unlocked premium access 🎉',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final bloc = context.read<PremiumBloc>();
                bloc.add(FetchPremiumFeedRequested());

                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                  arguments: {'initialTab': 4},
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
