import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:jeweller_stockbook/Helper/select_Contacts.dart';

class ContactCrudUI extends StatefulWidget {
  const ContactCrudUI({super.key});

  @override
  State<ContactCrudUI> createState() => _ContactCrudUIState();
}

class _ContactCrudUIState extends State<ContactCrudUI> {
  TextEditingController _searchKey = TextEditingController();
  List<Contact> contactsList = [];
  List<Contact> contactsFiltered = [];
  bool isLoading = false;
  //------------------->
  @override
  void initState() {
    super.initState();
    getContacts();
    _searchKey.addListener(() {
      filterContacts();
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contactsList);
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
    contactsList = await SelectContact().getContacts().whenComplete(() {
      setState(() {
        isLoading = false;
      });
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
          ContactsAppbar(),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: isSearching
                        ? contactsFiltered.length
                        : contactsList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Contact contact = isSearching
                          ? contactsFiltered[index]
                          : contactsList[index];
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
      onTap: () {
        final formattedNumber =
            contact.phones[0].number.replaceAll(' ', '').split('+91').last;
        Map<String, dynamic> contactMap = {
          'displayName': contact.displayName,
          'phone': formattedNumber,
        };
        Navigator.pop(context, contactMap);
      },
      leading: contact.photo == null
          ? CircleAvatar(
              child: Text(
                contact.displayName[0],
              ),
            )
          : CircleAvatar(
              backgroundImage: MemoryImage(contact.photo!),
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
                color: Colors.blue.shade700,
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
                color: Colors.indigo.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_outlined,
                    color: Colors.indigo,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Create Contact',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.indigo,
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
