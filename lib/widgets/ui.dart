import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A minimal text CTA with a trailing arrow, e.g. "View all →".
/// Mirrors the editorial link style of the reference design.
class ArrowLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const ArrowLink({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: c,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward, size: 16, color: c),
          ],
        ),
      ),
    );
  }
}

/// An editorial section header: serif title, optional eyebrow + trailing link.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Text(
                  eyebrow!.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(title, style: AppTheme.display(size: 24)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
