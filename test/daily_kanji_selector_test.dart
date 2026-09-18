import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_widget/features/daily_kanji/domain/entities/daily_kanji_entry.dart';
import 'package:kanji_widget/features/daily_kanji/domain/utils/daily_kanji_selector.dart';

void main() {
  const entries = [
    DailyKanjiEntry(kanji: '日', onyomi: 'ニチ', kunyomi: 'ひ', meaning: 'day'),
    DailyKanjiEntry(kanji: '一', onyomi: 'イチ', kunyomi: 'ひと', meaning: 'one'),
    DailyKanjiEntry(kanji: '国', onyomi: 'コク', kunyomi: 'くに', meaning: 'country'),
  ];

  test('returns an entry from the list, not a copy or default', () {
    final result = selectKanjiForDate(entries, DateTime(2026, 9, 17));
    expect(entries, contains(result));
  });

  test('returns the same entry for every time on the same day', () {
    final a = selectKanjiForDate(entries, DateTime(2026, 9, 17, 0, 1));
    final b = selectKanjiForDate(entries, DateTime(2026, 9, 17, 23, 58));
    expect(a, b);
  });

  test('cycles back to the start once the list is exhausted', () {
    // With a 3-entry list, selections 3 days apart must land on the same
    // entry again, since dailyIndexFor wraps with `% entries.length`.
    final first = selectKanjiForDate(entries, DateTime(2026, 1, 1));
    final wrapped = selectKanjiForDate(entries, DateTime(2026, 1, 4));
    expect(first, wrapped);
  });

  test('fromJson parses all fields', () {
    final entry = DailyKanjiEntry.fromJson({
      'kanji': '水',
      'onyomi': 'スイ',
      'kunyomi': 'みず',
      'meaning': 'water',
    });
    expect(entry.kanji, '水');
    expect(entry.onyomi, 'スイ');
    expect(entry.kunyomi, 'みず');
    expect(entry.meaning, 'water');
  });
}
