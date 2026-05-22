import 'package:flutter/material.dart';

import '../models/service_tier.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';
import 'my_requests_screen.dart';
import 'request_plan_screen.dart';

/// The consultancy storefront: the pitch ("local intelligence & safety"),
/// what every traveller receives, and the three pricing tiers.
class ConsultancyScreen extends StatelessWidget {
  const ConsultancyScreen({super.key});

  void _open(BuildContext context, Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan with us'),
        actions: [
          TextButton(
            onPressed: () => _open(context, const MyRequestsScreen()),
            child: const Text('My requests'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _Hero(),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              eyebrow: 'What you get',
              title: 'A plan built around you',
            ),
          ),
          const SizedBox(height: 16),
          for (final d in ServiceDeliverable.all) _DeliverableRow(item: d),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              eyebrow: 'Choose your level',
              title: 'Pricing',
            ),
          ),
          const SizedBox(height: 16),
          for (final tier in ServiceTier.all)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _TierCard(
                tier: tier,
                onSelect: () => _open(
                  context,
                  RequestPlanScreen(tier: tier),
                ),
              ),
            ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: Text(
              'Final price within each range depends on trip length, number of '
              'destinations and how custom the plan needs to be. You confirm '
              'the exact quote before any payment.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LOCAL INTELLIGENCE & SAFETY',
            style: TextStyle(
              color: AppColors.accent.withValues(alpha: 0.95),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Travel with a local\nin your corner',
            style: AppTheme.display(size: 34, color: Colors.white),
          ),
          const SizedBox(height: 14),
          const Text(
            'We design your itinerary, point you to companies worth trusting, '
            'help you combine places like Nairobi, safari and the coast, and '
            'tell you how to avoid being overcharged — so you can relax and '
            'enjoy the trip.',
            style: TextStyle(
              color: Color(0xFFD9E4E2),
              fontSize: 15,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliverableRow extends StatelessWidget {
  final ServiceDeliverable item;
  const _DeliverableRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.line),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 3),
                Text(item.detail,
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 13.5, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final ServiceTier tier;
  final VoidCallback onSelect;

  const _TierCard({required this.tier, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final highlighted = tier.recommended;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.line,
          width: highlighted ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (highlighted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Text(
                'MOST POPULAR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tier.name, style: AppTheme.display(size: 22)),
                const SizedBox(height: 4),
                Text(
                  tier.priceLabel,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(tier.tagline,
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 14, height: 1.4)),
                const SizedBox(height: 16),
                for (final f in tier.features)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(Icons.check_rounded,
                              size: 18, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(f,
                              style: const TextStyle(
                                  fontSize: 14, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                if (highlighted)
                  FilledButton(
                    onPressed: onSelect,
                    child: Text('Request the ${tier.name} plan'),
                  )
                else
                  OutlinedButton(
                    onPressed: onSelect,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(52),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Request the ${tier.name} plan'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
