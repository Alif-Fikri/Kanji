import '../../../../core/utils/date_index_selector.dart';
import '../entities/quote_entry.dart';

QuoteEntry selectQuoteForDate(List<QuoteEntry> entries, DateTime date) {
  return entries[dailyIndexFor(date, entries.length)];
}
