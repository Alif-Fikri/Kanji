enum WidgetKind { clock, dailyKanji, quote }

WidgetKind? widgetKindFromName(String? name) {
  for (final kind in WidgetKind.values) {
    if (kind.name == name) return kind;
  }
  return null;
}

extension WidgetKindInfo on WidgetKind {
  String get title => switch (this) {
        WidgetKind.clock => 'Kanji Clock',
        WidgetKind.dailyKanji => 'Daily Kanji',
        WidgetKind.quote => 'Daily Quote',
      };

  String get description => switch (this) {
        WidgetKind.clock => 'Time and date written in kanji numerals',
        WidgetKind.dailyKanji => 'A new kanji every day, with meaning and reading',
        WidgetKind.quote => 'A Japanese quote every day, with an English translation',
      };

  String get androidProvider => switch (this) {
        WidgetKind.clock =>
          'id.co.alchemist.kanjiwidget.KanjiClockWidgetProvider',
        WidgetKind.dailyKanji =>
          'id.co.alchemist.kanjiwidget.DailyKanjiWidgetProvider',
        WidgetKind.quote =>
          'id.co.alchemist.kanjiwidget.QuoteWidgetProvider',
      };

  bool matchesAndroidClass(String? className) {
    if (className == null) return false;
    return androidProvider.split('.').last == className.split('.').last;
  }
}
