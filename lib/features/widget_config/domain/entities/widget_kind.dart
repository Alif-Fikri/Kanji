enum WidgetKind { clock, dailyKanji, calendar, countdown }

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
        WidgetKind.calendar => 'Japanese Calendar',
        WidgetKind.countdown => 'Countdown',
      };

  String get description => switch (this) {
        WidgetKind.clock => 'Time and date written in kanji numerals',
        WidgetKind.dailyKanji => 'A new kanji every day, with meaning and reading',
        WidgetKind.calendar => 'Reiwa era, weekday and traditional month name',
        WidgetKind.countdown => 'Days left until a date you choose',
      };

  bool get isAvailable =>
      this == WidgetKind.clock || this == WidgetKind.dailyKanji;

  String? get androidProvider => switch (this) {
        WidgetKind.clock =>
          'id.co.alchemist.kanjiwidget.KanjiClockWidgetProvider',
        WidgetKind.dailyKanji =>
          'id.co.alchemist.kanjiwidget.DailyKanjiWidgetProvider',
        _ => null,
      };

  bool matchesAndroidClass(String? className) {
    final provider = androidProvider;
    if (provider == null || className == null) return false;
    return provider.split('.').last == className.split('.').last;
  }
}
