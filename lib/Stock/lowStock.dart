import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_billbook/Items/itemDetails.dart';
import 'package:jeweller_billbook/Services/user.dart';
import 'package:page_route_transition/page_route_transition.dart';

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.whatsapp_rounded,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
                  margin: EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(
                width: 30,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          itemsList(),
        ],
      ),
    );
  }

  Widget itemsList() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 12),
      child: FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(UserData.uid)
            .collection('items')
            .get(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var itemMap = snapshot.data.docs[index];
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
      ),
    );
  }

  Widget itemsCard({required var itemMap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 18,
            child: Text(itemMap['name'][0]),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemMap['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Left Weight:",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          itemMap['leftStockWeight'].toStringAsFixed(3) +
                              ' ' +
                              itemMap['unit'],
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Piece:",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          itemMap['leftStockPiece'].toString() + ' PCS',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              PageRouteTransition.push(
                      context, ItemDetailsUI(itemId: itemMap['id']))
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
    );
  }
}
