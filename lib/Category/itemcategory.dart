import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_billbook/components.dart';
import 'package:page_route_transition/page_route_transition.dart';

class ItemCategoryUi extends StatefulWidget {
  const ItemCategoryUi({Key? key}) : super(key: key);

  @override
  State<ItemCategoryUi> createState() => _ItemCategoryUiState();
}

class _ItemCategoryUiState extends State<ItemCategoryUi> {
  final _formKey = GlobalKey<FormState>();
  final _categoryName = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _categoryName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (BuildContext context,
                    StateSetter setModalState /*You can rename this!*/) {
                  return createCategoryModal(setModalState);
                });
              });
        },
        elevation: 2,
        icon: Icon(Icons.add),
        label: Text('Create Category'),
      ),
    );
  }

  Widget categories() {
    return FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection("categories")
            .orderBy('id')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String name = snapshot.data.docs[index]['name'];
                    int id = snapshot.data.docs[index]['id'];
                    return categoryCard(id: id, name: name);
                  });
            } else {
              return Text("No Category");
            }
          }
          return CircularProgressIndicator();
        });
  }

  Widget categoryCard({required int id, required String name}) {
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
                  Text(name),
                  FutureBuilder<dynamic>(
                    future: FirebaseFirestore.instance
                        .collection('items')
                        .where('category', isEqualTo: name)
                        .get(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            snapshot.data.docs.length.toString() + " item(s)");
                      }
                      return Container(
                          width: 30, child: LinearProgressIndicator());
                    }),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit),
              color: Colors.deepPurple,
            ),
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete ' + name + '?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('Deleting category will not effect items.'),
                            Text('Would you like to delete?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Approve'),
                          onPressed: () {
                            showLoading(context);
                            FirebaseFirestore.instance
                                .collection('categories')
                                .doc(id.toString())
                                .delete()
                                .then((value) {
                              PageRouteTransition.pop(context);
                              PageRouteTransition.pop(context);
                            });
                            setState(() {});
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }

  Widget createCategoryModal(StateSetter setModalState) {
    return Container(
      // height: 200,
      color: Color.fromARGB(255, 255, 255, 255),
      child: Form(
        key: _formKey,
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
              child: TextFormField(
                controller: _categoryName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Gold, Silver',
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This is required";
                  }
                  return null;
                },
              ),
            ),
            Center(
              child: MaterialButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    showLoading(context);
                    int uniqueId = DateTime.now().millisecondsSinceEpoch;
                    Map<String, dynamic> categoryMap = {
                      'id': uniqueId,
                      'name': _categoryName.text
                    };
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .doc(uniqueId.toString())
                        .set(categoryMap)
                        .then((value) {
                      _categoryName.clear();
                      PageRouteTransition.pop(context);
                      PageRouteTransition.pop(context);
                    });
                  }
                  setState(() {});
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    color: Colors.purple,
                    width: double.infinity,
                    child: Center(child: Text("Create"))),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
