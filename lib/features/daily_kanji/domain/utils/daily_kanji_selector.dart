import '../entities/daily_kanji_entry.dart';

DailyKanjiEntry selectKanjiForDate(List<DailyKanjiEntry> entries, DateTime date) {
  final epochDay = DateTime.utc(date.year, date.month, date.day)
      .difference(DateTime.utc(1970, 1, 1))
      .inDays;
  final index = epochDay % entries.length;
  return entries[index];
}
