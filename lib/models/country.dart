/// A destination country in the Africa explorer. Editorial content (hero
/// imagery, blurb) is curated, so it lives in code; the attractions
/// themselves come from Supabase, filtered by `country`.
class Country {
  final String name;
  final String tagline;
  final String blurb;

  /// picsum seed used for the hero image (swap for real photography later).
  final String imageSeed;

  const Country({
    required this.name,
    required this.tagline,
    required this.blurb,
    required this.imageSeed,
  });

  String get heroImageUrl => 'https://picsum.photos/seed/$imageSeed/1400/1000';

  /// Stable tag for the Hero shared-element transition card → detail.
  String get heroTag => 'country-$name';

  static const List<Country> all = [
    Country(
      name: 'Kenya',
      tagline: 'Safari, the Mara & the Swahili coast',
      blurb:
          'The heart of the safari world — the Maasai Mara migration, elephant '
          'herds beneath Kilimanjaro, flamingo lakes and white-sand Indian '
          'Ocean beaches, all within one country.',
      imageSeed: 'maasaimara',
    ),
    Country(
      name: 'Tanzania',
      tagline: 'Serengeti, Kilimanjaro & Zanzibar',
      blurb:
          'Endless Serengeti plains and the Great Migration, the Ngorongoro '
          'Crater, the roof of Africa on Kilimanjaro, and the spice islands and '
          'turquoise water of Zanzibar.',
      imageSeed: 'serengeti',
    ),
    Country(
      name: 'South Africa',
      tagline: 'Table Mountain, Kruger & the winelands',
      blurb:
          'A world in one country: Big Five game in Kruger, Cape Town beneath '
          'Table Mountain, the Cape Winelands, the Garden Route coast and a '
          'powerful living history.',
      imageSeed: 'capetown',
    ),
    Country(
      name: 'Egypt',
      tagline: 'Pyramids, the Nile & the Red Sea',
      blurb:
          'Five thousand years of wonders — the Pyramids of Giza, the temples '
          'of Luxor, a cruise down the Nile, desert oases and world-class '
          'diving in the Red Sea.',
      imageSeed: 'giza',
    ),
    Country(
      name: 'Rwanda',
      tagline: 'Mountain gorillas & a thousand hills',
      blurb:
          'The land of a thousand hills, famed for unforgettable mountain '
          'gorilla treks, chimpanzees in Nyungwe rainforest, the shores of '
          'Lake Kivu and a remarkably clean, welcoming capital.',
      imageSeed: 'rwanda',
    ),
    Country(
      name: 'Morocco',
      tagline: 'Medinas, the Sahara & the Atlas',
      blurb:
          'Where Africa meets the Mediterranean — the labyrinth medinas of '
          'Marrakech and Fes, Saharan dunes at Merzouga, the High Atlas '
          'mountains and the blue lanes of Chefchaouen.',
      imageSeed: 'morocco',
    ),
  ];

  static Country? byName(String name) {
    for (final c in all) {
      if (c.name == name) return c;
    }
    return null;
  }
}
