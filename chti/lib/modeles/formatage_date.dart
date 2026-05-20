import 'package:intl/intl.dart';

class FormatageDate {
  String formatted(int timestamp) {
    DateTime postTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    DateFormat format;
    
    if (now.difference(postTime).inDays > 0) {
      format = DateFormat.yMMMd();
    } else {
      format = DateFormat.Hm(); // Format Heure:Minute standard
    }
    return format.format(postTime).toString();
  }
}