import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutFailureScreen extends StatelessWidget {
  const CheckoutFailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cancel, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'Payment Failed',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Something went wrong or was cancelled.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
