import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateItemUi extends StatefulWidget {
  const CreateItemUi({Key? key}) : super(key: key);

  @override
  State<CreateItemUi> createState() => _CreateItemUiState();
}

class _CreateItemUiState extends State<CreateItemUi> {
  List<String> categoryList = ['No Category', 'Gold', 'Silver'];
  String _selectedCategory = "No Category";
  final ValueNotifier<bool> _lowStockToggle = ValueNotifier<bool>(false);

  String _selectedItemType = "Product";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create New Item",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              basicItemDetails(),
              SizedBox(
                height: 10,
              ),
              otherDetailsTabBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget basicItemDetails() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(),
              label: Text("Item Name"),
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(),
              label: Text("Item Code"),
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.characters,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text("Item Type"),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedItemType = "Product";
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _selectedItemType == "Product"
                        ? Colors.indigo
                        : Color.fromARGB(255, 220, 226, 255),
                  ),
                  child: Text(
                    "Product",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _selectedItemType == "Product"
                          ? Colors.white
                          : Colors.indigo,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedItemType = "Service";
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _selectedItemType == "Service"
                        ? Colors.indigo
                        : Color.fromARGB(255, 220, 226, 255),
                  ),
                  child: Text(
                    "Service",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _selectedItemType == "Service"
                          ? Colors.white
                          : Colors.indigo,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget otherDetailsTabBar() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: AppBar(
              bottom: TabBar(
                automaticIndicatorColorAdjustment: true,
                indicatorWeight: 2,
                indicatorColor: Colors.indigo,
                tabs: [
                  Tab(
                    child: Text(
                      "Category",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Stock",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                categoryTabBar(),
                stockTabBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryTabBar() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Category"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isDense: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 17,
                  ),
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  underline: Container(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  items: categoryList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          'GMS',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Unit"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  value: _selectedCategory,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 17,
                  ),
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  underline: Container(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  items: categoryList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          'GMS',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget stockTabBar() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixText: "GMS",
                    label: Text("Opening Stock"),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    label: Text("As of Date"),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _lowStockToggle.value = !_lowStockToggle.value;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: _lowStockToggle.value
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )
                    : BorderRadius.circular(10),
                color: _lowStockToggle.value
                    ? Color.fromARGB(255, 230, 233, 253)
                    : Colors.grey.shade100,
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Low Stock Alert",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: _lowStockToggle.value
                          ? Colors.indigo.shade700
                          : Colors.black,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.1,
                    child: Switch(
                      onChanged: (value) {
                        setState(() {
                          _lowStockToggle.value = !_lowStockToggle.value;
                        });
                      },
                      value: _lowStockToggle.value,
                      activeColor: Colors.indigoAccent,
                      activeTrackColor: Colors.indigo.shade100,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 100),
            child: ValueListenableBuilder<bool>(
              valueListenable: _lowStockToggle,
              builder: ((context, lowStockToggle, child) {
                return lowStockToggle
                    ? Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 237, 240, 255),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Low Stock Quantity',
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        suffixText: "GMS",
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'You will be notified when stock goes below 0 GMS',
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
