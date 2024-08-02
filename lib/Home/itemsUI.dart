import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeweller_stockbook/Helper/sdp.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/Items/createitem.dart';
import 'package:jeweller_stockbook/Category/itemcategory.dart';
import 'package:jeweller_stockbook/Items/itemDetails.dart';
import 'package:jeweller_stockbook/Repository/items_repo.dart';
import 'package:jeweller_stockbook/Stock/lowStock.dart';
import 'package:jeweller_stockbook/utils/colors.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';
import 'package:jeweller_stockbook/utils/kScaffold.dart';

class ItemsUI extends ConsumerStatefulWidget {
  const ItemsUI({Key? key}) : super(key: key);

  @override
  ConsumerState<ItemsUI> createState() => _ItemsUIState();
}

class _ItemsUIState extends ConsumerState<ItemsUI> {
  bool isLoading = false;
  final _searchKey = TextEditingController();
  List<String> categoryList = ['All Categories'];
  String _selectedCategory = "All Categories";
  List _allResults = [];
  List _resultList = [];

  @override
  void initState() {
    super.initState();
    _getItems();
    _searchKey.addListener(_onSearchChanged);
  }

  _getItems() async {
    await ref.read(itemsFuture).whenData(
      (data) {
        setState(() {
          _allResults = data.docs;
        });
      },
    );

    _searchResultList();
  }

  _onSearchChanged() async {
    _searchResultList();
  }

  _searchResultList() {
    var showResults = [];
    if (_searchKey.text.isNotEmpty) {
      for (var snapshot in _allResults) {
        var name = snapshot['name'];
        if (kCompare(name, _searchKey.text)) {
          showResults.add(snapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  @override
  void dispose() {
    _searchKey.removeListener(_onSearchChanged);
    _searchKey.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _getItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final itemsFutureData = ref.watch(itemsFuture);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(itemsFuture.future),
      child: KScaffold(
        isLoading: itemsFutureData.isLoading,
        loadingText: "Fetching items ...",
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: appBarItems(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                              ),
                            ),
                            width10,
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(right: 10),
                                scrollDirection: Axis.horizontal,
                                child: totalWeightList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      height10,
                      itemsList(),
                      kHeight(100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFABButton(
            onPressed: () {
              navPush(context, CreateItemUi()).then((value) => setState(() {}));
            },
            icon: Icons.add,
            label: 'Add Item'),
      ),
    );
  }

  Widget appBarItems() {
    return Column(
      children: [
        _searchBar(),
        height10,
        itemsSortingBar(),
      ],
    );
  }

  Widget _searchBar() {
    return TextFieldTapRegion(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      child: CupertinoSearchTextField(
        controller: _searchKey,
        padding: EdgeInsets.all(10),
        placeholder: 'Search name',
      ),
    );
  }

  Widget itemsSortingBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                  context: context,
                  isDismissible: false,
                  builder: (BuildContext context) {
                    return selectCategoryModal();
                  }).then((value) {
                setState(() {});
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: kCardCOlor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      _selectedCategory,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sdp(context, 10)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: sdp(context, 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        width10,
        Expanded(
          child: GestureDetector(
            onTap: () {
              navPush(context, LowStockUI());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: kColor(context).errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: kColor(context).onErrorContainer,
                    size: 15,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Low Stock',
                        style: TextStyle(
                            fontSize: sdp(context, 10),
                            color: kColor(context).onErrorContainer,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget totalWeightList() {
    return Consumer(
      builder: (context, ref, child) {
        final weightList = ref.watch(weightFuture);
        return weightList.when(
          data: (data) {
            Map<String, dynamic> totalWeightMap = {};
            for (int i = 0; i < data.docs.length; i++) {
              var itemMap = data.docs[i];
              if (totalWeightMap[itemMap['category']] != null) {
                totalWeightMap[itemMap['category']] +=
                    double.parse(itemMap['leftStockWeight'].toStringAsFixed(3));
                ;
              } else {
                totalWeightMap[itemMap['category']] =
                    double.parse(itemMap['leftStockWeight'].toStringAsFixed(3));
              }
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  totalWeightMap.keys.length,
                  (index) {
                    String key = totalWeightMap.keys.elementAt(index);
                    return totalWeightCard(
                      key: key,
                      totalWeight: totalWeightMap[key],
                    );
                  },
                ),
              ),
            );
          },
          error: (error, stackTrace) => SizedBox(),
          loading: () => Text("Getting weights ..."),
        );
      },
    );
  }

  Widget totalWeightCard({required String key, required double totalWeight}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kColor(context).secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: sdp(context, 10),
              color: Colors.black,
            ),
          ),
          Text(
            "Wt. ${totalWeight.toStringAsFixed(3)} GMS",
            style: TextStyle(
              fontSize: sdp(context, 8),
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget itemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _resultList.length,
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) => _itemsCard(itemMap: _resultList[index]),
    );
  }

  Widget _itemsCard({required var itemMap}) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        navPush(context, ItemDetailsUI(itemId: itemMap['id']))
            .then((value) => setState(() {}));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kTileColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kTileBorderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: kCardCOlor,
              radius: 18,
              child: Text(
                itemMap['name'][0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            width10,
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemMap['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            itemMap['leftStockWeight'].toStringAsFixed(3) +
                                ' ' +
                                itemMap['unit'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
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
                            style: TextStyle(fontSize: 12),
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
          ],
        ),
      ),
    );
  }

  Widget selectCategoryModal() {
    return StatefulBuilder(builder: (context, StateSetter setModalState) {
      return SafeArea(
        top: false,
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Item Category',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
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
                padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          navPush(context, ItemCategoryUi())
                              .then((value) => setModalState(() {}));
                        },
                        child: Text('Manage Categories')),
                    height15,
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedCategory == 'All Categories'
                            ? kLightPrimaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RadioListTile(
                        title: Text("All Categories"),
                        value: "All Categories",
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setModalState(() {
                            _selectedCategory = value.toString();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    categoriesRadioList(setModalState),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget categoriesRadioList(StateSetter setModalState) {
    return FutureBuilder<dynamic>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(UserData.uid)
          .collection('categories')
          .orderBy('id')
          .limit(5)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.length > 0) {
            return ListView.separated(
              separatorBuilder: (context, index) => height10,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: ((context, index) {
                String categoryName = snapshot.data.docs[index]['name'];
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedCategory == categoryName
                            ? kLightPrimaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RadioListTile(
                        title: Text(categoryName),
                        value: categoryName,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setModalState(() {
                            _selectedCategory = value.toString();
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
            );
          }
          return SizedBox();
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomLoading(indicatorColor: kPrimaryColor),
        );
      },
    );
  }
}
