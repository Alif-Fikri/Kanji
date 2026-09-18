import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_widget/core/utils/date_index_selector.dart';

void main() {
  group('dailyIndexFor', () {
    test('returns the same index for the same calendar day', () {
      final morning = DateTime(2026, 9, 17, 6, 0);
      final night = DateTime(2026, 9, 17, 23, 59);
      expect(dailyIndexFor(morning, 50), dailyIndexFor(night, 50));
    });

    test('changes when the calendar day changes', () {
      final today = DateTime(2026, 9, 17);
      final tomorrow = DateTime(2026, 9, 18);
      expect(dailyIndexFor(today, 50), isNot(dailyIndexFor(tomorrow, 50)));
    });

    test('is always within bounds of the list length', () {
      for (var day = 1; day <= 31; day++) {
        final index = dailyIndexFor(DateTime(2026, 1, day), 7);
        expect(index, inInclusiveRange(0, 6));
      }
    });

    test('is stable across a local timezone-independent UTC day boundary', () {
      // Same calendar date, different local times of day (including one
      // that would cross a UTC day boundary in some timezones) must still
      // resolve to the same index because the function keys off Y/M/D only.
      final a = DateTime(2026, 9, 17, 0, 0, 1);
      final b = DateTime(2026, 9, 17, 23, 0);
      expect(dailyIndexFor(a, 100), dailyIndexFor(b, 100));
    });
  });

  group('dateKey', () {
    test('pads month and day to two digits', () {
      expect(dateKey(DateTime(2026, 3, 5)), '2026-03-05');
    });

    test('does not pad already double-digit values', () {
      expect(dateKey(DateTime(2026, 12, 25)), '2026-12-25');
    });
  });

  group('activeOverrideIndex', () {
    test('returns null when no override is set', () {
      final result = activeOverrideIndex(null, null, DateTime(2026, 9, 17));
      expect(result, isNull);
    });

    test('returns null when override date does not match today', () {
      final result = activeOverrideIndex(
        '2026-09-16',
        3,
        DateTime(2026, 9, 17),
      );
      expect(result, isNull);
    });

    test('returns the override index when the date matches today', () {
      final result = activeOverrideIndex(
        '2026-09-17',
        3,
        DateTime(2026, 9, 17),
      );
      expect(result, 3);
    });

    test('treats a missing index as no override even with a matching date', () {
      final result = activeOverrideIndex(
        '2026-09-17',
        null,
        DateTime(2026, 9, 17),
      );
      expect(result, isNull);
    });
  });
}
