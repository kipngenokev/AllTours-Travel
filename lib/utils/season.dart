/// Season helpers used by the "best places to visit right now / by season"
/// feature.
enum Season { spring, summer, autumn, winter }

extension SeasonLabel on Season {
  String get label {
    switch (this) {
      case Season.spring:
        return 'Spring';
      case Season.summer:
        return 'Summer';
      case Season.autumn:
        return 'Autumn';
      case Season.winter:
        return 'Winter';
    }
  }

  String get emoji {
    switch (this) {
      case Season.spring:
        return '🌸';
      case Season.summer:
        return '☀️';
      case Season.autumn:
        return '🍂';
      case Season.winter:
        return '❄️';
    }
  }

  /// The months that make up this season in the NORTHERN hemisphere.
  /// (Southern hemisphere is offset by 6 months — see [monthsFor].)
  List<int> get northernMonths {
    switch (this) {
      case Season.spring:
        return const [3, 4, 5];
      case Season.summer:
        return const [6, 7, 8];
      case Season.autumn:
        return const [9, 10, 11];
      case Season.winter:
        return const [12, 1, 2];
    }
  }
}

class SeasonUtil {
  /// Returns the months (1-12) belonging to [season] for the given
  /// [hemisphere] ('N' or 'S').
  static List<int> monthsFor(Season season, {String hemisphere = 'N'}) {
    if (hemisphere == 'N') return season.northernMonths;
    // Shift by 6 months for the southern hemisphere.
    return season.northernMonths.map((m) => ((m + 5) % 12) + 1).toList();
  }

  /// The current season for a given hemisphere, based on today's month.
  static Season currentSeason({String hemisphere = 'N', DateTime? now}) {
    final month = (now ?? DateTime.now()).month;
    for (final s in Season.values) {
      if (monthsFor(s, hemisphere: hemisphere).contains(month)) return s;
    }
    return Season.summer;
  }

  /// Friendly label for the current month, e.g. "May".
  static String monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[(month - 1).clamp(0, 11)];
  }
}
