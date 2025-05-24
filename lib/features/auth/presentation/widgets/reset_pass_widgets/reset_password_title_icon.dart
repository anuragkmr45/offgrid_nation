import 'package:flutter/material.dart';

class ResetPasswordTitleIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const ResetPasswordTitleIcon({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, color: Colors.white, size: 28),
      ],
    );
  }
}
