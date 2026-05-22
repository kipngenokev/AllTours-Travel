import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/place_service.dart';
import '../theme/app_theme.dart';
import '../widgets/country_card.dart';
import 'country_detail_screen.dart';

/// Browse every African destination as an editorial card grid.
class ExploreAfricaScreen extends StatelessWidget {
  final PlaceService service;
  const ExploreAfricaScreen({super.key, required this.service});

  void _open(BuildContext context, Country country) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          CountryDetailScreen(country: country, service: service),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Africa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
        children: [
          Text('Where in Africa?', style: AppTheme.display(size: 26)),
          const SizedBox(height: 6),
          const Text(
            'Choose a country to see its attractions grouped by experience.',
            style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth >= 1000
                  ? 3
                  : c.maxWidth >= 640
                      ? 2
                      : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: cols == 1 ? 1.5 : 0.82,
                ),
                itemCount: Country.all.length,
                itemBuilder: (_, i) => CountryCard(
                  country: Country.all[i],
                  onTap: () => _open(context, Country.all[i]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
