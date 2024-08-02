import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Helper/user.dart';

final mortgageBookFuture =
    FutureProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
  (ref) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection("mortgageBook")
        .orderBy('id', descending: true)
        .get();
    ref.keepAlive();
    return data;
  },
);

final bookStatsFuture =
    FutureProvider.autoDispose.family<QuerySnapshot<Map<String, dynamic>>, int>(
  (ref, bookId) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection('mortgageBill')
        .where('status', isEqualTo: 'Active')
        .where('bookId', isEqualTo: bookId)
        .get();
    ref.keepAlive();
    return data;
  },
);
