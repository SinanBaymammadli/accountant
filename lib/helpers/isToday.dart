bool isToday(DateTime date) {
  DateTime now = DateTime.now();

  return date.isAfter(DateTime(now.year, now.month, now.day, 0, 0, 0));
}
