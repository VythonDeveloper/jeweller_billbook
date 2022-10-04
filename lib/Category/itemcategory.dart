import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:page_route_transition/page_route_transition.dart';

class ItemCategoryUi extends StatefulWidget {
  const ItemCategoryUi({Key? key}) : super(key: key);

  @override
  State<ItemCategoryUi> createState() => _ItemCategoryUiState();
}

class _ItemCategoryUiState extends State<ItemCategoryUi> {
  final _formKey = GlobalKey<FormState>();
  final _categoryName = TextEditingController();
  final _searchKey = TextEditingController();

  createItemCategory() async {
    FocusScope.of(context).unfocus();
    try {
      if (_formKey.currentState!.validate()) {
        showLoading(context);
        int uniqueId = DateTime.now().millisecondsSinceEpoch;
        Map<String, dynamic> categoryMap = {
          'id': uniqueId,
          'name': _categoryName.text
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(UserData.uid)
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
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _categoryName.dispose();
    _searchKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CategoryAppbar(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: categories(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomFABButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return createCategoryModal();
            },
          );
        },
        icon: Icons.add,
        label: 'Create Category',
        heroTag: '',
      ),
    );
  }

  Widget CategoryAppbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Text(
            'Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 30,
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchKey,
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
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categories() {
    return FutureBuilder<dynamic>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(UserData.uid)
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
                    if (_searchKey.text.isEmpty) {
                      return categoryCard(id: id, name: name);
                    } else {
                      if (name
                          .toLowerCase()
                          .contains(_searchKey.text.toLowerCase())) {
                        return categoryCard(id: id, name: name);
                      }
                    }
                    return SizedBox();
                  });
            } else {
              return Text("No Category");
            }
          }
          return CircularProgressIndicator();
        });
  }

  Widget categoryCard({required int id, required String name}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.indigo.withOpacity(0.1),
      ),
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
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  FutureBuilder<dynamic>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(UserData.uid)
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
              icon: CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 18,
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return DeleteAlertBox(name, context, id);
                  },
                );
              },
              icon: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 18,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog DeleteAlertBox(String name, BuildContext context, int id) {
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
                .collection('users')
                .doc(UserData.uid)
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
  }

  Widget createCategoryModal() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: Color.fromARGB(255, 255, 255, 255),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create Item Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: TextFormField(
                  controller: _categoryName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ex: Gold, Silver',
                    labelText: 'Category Name',
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
                    createItemCategory();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Create",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    });
  }
}
