import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/place.dart';
import '../utils/season.dart';

/// Reads the places catalogue from Supabase.
class PlaceService {
  final SupabaseClient _client = Supabase.instance.client;

  static const _select = '*, place_media(*)';

  /// Places that are at their best during [month] (1-12).
  /// Drives the "best places to visit right now" feature.
  Future<List<Place>> placesInMonth(int month) async {
    final rows = await _client
        .from('places')
        .select(_select)
        .contains('best_months', [month])
        .order('rating', ascending: false);
    return _map(rows);
  }

  /// Places that fit the chosen [season]. Because seasons fall in different
  /// months per hemisphere, we union the northern + southern month sets and
  /// match each place against the right window for its own hemisphere.
  Future<List<Place>> placesInSeason(Season season) async {
    // Fetch a superset (any place whose best months intersect either
    // hemisphere's window), then filter precisely in Dart by hemisphere.
    final months = {
      ...SeasonUtil.monthsFor(season, hemisphere: 'N'),
      ...SeasonUtil.monthsFor(season, hemisphere: 'S'),
    }.toList();

    final rows = await _client
        .from('places')
        .select(_select)
        .overlaps('best_months', months)
        .order('rating', ascending: false);

    return _map(rows).where((p) {
      final window = SeasonUtil.monthsFor(season, hemisphere: p.hemisphere);
      return p.bestMonths.any(window.contains);
    }).toList();
  }

  /// All places on a continent.
  Future<List<Place>> placesByContinent(String continent) async {
    final rows = await _client
        .from('places')
        .select(_select)
        .eq('continent', continent)
        .order('rating', ascending: false);
    return _map(rows);
  }

  /// Places that belong to an experience [category] (e.g. 'wildlife',
  /// 'coast'). Drives the "explore by experience" browse. Optionally scoped
  /// to a single [country] so it can be focused on Kenya for now.
  Future<List<Place>> placesByCategory(String category, {String? country}) async {
    var query =
        _client.from('places').select(_select).contains('categories', [category]);
    if (country != null) query = query.eq('country', country);
    final rows = await query.order('rating', ascending: false);
    return _map(rows);
  }

  /// Free-text search across name, country and tags.
  Future<List<Place>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final rows = await _client
        .from('places')
        .select(_select)
        .or('name.ilike.%$q%,country.ilike.%$q%')
        .order('rating', ascending: false);
    return _map(rows);
  }

  /// A single place with all its media.
  Future<Place> placeById(String id) async {
    final row =
        await _client.from('places').select(_select).eq('id', id).single();
    return Place.fromMap(row);
  }

  /// Distinct continents that actually have places (for the browse screen).
  Future<List<String>> continents() async {
    final rows = await _client.from('places').select('continent');
    final set = <String>{for (final r in rows) r['continent'].toString()};
    return set.toList()..sort();
  }

  List<Place> _map(List<dynamic> rows) =>
      rows.map((r) => Place.fromMap(r as Map<String, dynamic>)).toList();
}
