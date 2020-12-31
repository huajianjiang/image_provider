
import 'package:intl/intl.dart';

String formatDateTime(String utcDateTime) {
  String localDateDisplay = "--";
  if (utcDateTime != null) {
    localDateDisplay = DateFormat('yyyy-MM-dd').format(DateTime.parse(utcDateTime));
  }
  return localDateDisplay;
}


