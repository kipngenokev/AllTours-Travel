import 'package:flutter/material.dart';

import '../services/place_service.dart';
import '../theme/app_theme.dart';
import '../utils/season.dart';
import 'places_list_screen.dart';

/// Lets the tourist choose a season (or "right now") to get suggestions for.
class SeasonScreen extends StatelessWidget {
  final PlaceService service;
  const SeasonScreen({super.key, required this.service});

  void _openSeason(BuildContext context, Season season) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlacesListScreen(
        title: '${season.emoji} Best in ${season.label}',
        eyebrow: 'Seasonal picks',
        future: service.placesInSeason(season),
      ),
    ));
  }

  void _openNow(BuildContext context) {
    final month = DateTime.now().month;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlacesListScreen(
        title: 'Best to visit now',
        eyebrow: SeasonUtil.monthName(month),
        future: service.placesInMonth(month),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('By Season')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text('When are you travelling?', style: AppTheme.display(size: 26)),
          const SizedBox(height: 6),
          const Text(
            'Pick a season and we’ll suggest destinations at their very best — '
            'tuned to each place’s hemisphere.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 20),
          _NowTile(onTap: () => _openNow(context)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              for (final s in Season.values)
                _SeasonTile(season: s, onTap: () => _openSeason(context, s)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NowTile extends StatelessWidget {
  final VoidCallback onTap;
  const _NowTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final month = SeasonUtil.monthName(DateTime.now().month);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.explore, color: Colors.white, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Best to visit right now',
                      style: AppTheme.display(size: 19, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('Top picks for $month',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _SeasonTile extends StatelessWidget {
  final Season season;
  final VoidCallback onTap;
  const _SeasonTile({required this.season, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(season.emoji, style: const TextStyle(fontSize: 30)),
            Row(
              children: [
                Text(season.label, style: AppTheme.display(size: 20)),
                const Spacer(),
                const Icon(Icons.arrow_forward,
                    size: 18, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
