import 'package:flutter_contacts/contact.dart';
import 'package:intl/intl.dart';
import 'package:jeweller_stockbook/Helper/user.dart';

class Constants {
  static String shopName = 'Arya Gold & Jewellery';
  static const String kAppVersion = "2.4.3";
  // static String uid = 'eEa9Z0PupqNulh4k9VxyiaUkZDw2';

  static String dateFormat(millisecond) {
    var dt = DateTime.fromMillisecondsSinceEpoch(millisecond);
    var date = DateFormat('dd MMM, yyyy').format(dt);
    return date;
  }

  static String dateTimeFormat(millisecond) {
    var dt = DateTime.fromMillisecondsSinceEpoch(millisecond);
    var date = DateFormat('dd MMM, yyyy hh:mm a').format(dt);
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

    if (timeDiff.inDays >= 365) {
      final years = (timeDiff.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    if (timeDiff.inDays >= 30) {
      final months = (timeDiff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'}';
    }
    if (timeDiff.inDays >= 7) {
      final weeks = (timeDiff.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'}';
    }
    if (timeDiff.inDays != 0) {
      return '${timeDiff.inDays} ${timeDiff.inDays == 1 ? 'day' : 'days'}';
    }
    if (timeDiff.inHours != 0) {
      return '${timeDiff.inHours} ${timeDiff.inHours == 1 ? 'hour' : 'hours'}';
    }
    if (timeDiff.inMinutes != 0) {
      return '${timeDiff.inMinutes} ${timeDiff.inMinutes == 1 ? 'minute' : 'minutes'}';
    }
    return '${timeDiff.inSeconds} ${timeDiff.inSeconds == 1 ? 'second' : 'seconds'}';
  }

  static Map<String, dynamic> calculateMortgage(
      double weightValue,
      String purity,
      int amountValue,
      double interestPerMonth,
      int dateMillisecond) {
    double purityValue =
        double.parse(Constants.purityMap[purity].toStringAsFixed(3));
    double interestValue = interestPerMonth / 100;

    var dt = DateTime.fromMillisecondsSinceEpoch(dateMillisecond);

    int _daysSince = DateTime.now().difference(dt).inDays;
    double _interestAmount = ((amountValue * interestValue) / 30) * _daysSince;
    double _totalDue = _interestAmount + amountValue;

    double _valuation = UserData.goldRate * weightValue * purityValue;
    String _profit_loss = "Loss";
    if (_valuation > _totalDue) {
      _profit_loss = "Profit";
    }

    Map<String, dynamic> _calculatedResult = {
      "daysSince": _daysSince,
      "interestAmount": _interestAmount,
      "totalDue": _totalDue,
      "valuation": _valuation,
      "profitLoss": _profit_loss
    };

    return _calculatedResult;
  }

  static var cFInt = NumberFormat('#,##,###');
  static var cFDecimal = NumberFormat('#,##,###.0#');

  static List<Contact> myContacts = [];
}

// 14/24

// ₹

bool kCompare(String text, String searchKey) {
  return text.trim().toLowerCase().contains(searchKey.trim().toLowerCase());
}
