import 'package:flutter/material.dart';

import '../models/attraction_category.dart';
import '../services/place_service.dart';
import '../theme/app_theme.dart';
import 'places_list_screen.dart';

/// Kenya home for browsing attractions by experience. Each category is a
/// button; tapping it lists the places where you can find that kind of site.
class ExploreKenyaScreen extends StatelessWidget {
  final PlaceService service;
  const ExploreKenyaScreen({super.key, required this.service});

  void _openCategory(BuildContext context, AttractionCategory cat) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlacesListScreen(
        title: cat.label,
        eyebrow: 'Kenya',
        future: service.placesByCategory(cat.id, country: 'Kenya'),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Kenya')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
        children: [
          Text('Pick an experience',
              style: AppTheme.display(size: 26)),
          const SizedBox(height: 6),
          const Text(
            'Tap a category to see the places in Kenya where you can find it.',
            style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth >= 720 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.92,
                ),
                itemCount: AttractionCategory.all.length,
                itemBuilder: (_, i) => _CategoryTile(
                  category: AttractionCategory.all[i],
                  onTap: () =>
                      _openCategory(context, AttractionCategory.all[i]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final AttractionCategory category;
  final VoidCallback onTap;
  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: AppColors.primary, size: 24),
            ),
            const Spacer(),
            Text(category.label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14.5, height: 1.2)),
            const SizedBox(height: 6),
            Text(category.blurb,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.muted, fontSize: 12.5, height: 1.35)),
          ],
        ),
      ),
    );
  }
}
