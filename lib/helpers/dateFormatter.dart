import "package:intl/intl.dart";

final f = DateFormat('dd MMM, yyyy HH:mm');

String formatDate(DateTime date) {
  return f.format(date);
}
