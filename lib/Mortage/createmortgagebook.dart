import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:jeweller_stockbook/Helper/select_Contacts.dart';
import 'package:jeweller_stockbook/Helper/user.dart';
import 'package:jeweller_stockbook/components.dart';
import 'package:jeweller_stockbook/constants.dart';

import '../colors.dart';

class CreateMortgageBookUi extends StatefulWidget {
  const CreateMortgageBookUi({super.key});

  @override
  State<CreateMortgageBookUi> createState() => _CreateMortgageBookUiState();
}

class _CreateMortgageBookUiState extends State<CreateMortgageBookUi> {
  TextEditingController _searchKey = TextEditingController();
  // List<Contact> Constants.myContacts = [];
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

  ListTile ContactCard(Contact contact) {
    return ListTile(
      onTap: () async {
        showLoading(context);
        int uniqueId = DateTime.now().millisecondsSinceEpoch;
        final formattedNumber = contact.phones[0].number.replaceAll(' ', '');
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
      leading: CircleAvatar(
        backgroundColor: primaryColor,
        child: Text(
          contact.displayName[0],
        ),
      ),
      title: Text(contact.displayName),
      subtitle: Text(contact.phones[0].number),
    );
  }

  Widget ContactsAppbar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          TextField(
            controller: _searchKey,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: primaryColor,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Search Name, Phone .etc',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          GestureDetector(
            onTap: () {
              SelectContact().createContact().then((value) {
                getContacts();
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryAccentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_outlined,
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Create Contact',
                    style: TextStyle(
                      fontSize: 17,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
