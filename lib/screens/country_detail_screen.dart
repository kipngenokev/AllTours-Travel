import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/attraction_category.dart';
import '../models/country.dart';
import '../services/place_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';
import 'places_list_screen.dart';

/// A country's home: hero, blurb and the experience categories it can fill.
/// Each category is a button that lists the places offering that experience.
class CountryDetailScreen extends StatefulWidget {
  final Country country;
  final PlaceService service;

  const CountryDetailScreen({
    super.key,
    required this.country,
    required this.service,
  });

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  late final Future<Set<String>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.service.categoriesForCountry(widget.country.name);
  }

  Country get country => widget.country;

  void _openCategory(AttractionCategory cat) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlacesListScreen(
        title: cat.label,
        eyebrow: country.name,
        future: widget.service
            .placesByCategory(cat.id, country: country.name),
      ),
    ));
  }

  void _openAll() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlacesListScreen(
        title: 'All of ${country.name}',
        eyebrow: 'Every attraction',
        future: widget.service.placesByCountry(country.name),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            title: Text(country.name,
                style: AppTheme.display(size: 20, color: Colors.white)),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: country.heroTag,
                    child: CachedNetworkImage(
                      imageUrl: country.heroImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          Container(color: const Color(0xFFEDEAE3)),
                      errorWidget: (_, _, _) =>
                          Container(color: AppColors.primary),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Color(0xB3000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.tagline.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(country.blurb,
                      style: const TextStyle(
                          fontSize: 15.5, height: 1.6, color: AppColors.ink)),
                  const SizedBox(height: 26),
                  SectionHeader(
                    eyebrow: 'What to do',
                    title: 'Explore by experience',
                    trailing: ArrowLink(label: 'All', onTap: _openAll),
                  ),
                  const SizedBox(height: 16),
                  _CategoryGrid(
                    categories: _categories,
                    onSelect: _openCategory,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final Future<Set<String>> categories;
  final ValueChanged<AttractionCategory> onSelect;

  const _CategoryGrid({required this.categories, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<String>>(
      future: categories,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final present = snap.data ?? const <String>{};
        // Keep the curated display order, drop categories with no places.
        final cats = AttractionCategory.all
            .where((c) => present.contains(c.id))
            .toList();
        if (cats.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Attractions for this country are coming soon.',
              style: TextStyle(color: AppColors.muted),
            ),
          );
        }
        return LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 720 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemCount: cats.length,
              itemBuilder: (_, i) =>
                  _CategoryTile(category: cats[i], onTap: () => onSelect(cats[i])),
            );
          },
        );
      },
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: AppColors.primary, size: 23),
            ),
            const Spacer(),
            Text(category.label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14, height: 1.2)),
            const SizedBox(height: 5),
            Text(category.blurb,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.muted, fontSize: 12, height: 1.35)),
          ],
        ),
      ),
    );
  }
}
