import 'package:flutter/material.dart';

import '../models/place.dart';
import '../theme/app_theme.dart';
import '../widgets/place_card.dart';
import 'place_detail_screen.dart';

/// Generic results screen: shows a titled, scrollable grid/list of places
/// resolved from [future]. Reused by season, continent and search flows.
class PlacesListScreen extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final Future<List<Place>> future;

  const PlacesListScreen({
    super.key,
    required this.title,
    required this.future,
    this.eyebrow,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<Place>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return _Message(
              icon: Icons.cloud_off,
              text: 'Could not load destinations.\n${snap.error}',
            );
          }
          final places = snap.data ?? [];
          if (places.isEmpty) {
            return const _Message(
              icon: Icons.search_off,
              text: 'No destinations found here yet.',
            );
          }
          return LayoutBuilder(
            builder: (context, c) {
              // Responsive: a multi-column grid on wide (web/tablet) screens,
              // a single column on phones.
              final cols = c.maxWidth >= 1100
                  ? 3
                  : c.maxWidth >= 720
                      ? 2
                      : 1;
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.78,
                ),
                itemCount: places.length,
                itemBuilder: (_, i) => PlaceCard(
                  place: places[i],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailScreen(place: places[i]),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Message({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
