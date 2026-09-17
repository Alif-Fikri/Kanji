import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/entities/daily_kanji_entry.dart';

class DailyKanjiDataSource {
  static const String assetPath = 'assets/data/jlpt_n5_kanji.json';

  List<DailyKanjiEntry>? _cache;

  Future<List<DailyKanjiEntry>> load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString(assetPath);
    final list = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map(DailyKanjiEntry.fromJson)
        .toList();

    _cache = list;
    return list;
  }
}
