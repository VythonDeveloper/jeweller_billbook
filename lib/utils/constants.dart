import 'package:flutter_contacts/contact.dart';
import 'package:intl/intl.dart';
import 'package:jeweller_stockbook/Helper/user.dart';

class Constants {
  static String shopName = 'Arya Gold & Jewellery';
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

    if (timeDiff.inDays != 0) {
      return 'Updated ' + timeDiff.inDays.toString() + ' days ago';
    }
    if (timeDiff.inHours != 0) {
      return 'Updated ' + timeDiff.inHours.toString() + ' hours ago';
    }
    if (timeDiff.inMinutes != 0) {
      return 'Updated ' + timeDiff.inMinutes.toString() + ' minutes ago';
    }
    return 'Updated ' + timeDiff.inSeconds.toString() + ' seconds ago';
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

bool kCompare(String text1, String text2) {
  return text1.trim().toLowerCase().contains(text2.trim().toLowerCase());
}
