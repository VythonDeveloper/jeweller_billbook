import 'package:flutter/material.dart';

class ItemCategoryUi extends StatefulWidget {
  const ItemCategoryUi({Key? key}) : super(key: key);

  @override
  State<ItemCategoryUi> createState() => _ItemCategoryUiState();
}

class _ItemCategoryUiState extends State<ItemCategoryUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Text(
          "Item Categories",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          categories(),
          ItemCategoryFloatingButtons(),
        ],
      ),
    );
  }

  Widget categories() {
    return Column(
      children: List.generate(
        5,
        (index) => categoryCard(),
      ),
    );
  }

  Widget categoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gold"),
                  Text("3 item(s)"),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.delete,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }

  Widget ItemCategoryFloatingButtons() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.black,
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Create Category',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (BuildContext context,
                            StateSetter
                                setModalState /*You can rename this!*/) {
                          return createCategoryModal(setModalState);
                        });
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createCategoryModal(StateSetter setModalState) {
    return Container(
      // height: 200,
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Create Item category'),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close),
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text("Category Name"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: Gold, Silver',
              ),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          Center(
            child: MaterialButton(
              onPressed: () {},
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  color: Colors.purple,
                  width: double.infinity,
                  child: Center(child: Text("Create"))),
            ),
          )
        ],
      ),
    );
  }
}
