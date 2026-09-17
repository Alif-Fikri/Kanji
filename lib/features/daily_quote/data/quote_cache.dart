import '../domain/entities/quote_entry.dart';
import '../domain/utils/quote_selector.dart';
import 'quote_data_source.dart';

class QuoteCache {
  static List<QuoteEntry>? _entries;
  static Future<List<QuoteEntry>>? _pending;

  static List<QuoteEntry>? get entries => _entries;

  static Future<void> warm() async {
    if (_entries != null) return;
    _pending ??= QuoteDataSource().load();
    _entries = await _pending;
  }

  static QuoteEntry? entryFor(DateTime date, {int? overrideIndex}) {
    final loaded = _entries;
    if (loaded == null || loaded.isEmpty) return null;
    if (overrideIndex != null && overrideIndex >= 0 && overrideIndex < loaded.length) {
      return loaded[overrideIndex];
    }
    return selectQuoteForDate(loaded, date);
  }
}
