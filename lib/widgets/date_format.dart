import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}