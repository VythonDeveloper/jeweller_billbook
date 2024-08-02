import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Helper/user.dart';

final itemsFuture =
    FutureProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection("items")
        .orderBy('id', descending: true)
        .get();
    ref.keepAlive();
    return data;
  },
);

final weightFuture =
    FutureProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection('items')
        .orderBy('id', descending: true)
        .get();
    ref.keepAlive();
    return data;
  },
);
