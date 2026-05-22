/// A single gallery item (photo or video) attached to a place.
class PlaceMedia {
  final String id;
  final String type; // 'photo' | 'video'
  final String url;
  final String? caption;

  const PlaceMedia({
    required this.id,
    required this.type,
    required this.url,
    this.caption,
  });

  bool get isVideo => type == 'video';

  factory PlaceMedia.fromMap(Map<String, dynamic> m) => PlaceMedia(
        id: m['id'].toString(),
        type: (m['type'] ?? 'photo').toString(),
        url: (m['url'] ?? '').toString(),
        caption: m['caption']?.toString(),
      );
}

/// A tourable destination.
class Place {
  final String id;
  final String name;
  final String country;
  final String continent;
  final String? summary;
  final String? description;
  final String? guidelines;
  final List<int> bestMonths;
  final String hemisphere; // 'N' | 'S'
  final String? coverImageUrl;
  final String? videoUrl;
  final double? latitude;
  final double? longitude;
  final List<String> tags;
  final List<String> categories;
  final double rating;
  final List<PlaceMedia> media;

  const Place({
    required this.id,
    required this.name,
    required this.country,
    required this.continent,
    this.summary,
    this.description,
    this.guidelines,
    this.bestMonths = const [],
    this.hemisphere = 'N',
    this.coverImageUrl,
    this.videoUrl,
    this.latitude,
    this.longitude,
    this.tags = const [],
    this.categories = const [],
    this.rating = 4.5,
    this.media = const [],
  });

  factory Place.fromMap(Map<String, dynamic> m) {
    List<int> ints(dynamic v) =>
        (v as List?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList() ??
        const [];
    List<String> strs(dynamic v) =>
        (v as List?)?.map((e) => e.toString()).toList() ?? const [];

    return Place(
      id: m['id'].toString(),
      name: (m['name'] ?? '').toString(),
      country: (m['country'] ?? '').toString(),
      continent: (m['continent'] ?? '').toString(),
      summary: m['summary']?.toString(),
      description: m['description']?.toString(),
      guidelines: m['guidelines']?.toString(),
      bestMonths: ints(m['best_months']),
      hemisphere: (m['hemisphere'] ?? 'N').toString(),
      coverImageUrl: m['cover_image_url']?.toString(),
      videoUrl: m['video_url']?.toString(),
      latitude: (m['latitude'] as num?)?.toDouble(),
      longitude: (m['longitude'] as num?)?.toDouble(),
      tags: strs(m['tags']),
      categories: strs(m['categories']),
      rating: (m['rating'] as num?)?.toDouble() ?? 4.5,
      media: (m['place_media'] as List?)
              ?.map((e) => PlaceMedia.fromMap(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// All photos for the gallery (cover first, then attached photos).
  List<String> get galleryImages => [
        if (coverImageUrl != null && coverImageUrl!.isNotEmpty) coverImageUrl!,
        ...media.where((x) => !x.isVideo).map((x) => x.url),
      ];
}
