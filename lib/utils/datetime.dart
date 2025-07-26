import 'package:intl/intl.dart';

class DateTimeUtil {
  static Map<String, String> getFormattedNow() {
    final now = DateTime.now();
    const locale = 'id_ID';
    return {
      'time': DateFormat('HH:mm', locale).format(now),
      'day': DateFormat('EEEE', locale).format(now),
      'date': DateFormat('d MMMM yyyy', locale).format(now),
    };
  }
}
