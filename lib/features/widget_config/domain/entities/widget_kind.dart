enum WidgetKind { clock, dailyKanji, quote, calendar, countdown }

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
        WidgetKind.calendar => 'Japanese Calendar',
        WidgetKind.countdown => 'Countdown',
      };

  String get description => switch (this) {
        WidgetKind.clock => 'Time and date written in kanji numerals',
        WidgetKind.dailyKanji => 'A new kanji every day, with meaning and reading',
        WidgetKind.quote => 'A Japanese quote every day, with an English translation',
        WidgetKind.calendar => 'Reiwa era, weekday and traditional month name',
        WidgetKind.countdown => 'Days left until a date you choose',
      };

  bool get isAvailable =>
      this == WidgetKind.clock ||
      this == WidgetKind.dailyKanji ||
      this == WidgetKind.quote;

  String? get androidProvider => switch (this) {
        WidgetKind.clock =>
          'id.co.alchemist.kanjiwidget.KanjiClockWidgetProvider',
        WidgetKind.dailyKanji =>
          'id.co.alchemist.kanjiwidget.DailyKanjiWidgetProvider',
        WidgetKind.quote =>
          'id.co.alchemist.kanjiwidget.QuoteWidgetProvider',
        _ => null,
      };

  bool matchesAndroidClass(String? className) {
    final provider = androidProvider;
    if (provider == null || className == null) return false;
    return provider.split('.').last == className.split('.').last;
  }
}
