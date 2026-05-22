import 'package:flutter/material.dart';

import '../services/place_service.dart';
import '../theme/app_theme.dart';
import 'places_list_screen.dart';

/// Browse destinations by choosing a continent.
class ContinentScreen extends StatelessWidget {
  final PlaceService service;
  const ContinentScreen({super.key, required this.service});

  // Continent → representative image seed + emoji.
  static const _continents = <(String, String, String)>[
    ('Africa', '🦁', 'serengeti'),
    ('Asia', '⛩️', 'kyoto'),
    ('Europe', '🏛️', 'paris'),
    ('North America', '🏔️', 'banff'),
    ('South America', '🌄', 'machupicchu'),
    ('Oceania', '🏝️', 'sydney'),
    ('Antarctica', '🧊', 'antarctica'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('By Continent')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text('Where in the world?', style: AppTheme.display(size: 26)),
          const SizedBox(height: 6),
          const Text(
            'Pick a continent to explore its standout destinations.',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          for (final (name, emoji, seed) in _continents)
            _ContinentTile(
              name: name,
              emoji: emoji,
              imageUrl: 'https://picsum.photos/seed/$seed/600/400',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PlacesListScreen(
                    title: name,
                    eyebrow: 'Continent',
                    future: service.placesByContinent(name),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContinentTile extends StatelessWidget {
  final String name;
  final String emoji;
  final String imageUrl;
  final VoidCallback onTap;

  const _ContinentTile({
    required this.name,
    required this.emoji,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.38),
              BlendMode.darken,
            ),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(name,
                  style: AppTheme.display(size: 24, color: Colors.white)),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
