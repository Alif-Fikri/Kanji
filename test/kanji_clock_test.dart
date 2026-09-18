import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_widget/features/widget_config/domain/entities/widget_config.dart';
import 'package:kanji_widget/features/widget_config/domain/utils/kanji_clock.dart';

void main() {
  group('formatKanjiTime', () {
    test('formats midnight as 〇時〇分', () {
      final time = DateTime(2026, 1, 1, 0, 0);
      expect(formatKanjiTime(time), '〇時〇分');
    });

    test('formats single-digit hour and minute', () {
      final time = DateTime(2026, 1, 1, 3, 5);
      expect(formatKanjiTime(time), '三時五分');
    });

    test('formats teen numbers with 十 prefix, no leading digit', () {
      final time = DateTime(2026, 1, 1, 10, 15);
      expect(formatKanjiTime(time), '十時十五分');
    });

    test('formats 11 correctly (十一, not 一十一)', () {
      final time = DateTime(2026, 1, 1, 11, 19);
      expect(formatKanjiTime(time), '十一時十九分');
    });

    test('formats tens without trailing zero digit (e.g. 20 -> 二十)', () {
      final time = DateTime(2026, 1, 1, 20, 0);
      expect(formatKanjiTime(time), '二十時〇分');
    });

    test('formats compound tens (e.g. 23 -> 二十三)', () {
      final time = DateTime(2026, 1, 1, 23, 45);
      expect(formatKanjiTime(time), '二十三時四十五分');
    });

    test('formats 59 minutes correctly', () {
      final time = DateTime(2026, 1, 1, 12, 59);
      expect(formatKanjiTime(time), '十二時五十九分');
    });

    test('uses arabic numerals when requested', () {
      final time = DateTime(2026, 1, 1, 14, 5);
      expect(
        formatKanjiTime(time, style: NumeralStyle.arabic),
        '14時5分',
      );
    });

    test('appends seconds when requested', () {
      final time = DateTime(2026, 1, 1, 9, 8, 7);
      expect(
        formatKanjiTime(time, showSeconds: true),
        '九時八分七秒',
      );
    });

    group('12-hour format', () {
      test('midnight is 午前十二時', () {
        final time = DateTime(2026, 1, 1, 0, 30);
        expect(
          formatKanjiTime(time, use24HourFormat: false),
          '午前十二時三十分',
        );
      });

      test('noon is 午後十二時', () {
        final time = DateTime(2026, 1, 1, 12, 0);
        expect(
          formatKanjiTime(time, use24HourFormat: false),
          '午後十二時〇分',
        );
      });

      test('morning hour uses 午前', () {
        final time = DateTime(2026, 1, 1, 9, 15);
        expect(
          formatKanjiTime(time, use24HourFormat: false),
          '午前九時十五分',
        );
      });

      test('afternoon hour uses 午後 and wraps to 12-hour', () {
        final time = DateTime(2026, 1, 1, 23, 45);
        expect(
          formatKanjiTime(time, use24HourFormat: false),
          '午後十一時四十五分',
        );
      });

      test('13:00 is 午後一時, not 午後十三時', () {
        final time = DateTime(2026, 1, 1, 13, 0);
        expect(
          formatKanjiTime(time, use24HourFormat: false),
          '午後一時〇分',
        );
      });
    });
  });

  group('formatKanjiDate', () {
    test('formats single-digit month and day', () {
      final date = DateTime(2026, 3, 5);
      expect(formatKanjiDate(date), '三月五日');
    });

    test('formats double-digit month and day', () {
      final date = DateTime(2026, 12, 25);
      expect(formatKanjiDate(date), '十二月二十五日');
    });

    test('uses arabic numerals when requested', () {
      final date = DateTime(2026, 9, 17);
      expect(
        formatKanjiDate(date, style: NumeralStyle.arabic),
        '9月17日',
      );
    });

    test('appends weekday in parentheses when requested', () {
      // 2026-09-17 is a Thursday.
      final date = DateTime(2026, 9, 17);
      expect(
        formatKanjiDate(date, showWeekday: true),
        '九月十七日（木）',
      );
    });

    test('does not append weekday by default', () {
      final date = DateTime(2026, 9, 17);
      expect(formatKanjiDate(date), '九月十七日');
    });

    test('maps each weekday to the correct kanji', () {
      // 2026-09-14 is a Monday; walk through the full week.
      const expected = ['月', '火', '水', '木', '金', '土', '日'];
      for (var i = 0; i < 7; i++) {
        final date = DateTime(2026, 9, 14 + i);
        final result = formatKanjiDate(date, showWeekday: true);
        expect(result, endsWith('（${expected[i]}）'));
      }
    });
  });
}
