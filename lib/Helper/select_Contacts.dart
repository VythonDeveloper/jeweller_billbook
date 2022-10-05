import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SelectContact {
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<void> createContact() async {
    // List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        await FlutterContacts.openExternalInsert();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
