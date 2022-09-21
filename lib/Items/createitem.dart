import 'package:flutter/material.dart';

class CreateItemUi extends StatefulWidget {
  const CreateItemUi({Key? key}) : super(key: key);

  @override
  State<CreateItemUi> createState() => _CreateItemUiState();
}

class _CreateItemUiState extends State<CreateItemUi>
    with SingleTickerProviderStateMixin {
  bool _lowStockToggle = false;
  late TabController _tabController;
  List<String> unitList = ['KGMS', 'GMS', "PCS"];
  String _selectedUnit = "GMS";
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  String _selectedItemType = "Product";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Create New Item",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.deepPurple),
        ),
        body: Column(
          children: <Widget>[
            basicItemDetails(),
            otherDetailsTabBar(),
          ],
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Item Name',
                label: Text("Item Name"),
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
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
                  padding: EdgeInsets.all(11),
                  margin: EdgeInsets.all(10),
                  color: _selectedItemType == "Product"
                      ? Colors.green
                      : Color.fromARGB(255, 168, 206, 169),
                  child: Text("Product"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedItemType = "Service";
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(11),
                  margin: EdgeInsets.all(10),
                  color: _selectedItemType == "Service"
                      ? Colors.green
                      : Color.fromARGB(255, 168, 206, 169),
                  child: Text("Service"),
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
                tabs: [
                  Tab(
                    text: "Pricing",
                  ),
                  Tab(
                    text: "Stock",
                  ),
                  Tab(
                    text: "Other",
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                pricingTabBar(),
                stockTabBar(),
                otherTabBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pricingTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Unit"),
                DropdownButton<String>(
                  value: _selectedUnit,
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
                      _selectedUnit = value!;
                    });
                  },
                  items: unitList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
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

  Widget otherTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [Text("Unit")],
          )
        ],
      ),
    );
  }
}
