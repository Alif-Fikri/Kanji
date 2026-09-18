import 'package:flutter_test/flutter_test.dart';
import 'package:kanji_widget/features/daily_quote/domain/entities/quote_entry.dart';
import 'package:kanji_widget/features/daily_quote/domain/utils/quote_selector.dart';

void main() {
  const entries = [
    QuoteEntry(japanese: '七転び八起き', english: 'Fall seven times, rise eight.'),
    QuoteEntry(japanese: '一期一会', english: 'One encounter, one chance.'),
  ];

  test('returns an entry from the list', () {
    final result = selectQuoteForDate(entries, DateTime(2026, 9, 17));
    expect(entries, contains(result));
  });

  test('returns the same entry for every time on the same day', () {
    final a = selectQuoteForDate(entries, DateTime(2026, 9, 17, 6));
    final b = selectQuoteForDate(entries, DateTime(2026, 9, 17, 22));
    expect(a, b);
  });

  test('fromJson parses both fields', () {
    final entry = QuoteEntry.fromJson({
      'japanese': '継続は力なり',
      'english': 'Continuity is power.',
    });
    expect(entry.japanese, '継続は力なり');
    expect(entry.english, 'Continuity is power.');
  });
}
