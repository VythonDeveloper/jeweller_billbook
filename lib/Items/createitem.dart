import 'package:flutter/material.dart';

class CreateItemUi extends StatefulWidget {
  const CreateItemUi({Key? key}) : super(key: key);

  @override
  State<CreateItemUi> createState() => _CreateItemUiState();
}

class _CreateItemUiState extends State<CreateItemUi> {
  List<String> categoryList = ['No Category', 'Gold', 'Silver'];
  String _selectedCategory = "No Category";
  bool _lowStockToggle = false;

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Category"),
              DropdownButton<String>(
                value: _selectedCategory,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                items:
                    categoryList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Unit"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
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
                      child: Text(
                        'All Catagories',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget stockTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Opening Stock",
                      suffixText: "GMS",
                      label: Text("GMS"),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "As of Date",
                      label: Text("As of Date"),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.amber,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Low stock alert"),
                Transform.scale(
                  scale: 1.1,
                  child: Switch(
                    onChanged: (value) {},
                    value: _lowStockToggle,
                    activeColor: Colors.blue.shade800,
                    activeTrackColor: Colors.blue.shade100,
                    inactiveThumbColor: Colors.redAccent,
                    inactiveTrackColor: Colors.red.shade100,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Item Code",
                label: Text("Item Code"),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
          ),
        ],
      ),
    );
  }
}
