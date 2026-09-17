int dailyIndexFor(DateTime date, int length) {
  final epochDay = DateTime.utc(date.year, date.month, date.day)
      .difference(DateTime.utc(1970, 1, 1))
      .inDays;
  return epochDay % length;
}

int? activeOverrideIndex(String? overrideDate, int? overrideIndex, DateTime now) {
  if (overrideDate == null || overrideIndex == null) return null;
  return overrideDate == dateKey(now) ? overrideIndex : null;
}

String dateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
