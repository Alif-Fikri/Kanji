int dailyIndexFor(DateTime date, int length) {
  final epochDay = DateTime.utc(date.year, date.month, date.day)
      .difference(DateTime.utc(1970, 1, 1))
      .inDays;
  return epochDay % length;
}
