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
}

// 14/24

// ₹

