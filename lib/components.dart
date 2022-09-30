import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Mortage/mortgageDetails.dart';
import 'package:page_route_transition/page_route_transition.dart';

import 'colors.dart';
import 'constants.dart';

showLoading(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(child: alert, onWillPop: () async => false);
    },
  );
}

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    backgroundColor: Colors.blueGrey,
  ));
}

Widget CustomFABButton({final onPressed, heroTag, icon, label}) {
  return FloatingActionButton.extended(
    onPressed: onPressed,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    heroTag: heroTag,
    icon: Icon(icon),
    label: Text(label),
  );
}

Widget mortgageCard({required var txnMap, required var context}) {
  var _calculatedResult = Constants.calculateMortgage(
      txnMap['weight'],
      txnMap['purity'],
      txnMap['amount'],
      txnMap['interestPerMonth'],
      txnMap['date']);
  return GestureDetector(
    onTap: () {
      PageRouteTransition.push(
          context, MortgageDetailsUi(mortgageId: txnMap['id']));
    },
    child: Container(
      color: Colors.grey.shade100,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mortgage",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.purple,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "${txnMap['shopName']}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Constants.dateFormat(txnMap['date']),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      decoration: BoxDecoration(
                        color: txnMap['status'] == 'Active'
                            ? Colors.blue.shade700
                            : Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        txnMap['status'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'default',
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      "Total Due",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "₹ " + Constants.cFDecimal.format(txnMap['amount']),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _calculatedResult['profitLoss'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _calculatedResult['profitLoss'] == "Profit"
                            ? profitColor
                            : lossColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Valuation",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "₹ " +
                          Constants.cFDecimal
                              .format(_calculatedResult['valuation']),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
