import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Items/itemDetails.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/kCard.dart';

import '../utils/components.dart';

class LowStockUI extends StatefulWidget {
  const LowStockUI({super.key});

  @override
  State<LowStockUI> createState() => _LowStockUIState();
}

class _LowStockUIState extends State<LowStockUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Low Stock'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // showModalBottomSheet<void>(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return StatefulBuilder(builder: (BuildContext context,
                //           StateSetter setModalState /*You can rename this!*/) {
                //         return selectCategoryModal(setModalState);
                //       });
                //     });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All Catagories',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
            height20,
            itemsList(),
          ],
        ),
      ),
    );
  }

  Widget itemsList() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(UserData.uid)
          .collection('items')
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var itemMap = snapshot.data!.docs[index].data();
                if (itemMap['leftStockPiece'] < itemMap['lowStockPiece'] ||
                    itemMap['leftStockWeight'] < itemMap['lowStockWeight']) {
                  return itemsCard(itemMap: itemMap);
                }
                return SizedBox();
              },
            );
          }
          return Center(
            child: Text(
              "No Low Stock Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          );
        }
        return LinearProgressIndicator(
          minHeight: 3,
        );
      }),
    );
  }

  Widget itemsCard({required var itemMap}) {
    return KCard(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 20),
      color: kColor(context).surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: kColor(context).primaryContainer,
            radius: 22,
            child: FittedBox(child: Text(itemMap['name'][0])),
          ),
          width20,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        itemMap['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    width10,
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        navPush(context, ItemDetailsUI(itemId: itemMap['id']))
                            .then((value) => setState(() {}));
                      },
                      icon: Icon(
                        Icons.tune,
                        size: 17,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Weight",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${double.parse("${itemMap['leftStockWeight']}").toStringAsFixed(3)} ${itemMap['unit']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    width20,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pieces",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "${itemMap['leftStockPiece']} Pcs",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
