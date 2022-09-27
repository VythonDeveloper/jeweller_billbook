import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/components.dart';

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 17,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.blue.shade700,
                          ),
                          border: InputBorder.none,
                          hintText: 'Search by name',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                'dataaa',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 15,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text('Create New Item'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text('A'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mangtika'),
                              Text('Stock: 100 gms'),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text('Add'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text('A'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mangtika'),
                              Text('Stock: 100 gms'),
                            ],
                          ),
                          Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.27,
                            child: Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  suffixText: 'GMS',
                                  suffixStyle: TextStyle(fontSize: 11),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          CustomFABButton(onPressed: () {}, icon: Icons.done, label: 'Done'),
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
