import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

class DatabaseMethods {
  final _firestore = FirebaseFirestore.instance;

  //Adding user to database QUERY
  Future addUserInfoToDB(String uid, Map<String, dynamic> userInfoMap) async {
    return await _firestore.collection("users").doc(uid).set(userInfoMap);
  }

  //Delete one book
  _deleteBook(bookId) async {
    await _firestore
        .collection('users')
        .doc(UserData.uid)
        .collection('transact_books')
        .where('bookId', isEqualTo: bookId)
        .limit(1)
        .get()
        .then(
      (snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      },
    );
  }

  Future<String> deleteBookWithCollections(String bookId) async {
    try {
      await _firestore
          .collection('users')
          .doc(UserData.uid)
          .collection('transact_books')
          .doc(bookId)
          .collection('transacts')
          .limit(1)
          .get()
          .then((value) async {
        if (value.docs.isEmpty) {
          _deleteBook(bookId);
        } else {
          await _firestore
              .collection('users')
              .doc(UserData.uid)
              .collection('transact_books')
              .doc(bookId)
              .collection('transacts')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
              _deleteBook(bookId);
            }
          });
        }
      });
      return 'success';
    } catch (e) {
      print(e);
      return 'fail';
    }
  }

  //Delete one transact
  deleteTransact(bookId, transactId) async {
    await _firestore
        .collection('users')
        .doc(UserData.uid)
        .collection('transact_books')
        .doc(bookId)
        .collection('transacts')
        .where('transactId', isEqualTo: transactId)
        .limit(1)
        .get()
        .then(
      (snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      },
    );
  }

  //  clear all transacts
  deleteAllTransacts(String bookId) async {
    await _firestore
        .collection('users')
        .doc(UserData.uid)
        .collection('transact_books')
        .doc(bookId)
        .collection('transacts')
        .get()
        .then(
      (snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      },
    );
  }
}
