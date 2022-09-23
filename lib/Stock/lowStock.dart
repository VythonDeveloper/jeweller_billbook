import 'package:flutter/material.dart';

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
      child: Column(
        children: List.generate(
            3,
            (index) => itemsCard(
                itemName: "Gold Ring", leftStock: 17.0, salePrice: 2570.3)),
      ),
    );
  }

  Widget itemsCard(
      {required String itemName,
      required double leftStock,
      required double salePrice}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 18,
            child: Text("F"),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Item Name",
                ),
                Text(
                  itemName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Stock",
                  ),
                  Text(
                    "100 GMS",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
