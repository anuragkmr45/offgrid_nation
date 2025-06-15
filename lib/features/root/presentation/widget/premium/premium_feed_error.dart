import 'package:flutter/material.dart';

class PremiumFeedError extends StatelessWidget {
  final String message;

  const PremiumFeedError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFbbc06),
      child: Center(
        child: Text(
          'Something went wrong.\n$message',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
