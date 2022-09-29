import 'package:intl/intl.dart';

class Constants {
  static String dateFormat(millisecond) {
    var dt = DateTime.fromMillisecondsSinceEpoch(millisecond);
    var date = DateFormat('dd MMM, yyyy').format(dt);
    return date;
  }

  static List<String> unitList = ['GMS', 'KGMS', 'PCS'];
  static double gold18KDecimal = 0.85;
  static double gold22KDecimal = 0.955;
  static Map<String, dynamic> purityMap = {
    "14K": 14 / 24,
    "18K": 18 / 24,
    "22K": 22 / 24
  };
  static List<String> purity = ['14K', '18K', '22K'];

  static String timeAgo(int millisec) {
    final timeDiff = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(millisec));

    if (timeDiff.inDays != 0) {
      return 'updated ' + timeDiff.inDays.toString() + ' days ago';
    }
    if (timeDiff.inHours != 0) {
      return 'updated ' + timeDiff.inHours.toString() + ' hours ago';
    }
    if (timeDiff.inMinutes != 0) {
      return 'updated ' + timeDiff.inMinutes.toString() + ' minutes ago';
    }
    return 'updated ' + timeDiff.inSeconds.toString() + ' seconds ago';
  }
}

// 14/24

// ₹



