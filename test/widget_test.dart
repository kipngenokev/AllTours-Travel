import 'package:flutter_test/flutter_test.dart';

import 'package:all_tours/utils/season.dart';

void main() {
  group('SeasonUtil', () {
    test('northern hemisphere June is summer', () {
      final s = SeasonUtil.currentSeason(
          hemisphere: 'N', now: DateTime(2026, 6, 15));
      expect(s, Season.summer);
    });

    test('southern hemisphere June is winter', () {
      final s = SeasonUtil.currentSeason(
          hemisphere: 'S', now: DateTime(2026, 6, 15));
      expect(s, Season.winter);
    });

    test('southern summer months are shifted by six', () {
      expect(SeasonUtil.monthsFor(Season.summer, hemisphere: 'S'),
          containsAll(<int>[12, 1, 2]));
    });
  });
}
