import 'package:equatable/equatable.dart';

class DailyKanjiEntry extends Equatable {
  final String kanji;
  final String onyomi;
  final String kunyomi;
  final String meaning;

  const DailyKanjiEntry({
    required this.kanji,
    required this.onyomi,
    required this.kunyomi,
    required this.meaning,
  });

  factory DailyKanjiEntry.fromJson(Map<String, dynamic> json) {
    return DailyKanjiEntry(
      kanji: json['kanji'] as String,
      onyomi: json['onyomi'] as String,
      kunyomi: json['kunyomi'] as String,
      meaning: json['meaning'] as String,
    );
  }

  @override
  List<Object?> get props => [kanji, onyomi, kunyomi, meaning];
}
