const List<String> _kanjiDigits = [
  '〇', '一', '二', '三', '四', '五', '六', '七', '八', '九',
];

String _numberToKanji(int n) {
  if (n == 0) return _kanjiDigits[0];
  if (n < 10) return _kanjiDigits[n];
  if (n < 20) return '十${n == 10 ? '' : _kanjiDigits[n - 10]}';
  final tens = n ~/ 10;
  final ones = n % 10;
  return '${_kanjiDigits[tens]}十${ones == 0 ? '' : _kanjiDigits[ones]}';
}

String formatKanjiTime(DateTime time) {
  final hour = _numberToKanji(time.hour);
  final minute = _numberToKanji(time.minute);
  return '$hour時$minute分';
}

String formatKanjiDate(DateTime date) {
  final month = _numberToKanji(date.month);
  final day = _numberToKanji(date.day);
  return '$month月$day日';
}
