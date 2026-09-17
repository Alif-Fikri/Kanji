import 'package:flutter/material.dart';

import '../../../daily_kanji/presentation/widgets/daily_kanji_face.dart';
import '../../../daily_quote/presentation/widgets/quote_face.dart';
import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_kind.dart';
import 'kanji_clock_face.dart';

Widget buildWidgetFace({
  required WidgetKind kind,
  required WidgetConfig config,
  required DateTime now,
}) {
  return switch (kind) {
    WidgetKind.clock => KanjiClockFace(config: config, now: now),
    WidgetKind.dailyKanji => DailyKanjiFace(config: config, now: now),
    WidgetKind.quote => QuoteFace(config: config, now: now),
  };
}
