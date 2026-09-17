import '../../../../core/utils/date_index_selector.dart';
import '../entities/daily_kanji_entry.dart';

DailyKanjiEntry selectKanjiForDate(List<DailyKanjiEntry> entries, DateTime date) {
  return entries[dailyIndexFor(date, entries.length)];
}
