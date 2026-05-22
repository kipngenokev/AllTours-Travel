import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A consultancy package the traveller can buy. Tiers are static product
/// content (they rarely change), so they live in code rather than the DB.
/// When a traveller submits a request we snapshot the tier id, name and
/// price label onto the row so historical requests stay accurate even if
/// pricing is later revised.
class ServiceTier {
  final String id;
  final String name;
  final String priceLabel;
  final String tagline;
  final List<String> features;

  /// Visually highlighted as the "best value" option.
  final bool recommended;

  /// Whether this tier includes a live consultation call.
  final bool includesCall;

  const ServiceTier({
    required this.id,
    required this.name,
    required this.priceLabel,
    required this.tagline,
    required this.features,
    this.recommended = false,
    this.includesCall = false,
  });

  static const List<ServiceTier> all = [
    ServiceTier(
      id: 'essential',
      name: 'Essential',
      priceLabel: '\$50 – \$100',
      tagline: 'A solid plan so you arrive knowing exactly what to do.',
      features: [
        'Day-by-day PDF itinerary',
        'General lodge & transport recommendations',
        'Best routes and when to move between places',
        'Core safety briefing for your destinations',
      ],
    ),
    ServiceTier(
      id: 'premium',
      name: 'Premium',
      priceLabel: '\$120 – \$250',
      tagline: 'Detailed planning with named, vetted local picks.',
      recommended: true,
      includesCall: true,
      features: [
        'Detailed day-by-day itinerary',
        'Specific recommendations — lodges, drivers, activities',
        'Full cost breakdown: where to save vs. spend',
        'Booking guidance & the red flags to avoid',
        'One consultation call (45 min)',
      ],
    ),
    ServiceTier(
      id: 'concierge',
      name: 'Concierge',
      priceLabel: '\$300 – \$500+',
      tagline: 'We plan it end to end — you just travel.',
      includesCall: true,
      features: [
        'Fully customised itinerary, revised together',
        'Personal booking assistance',
        'Ongoing support throughout your trip',
        'A direct line for questions & changes',
        'Priority safety & on-the-ground guidance',
      ],
    ),
  ];

  static ServiceTier? byId(String id) {
    for (final t in all) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// One of the deliverables every traveller receives, used on the pitch page.
class ServiceDeliverable {
  final IconData icon;
  final String title;
  final String detail;

  const ServiceDeliverable({
    required this.icon,
    required this.title,
    required this.detail,
  });

  static const List<ServiceDeliverable> all = [
    ServiceDeliverable(
      icon: Icons.map_outlined,
      title: 'Full day-by-day itinerary',
      detail: 'Where to go, what to do, and exactly when to move on.',
    ),
    ServiceDeliverable(
      icon: Icons.verified_outlined,
      title: 'Trusted recommendations',
      detail: 'Lodges, transport and activities we actually stand behind.',
    ),
    ServiceDeliverable(
      icon: Icons.payments_outlined,
      title: 'Honest cost breakdown',
      detail: 'Estimated pricing and where it is worth saving vs. spending.',
    ),
    ServiceDeliverable(
      icon: Icons.shield_outlined,
      title: 'Booking guidance',
      detail: 'Who to book with — and the red flags that signal an overcharge.',
    ),
    ServiceDeliverable(
      icon: Icons.support_agent_outlined,
      title: 'Optional walkthrough call',
      detail: 'A live session to walk the plan and answer every question.',
    ),
  ];
}

/// Brand accent helpers shared by the consultancy screens.
class ServicePalette {
  static const Color highlight = AppColors.accent;
}
