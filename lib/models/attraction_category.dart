import 'package:flutter/material.dart';

/// An "experience" lens on Kenya's attractions. The [id] matches the values
/// stored in `places.categories`, so tapping a category filters the catalogue.
/// Categories are curated content, so they live in code, not the DB.
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

  static const List<AttractionCategory> all = [
    AttractionCategory(
      id: 'wildlife',
      label: 'Wildlife & Safari',
      blurb: 'The Mara migration, Big Five parks and conservancies.',
      icon: Icons.pets_outlined,
    ),
    AttractionCategory(
      id: 'coast',
      label: 'Coastal Life',
      blurb: 'White-sand beaches, reefs and the Swahili coast.',
      icon: Icons.beach_access_outlined,
    ),
    AttractionCategory(
      id: 'culture',
      label: 'Maasai & Samburu Culture',
      blurb: 'Living traditions, villages and heritage towns.',
      icon: Icons.diversity_3_outlined,
    ),
    AttractionCategory(
      id: 'nganya',
      label: 'Nganya / Matatu Culture',
      blurb: "Nairobi's loud, art-covered matatu scene.",
      icon: Icons.directions_bus_filled_outlined,
    ),
    AttractionCategory(
      id: 'hot-springs',
      label: 'Hot Springs & Geothermal',
      blurb: 'Steaming geysers, spas and Rift Valley geothermal.',
      icon: Icons.hot_tub_outlined,
    ),
    AttractionCategory(
      id: 'lakes-rivers',
      label: 'Lakes & Rivers',
      blurb: 'Flamingo lakes, the Jade Sea and great rivers.',
      icon: Icons.water_outlined,
    ),
    AttractionCategory(
      id: 'mountains',
      label: 'Mountains & Landscapes',
      blurb: 'Mount Kenya, craters, gorges and waterfalls.',
      icon: Icons.terrain_outlined,
    ),
  ];
}
