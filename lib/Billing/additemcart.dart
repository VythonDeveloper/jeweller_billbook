import 'package:flutter/material.dart';

class AddItemCartUi extends StatefulWidget {
  const AddItemCartUi({Key? key}) : super(key: key);

  @override
  State<AddItemCartUi> createState() => _AddItemCartUiState();
}

class _AddItemCartUiState extends State<AddItemCartUi> {
  List<String> categoryList = ['All', 'Gold', 'Silver'];
  String _selectedCategory = "Gold";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Container(
          child: Row(
            children: [
              Icon(Icons.search),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search by name or code"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          addItemSortingBar(),
          addItemCart(),
          Spacer(),
          bottomDetails(),
        ],
      ),
    );
  }

  Widget addItemSortingBar() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
            items: categoryList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          MaterialButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: Colors.grey,
              child: Row(
                children: [
                  Icon(Icons.add),
                  Text("Create Item"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addItemCart() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: List.generate(5, (index) => itemCard()),
      ),
    );
  }

  Widget itemCard() {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: CircleAvatar()),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gold Ring Ladies"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("STOCK: 7.85GMS"),
                    MaterialButton(
                      onPressed: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.red,
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text("ADD"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomDetails() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        child: Icon(
                          Icons.arrow_upward,
                          size: 15,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("1 item(s)"),
                    ],
                  ),
                  Text("₹ 120.0"),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Row(
                children: [
                  Spacer(),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      color: Colors.purple,
                      child: Center(child: Text("Generate Bill")),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
