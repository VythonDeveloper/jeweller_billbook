import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:jeweller_stockbook/Helper/select_Contacts.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/utils/components.dart';
import 'package:jeweller_stockbook/utils/constants.dart';

import '../utils/colors.dart';

class CreateMrtgBookUi extends StatefulWidget {
  const CreateMrtgBookUi({super.key});

  @override
  State<CreateMrtgBookUi> createState() => _CreateMrtgBookUiState();
}

class _CreateMrtgBookUiState extends State<CreateMrtgBookUi> {
  TextEditingController _searchKey = TextEditingController();

  List<Contact> contactsFiltered = [];
  bool isLoading = false;

  //------------------->
  @override
  void initState() {
    super.initState();

    _searchKey.addListener(() {
      filterContacts();
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(Constants.myContacts);
    if (_searchKey.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = _searchKey.text.toLowerCase().trim();
        String contactName = contact.displayName.toLowerCase();
        String contactPhone = contact.phones.isEmpty
            ? ''
            : contact.phones[0].number.replaceAll(' ', '').toString();

        return contactName.contains(searchTerm) ||
            contactPhone.contains(searchTerm);
      });

      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  getContacts() async {
    setState(() {
      isLoading = true;
    });
    Constants.myContacts = await SelectContact().getContacts();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchKey.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Contact',
        ),
        actions: [
          IconButton(
            onPressed: () {
              getContacts();
            },
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: isLoading,
            child: LinearProgressIndicator(),
          ),
          ContactsAppbar(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: isSearching
                  ? contactsFiltered.length
                  : Constants.myContacts.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Contact contact = isSearching
                    ? contactsFiltered[index]
                    : Constants.myContacts[index];
                if (contact.phones.isEmpty) {
                  return SizedBox();
                }
                return ContactCard(contact);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget ContactCard(Contact contact) {
    return ListTile(
      onTap: () async {
        // showLoading(context);
        // int uniqueId = DateTime.now().millisecondsSinceEpoch;
        // final formattedNumber = contact.phones[0].number.replaceAll(' ', '');
        // final name = contact.displayName;

        // Map<String, dynamic> mrtgBook = {
        //   'id': uniqueId,
        //   'name': name,
        //   'phone': formattedNumber,
        //   'totalPrinciple': 0,
        //   'totalInterest': 0,
        //   'totalPaid': 0
        // };

        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(UserData.uid)
        //     .collection('mortgageBook')
        //     .doc(uniqueId.toString())
        //     .set(mrtgBook);
        // Navigator.pop(context);
        // Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Create book for ',
                            style: TextStyle(fontSize: 20),
                            children: [
                              TextSpan(
                                text: contact.displayName + "?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        height20,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                showLoading(context);
                                int uniqueId =
                                    DateTime.now().millisecondsSinceEpoch;
                                final formattedNumber = contact.phones[0].number
                                    .replaceAll(' ', '');
                                final name = contact.displayName;

                                Map<String, dynamic> mrtgBook = {
                                  'id': uniqueId,
                                  'name': name,
                                  'phone': formattedNumber,
                                  'totalPrinciple': 0,
                                  'totalInterest': 0,
                                  'totalPaid': 0
                                };

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(UserData.uid)
                                    .collection('mortgageBook')
                                    .doc(uniqueId.toString())
                                    .set(mrtgBook);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Yes'),
                            ),
                            width10,
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('No'),
                            ),
                          ],
                        ),
                        // Text(
                        //   'Create mortgage book for ${contact.displayName}?',
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ));
      },
      leading: CircleAvatar(
        backgroundColor: kPrimaryColor,
        child: Text(
          contact.displayName[0],
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        contact.displayName,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(contact.phones[0].number),
    );
  }

  Widget ContactsAppbar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          searchBar(),
          height10,
          ElevatedButton(
              onPressed: () {
                SelectContact().createContact().then((value) {
                  getContacts();
                });
              },
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline_outlined,
                      color: kPrimaryColor,
                      size: 17,
                    ),
                    width10,
                    Text(
                      'Create Contact',
                      style: TextStyle(
                        fontSize: 20,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchKey,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
          ),
          border: InputBorder.none,
          hintText: 'Search by Name',
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }
}
