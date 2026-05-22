import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';
import '../theme/app_theme.dart';
import '../utils/season.dart';
import '../widgets/video_preview.dart';

/// Full destination page: image carousel, key facts, video preview,
/// description, best-season guidance and travel guidelines.
class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Place get place => widget.place;

  @override
  Widget build(BuildContext context) {
    final images = place.galleryImages;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _Gallery(
                images: images,
                controller: _pageController,
                page: _page,
                onPage: (i) => setState(() => _page = i),
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
                    '${place.country.toUpperCase()}  ·  ${place.continent.toUpperCase()}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(place.name,
                            style: AppTheme.display(size: 32)),
                      ),
                      const Icon(Icons.star_rounded,
                          color: AppColors.accent, size: 22),
                      const SizedBox(width: 4),
                      Text(place.rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                    ],
                  ),
                  if (place.summary != null) ...[
                    const SizedBox(height: 8),
                    Text(place.summary!,
                        style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 15,
                            height: 1.4)),
                  ],
                  const SizedBox(height: 18),
                  _BestSeasons(place: place),
                  if (place.tags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [for (final t in place.tags) _Tag(t)],
                    ),
                  ],
                  if (place.videoUrl != null &&
                      place.videoUrl!.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    _Heading('Preview film'),
                    const SizedBox(height: 12),
                    VideoPreview(url: place.videoUrl!),
                  ],
                  if (place.description != null) ...[
                    const SizedBox(height: 26),
                    _Heading('About'),
                    const SizedBox(height: 10),
                    Text(place.description!,
                        style: const TextStyle(
                            fontSize: 15, height: 1.6, color: AppColors.ink)),
                  ],
                  if (place.guidelines != null) ...[
                    const SizedBox(height: 26),
                    _Heading('Travel guidelines'),
                    const SizedBox(height: 12),
                    _Guidelines(text: place.guidelines!),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final int page;
  final ValueChanged<int> onPage;

  const _Gallery({
    required this.images,
    required this.controller,
    required this.page,
    required this.onPage,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(color: AppColors.primary);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: controller,
          onPageChanged: onPage,
          itemCount: images.length,
          itemBuilder: (_, i) => CachedNetworkImage(
            imageUrl: images[i],
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: const Color(0xFFEDEAE3)),
            errorWidget: (_, __, ___) =>
                Container(color: AppColors.primary),
          ),
        ),
        // Bottom gradient for legibility of the dots.
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < images.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: i == page ? 20 : 6,
                    decoration: BoxDecoration(
                      color: i == page ? Colors.white : Colors.white60,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BestSeasons extends StatelessWidget {
  final Place place;
  const _BestSeasons({required this.place});

  @override
  Widget build(BuildContext context) {
    // Map the place's best months to season labels for its hemisphere.
    final seasons = <Season>{};
    for (final s in Season.values) {
      final window = SeasonUtil.monthsFor(s, hemisphere: place.hemisphere);
      if (place.bestMonths.any(window.contains)) seasons.add(s);
    }
    final months = place.bestMonths.toList()..sort();
    final monthLabel =
        months.map((m) => SeasonUtil.monthName(m).substring(0, 3)).join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Best time to visit',
                  style: AppTheme.display(size: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in seasons)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Text('${s.emoji} ${s.label}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                ),
            ],
          ),
          if (monthLabel.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Months: $monthLabel',
                style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}

class _Guidelines extends StatelessWidget {
  final String text;
  const _Guidelines({required this.text});

  @override
  Widget build(BuildContext context) {
    // Split sentences into bullet-style tips.
    final tips = text
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final tip in tips)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.check_circle_outline,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tip,
                      style: const TextStyle(
                          fontSize: 14.5, height: 1.45, color: AppColors.ink)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  final String text;
  const _Heading(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTheme.display(size: 20));
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Text('#$label',
          style: const TextStyle(fontSize: 12.5, color: AppColors.muted)),
    );
  }
}
