import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Mortage/createMrtgBook.dart';
import 'package:jeweller_stockbook/Mortage/MortgageBillUI.dart';
import 'package:jeweller_stockbook/Repository/mortgage_repo.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:jeweller_stockbook/utils/kScaffold.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Helper/sdp.dart';
import '../utils/components.dart';

class MortgageUI extends ConsumerStatefulWidget {
  const MortgageUI({Key? key}) : super(key: key);

  @override
  ConsumerState<MortgageUI> createState() => _MortgageUIState();
}

class _MortgageUIState extends ConsumerState<MortgageUI> {
  final _searchKey = TextEditingController();

  QuerySnapshot<Map<String, dynamic>>? initData;
  List _allResults = [];
  List _resultList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getBookList();
    _searchKey.addListener(_onSearchChanged);
  }

  _getBookList() async {
    await ref.read(mortgageBookFuture).whenData(
      (data) {
        setState(() {
          _allResults = data.docs;
        });
      },
    );

    _searchResultList();
  }

  _onSearchChanged() async {
    _searchResultList();
  }

  _searchResultList() {
    var showResults = [];
    if (_searchKey.text.isNotEmpty) {
      for (var snapshot in _allResults) {
        var name = snapshot['name'];
        if (kCompare(name, _searchKey.text)) {
          showResults.add(snapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  @override
  void dispose() {
    _searchKey.removeListener(_onSearchChanged);
    _searchKey.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _getBookList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mortgageBookData = ref.watch(mortgageBookFuture);

    if (_allResults.isEmpty) {
      ref.watch(mortgageBookFuture).whenData(
        (data) {
          setState(() {
            _allResults = data.docs;
          });
        },
      );
    }
    return RefreshIndicator(
      onRefresh: () => ref.refresh(mortgageBookFuture.future),
      child: KScaffold(
        isLoading: mortgageBookData.isLoading,
        loadingText: "Fetching Mortgage Books ...",
        appBar: AppBar(
          title: _searchBar(),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      mrtgBookList(),
                      kHeight(100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFABButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateMrtgBookUi()))
                .then(((value) {
              if (mounted) {
                setState(() {});
              }
            }));
          },
          icon: Icons.book,
          label: '+ Mortgage Book',
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextFieldTapRegion(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      child: CupertinoSearchTextField(
        controller: _searchKey,
        placeholder: 'Search name, phone etc',
        padding: EdgeInsets.all(10),
      ),
    );
  }

  Widget mrtgBookList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _resultList.length,
      itemBuilder: (context, index) {
        return mrtgBookCard(mrtgBookMap: _resultList[index]);
      },
    );
  }

  Widget mrtgBookCard({required var mrtgBookMap}) {
    return GestureDetector(
      onTap: () {
        navPush(context, MortgageBillUI(mrtgBook: mrtgBookMap))
            .then((value) => setState(() {}));
      },
      child: Container(
        color: Colors.grey.shade100,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mrtgBookMap['name'],
                      style: TextStyle(
                          fontSize: sdp(context, 12),
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5),
                    ),
                    Text(
                      mrtgBookMap['phone'],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: sdp(context, 10),
                          letterSpacing: .5),
                    ),
                  ],
                ),
                IconButton.filledTonal(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    Uri url = Uri.parse("tel:${mrtgBookMap['phone']}");
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    } else {
                      kSnackbar(context,
                          'Unable to place call to ${mrtgBookMap['name']}');
                    }
                  },
                  icon: Icon(
                    Icons.call,
                    size: sdp(context, 10),
                  ),
                ),
              ],
            ),
            height10,
            Row(
              children: [
                mrtgBookStatsCard(
                  label: 'Total Principle',
                  bookId: mrtgBookMap['id'],
                ),
                width5,
                mrtgBookStatsCard(
                  label: 'Total Interest',
                  bookId: mrtgBookMap['id'],
                ),
                width5,
                mrtgBookStatsCard(
                  label: 'Total Paid',
                  bookId: mrtgBookMap['id'],
                  totalPaid: mrtgBookMap['totalPaid'],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mrtgBookStatsCard({
    required int bookId,
    required String label,
    int? totalPaid,
  }) {
    return Expanded(
      child: Consumer(builder: (context, ref, child) {
        final bookStats = ref.watch(bookStatsFuture(bookId));
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: kColor(context).tertiaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: kColor(context).onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                  fontSize: sdp(context, 10),
                ),
                maxLines: 1,
              ),
              bookStats.when(
                data: (data) {
                  double showAmount = 0.0;
                  if (label == "Total Principle") {
                    // int totalPrinciple = 0;
                    var dataMap = data.docs;
                    for (int index = 0; index < data.docs.length; index++) {
                      showAmount +=
                          int.parse(dataMap[index]['amount'].toString());
                    }
                  } else if (label == "Total Interest") {
                    for (int i = 0; i < data.docs.length; i++) {
                      DocumentSnapshot txnMap = data.docs[i];
                      var _calculatedResult = Constants.calculateMortgage(
                        txnMap['weight'],
                        txnMap['purity'],
                        txnMap['amount'],
                        txnMap['interestPerMonth'],
                        txnMap['lastPaymentDate'],
                      );
                      showAmount += _calculatedResult['interestAmount'];
                    }
                  } else if (label == "Total Paid" && totalPaid != null) {
                    return Text(
                      "₹ " + Constants.cFDecimal.format(totalPaid),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: sdp(context, 10),
                      ),
                    );
                  }
                  return Text(
                    "₹ " + Constants.cFInt.format(showAmount),
                    style: TextStyle(
                      color: kColor(context).onTertiaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: sdp(context, 10),
                    ),
                  );
                },
                error: (error, stackTrace) => SizedBox(),
                loading: () => LinearProgressIndicator(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
