import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/colors.dart';

class MortgageBookUI extends StatefulWidget {
  final mrtgBook;
  const MortgageBookUI({super.key, this.mrtgBook});

  @override
  State<MortgageBookUI> createState() =>
      _MortgageBookUIState(mrtgBook: mrtgBook);
}

class _MortgageBookUIState extends State<MortgageBookUI> {
  final mrtgBook;
  _MortgageBookUIState({this.mrtgBook});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: primaryAccentColor,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Text(
                          mrtgBook['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          mrtgBook['phone'],
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryColor,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.call,
                          color: primaryAccentColor,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
