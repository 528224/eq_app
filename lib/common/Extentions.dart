// extension NullOrBlankStringParsing on String? {
//   bool isNullOrBlank() {
//     return this?.trim().isEmpty ?? true;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat/dash_chat.dart';
import 'package:intl/intl.dart';

int getDaysSince(Timestamp? timestamp) {
  if (timestamp == null) return 0;

  var fromDate = timestamp.toDate();
  final toDate = DateTime.now();
  return daysBetween(fromDate, toDate);
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

Timestamp? getTimestampFromString(String? dateString) {
  if (dateString == null) return null;
  var date = DateTime.parse(dateString);
  var timestamp = Timestamp.fromDate(date); //To TimeStamp
  return timestamp;
}

String? getStringFromTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return null;
  String dateString =
      DateFormat('dd MMM yy-hh:mm a').format(timestamp.toDate());
  // var dateString =
  //     DateFormat('dd MMM yy-hh:mm a').format(timestamp.toDate()).toString();
  return dateString;
}

String? getValidDateFormatStringFromTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return null;
  String dateString = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
  // var dateString =
  //     DateFormat('yyyy-MM-dd').format(timestamp.toDate()).toString();
  return dateString;
}
