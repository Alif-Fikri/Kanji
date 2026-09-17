import '../domain/entities/daily_kanji_entry.dart';
import '../domain/utils/daily_kanji_selector.dart';
import 'daily_kanji_data_source.dart';

class DailyKanjiCache {
  static List<DailyKanjiEntry>? _entries;
  static Future<List<DailyKanjiEntry>>? _pending;

  static List<DailyKanjiEntry>? get entries => _entries;

  static Future<void> warm() async {
    if (_entries != null) return;
    _pending ??= DailyKanjiDataSource().load();
    _entries = await _pending;
  }

  static DailyKanjiEntry? entryFor(DateTime date) {
    final loaded = _entries;
    if (loaded == null || loaded.isEmpty) return null;
    return selectKanjiForDate(loaded, date);
  }
}
