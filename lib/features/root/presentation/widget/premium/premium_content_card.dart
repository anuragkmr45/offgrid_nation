import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_feature_item.dart';

class PremiumContentCard extends StatelessWidget {
  final VoidCallback onPayTap;
  final bool isLoading;

  const PremiumContentCard({
    super.key,
    required this.onPayTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFE8235), Color(0xFFF93B63)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome to\nOffgrid Premium',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Unlock Premium Access! 🚀',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const PremiumFeatureItem(
            emoji: '✅',
            text: 'Exclusive Content – Get special access to premium insights.',
          ),
          const PremiumFeatureItem(
            emoji: '✅',
            text: 'Regular Updates – Fresh content added by the admin.',
          ),
          const PremiumFeatureItem(
            emoji: '✅',
            text:
                'Instant Alerts – Get notified when new premium content drops!',
          ),
          const SizedBox(height: 16),
          Text(
            'Subscribe now & elevate your experience! ✨',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: isLoading ? 'Processing...' : 'Pay',
            onPressed: onPayTap,
            loading: isLoading,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            width: double.infinity,
            height: 48,
          ),
        ],
      ),
    );
  }
}
