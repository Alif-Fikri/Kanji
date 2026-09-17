import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/entities/quote_entry.dart';

class QuoteDataSource {
  static const String assetPath = 'assets/data/japanese_quotes.json';

  List<QuoteEntry>? _cache;

  Future<List<QuoteEntry>> load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString(assetPath);
    final list = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map(QuoteEntry.fromJson)
        .toList();

    _cache = list;
    return list;
  }
}
