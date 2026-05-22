import 'package:flutter/material.dart';

/// An "experience" lens on Africa's attractions. The [id] matches the values
/// stored in `places.categories`, so tapping a category filters the catalogue.
/// Categories are curated content, so they live in code, not the DB. Each
/// country surfaces only the categories it actually has places for.
class AttractionCategory {
  final String id;
  final String label;
  final String blurb;
  final IconData icon;

  const AttractionCategory({
    required this.id,
    required this.label,
    required this.blurb,
    required this.icon,
  });

  /// In intended display order (most iconic first).
  static const List<AttractionCategory> all = [
    AttractionCategory(
      id: 'wildlife',
      label: 'Wildlife & Safari',
      blurb: 'Big Five parks, the Mara migration and conservancies.',
      icon: Icons.pets_outlined,
    ),
    AttractionCategory(
      id: 'migration',
      label: 'Wildebeest Migration',
      blurb: 'Follow the great herds and the Mara River crossings.',
      icon: Icons.route_outlined,
    ),
    AttractionCategory(
      id: 'gorillas',
      label: 'Gorillas & Primates',
      blurb: 'Mountain gorilla and chimpanzee treks in the rainforest.',
      icon: Icons.forest_outlined,
    ),
    AttractionCategory(
      id: 'coast',
      label: 'Beaches & Coast',
      blurb: 'White sand, coral reefs and island life.',
      icon: Icons.beach_access_outlined,
    ),
    AttractionCategory(
      id: 'history',
      label: 'Ancient & Historic Sites',
      blurb: 'Pyramids, medinas, Stone Town and living history.',
      icon: Icons.account_balance_outlined,
    ),
    AttractionCategory(
      id: 'culture',
      label: 'Culture & Heritage',
      blurb: 'Maasai, Samburu, Berber and Swahili traditions.',
      icon: Icons.diversity_3_outlined,
    ),
    AttractionCategory(
      id: 'mountains',
      label: 'Mountains & Hiking',
      blurb: 'Kilimanjaro, Table Mountain, the Atlas and craters.',
      icon: Icons.terrain_outlined,
    ),
    AttractionCategory(
      id: 'desert',
      label: 'Deserts & Dunes',
      blurb: 'The Sahara, oases and Rift Valley drylands.',
      icon: Icons.grain,
    ),
    AttractionCategory(
      id: 'lakes-rivers',
      label: 'Lakes & Rivers',
      blurb: 'The Nile, flamingo lakes and the great rift waters.',
      icon: Icons.water_outlined,
    ),
    AttractionCategory(
      id: 'hot-springs',
      label: 'Hot Springs & Geothermal',
      blurb: 'Steaming geysers, spas and geothermal valleys.',
      icon: Icons.hot_tub_outlined,
    ),
    AttractionCategory(
      id: 'food-wine',
      label: 'Food & Wine',
      blurb: 'Winelands, spice markets and street-food trails.',
      icon: Icons.wine_bar_outlined,
    ),
    AttractionCategory(
      id: 'nganya',
      label: 'Nganya / Matatu Culture',
      blurb: "Nairobi's loud, art-covered matatu scene.",
      icon: Icons.directions_bus_filled_outlined,
    ),
  ];

  static AttractionCategory? byId(String id) {
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }
}
