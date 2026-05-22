import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';
import '../theme/app_theme.dart';

/// An editorial, image-forward destination card: flat, hairline border,
/// serif name, terracotta location meta and a star rating chip on the image.
class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final double width;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onTap,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 11,
                  child: _Cover(url: place.coverImageUrl),
                ),
                if (place.videoUrl != null && place.videoUrl!.isNotEmpty)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: _Badge(icon: Icons.play_arrow_rounded, label: 'Film'),
                  ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: _Badge(
                    icon: Icons.star_rounded,
                    label: place.rating.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${place.country.toUpperCase()}  ·  ${place.continent.toUpperCase()}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.name,
                    style: AppTheme.display(size: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (place.summary != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      place.summary!,
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 13, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String? url;
  const _Cover({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        color: AppColors.primary.withValues(alpha: 0.08),
        child: const Icon(Icons.landscape, size: 48, color: AppColors.primary),
      );
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: const Color(0xFFEDEAE3)),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.primary.withValues(alpha: 0.08),
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppColors.muted),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3)),
        ],
      ),
    );
  }
}
