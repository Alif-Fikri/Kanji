import '../entities/widget_config.dart';

const List<String> _kanjiDigits = [
  '〇',
  '一',
  '二',
  '三',
  '四',
  '五',
  '六',
  '七',
  '八',
  '九',
];

const List<String> _weekdayKanji = [
  '月',
  '火',
  '水',
  '木',
  '金',
  '土',
  '日',
];

String _numberToKanji(int n) {
  if (n == 0) return _kanjiDigits[0];
  if (n < 10) return _kanjiDigits[n];
  if (n < 20) return '十${n == 10 ? '' : _kanjiDigits[n - 10]}';
  final tens = n ~/ 10;
  final ones = n % 10;
  return '${_kanjiDigits[tens]}十${ones == 0 ? '' : _kanjiDigits[ones]}';
}

String _number(int n, NumeralStyle style) =>
    style == NumeralStyle.kanji ? _numberToKanji(n) : '$n';

String formatKanjiTime(
  DateTime time, {
  NumeralStyle style = NumeralStyle.kanji,
  bool use24HourFormat = true,
  bool showSeconds = false,
}) {
  final buffer = StringBuffer();
  var hour = time.hour;

  if (!use24HourFormat) {
    buffer.write(hour < 12 ? '午前' : '午後');
    hour = hour % 12;
    if (hour == 0) hour = 12;
  }

  buffer.write('${_number(hour, style)}時${_number(time.minute, style)}分');
  if (showSeconds) {
    buffer.write('${_number(time.second, style)}秒');
  }
  return buffer.toString();
}

String formatKanjiDate(
  DateTime date, {
  NumeralStyle style = NumeralStyle.kanji,
  bool showWeekday = false,
}) {
  final base = '${_number(date.month, style)}月${_number(date.day, style)}日';
  if (!showWeekday) return base;
  return '$base（${_weekdayKanji[date.weekday - 1]}）';
}
