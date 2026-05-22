import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/country.dart';
import '../theme/app_theme.dart';

/// Editorial country card: full-bleed hero image, dark gradient and the
/// country name + tagline overlaid. Sizes to its parent, so it works in a
/// horizontal rail (constrained width) or a responsive grid (expands).
/// The image is wrapped in a [Hero] for a shared-element transition to the
/// country detail screen.
class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;

  const CountryCard({super.key, required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${country.name}. ${country.tagline}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
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
              // Legibility gradient.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Color(0xCC000000), Color(0x00000000)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      style: AppTheme.display(size: 22, color: Colors.white),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      country.tagline,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFE7E2D9),
                        fontSize: 12.5,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
