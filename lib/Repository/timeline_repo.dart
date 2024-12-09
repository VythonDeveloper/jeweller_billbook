import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeweller_stockbook/Helper/user.dart';

final timelineListProvider = StateProvider(
  (ref) => [],
);

final timelineFuture =
    FutureProvider.autoDispose.family<QuerySnapshot<Map<String, dynamic>>, int>(
  (ref, limit) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserData.uid)
        .collection('transactions')
        .orderBy('id', descending: true)
        .limit(limit)
        .get();

    ref.read(timelineListProvider.notifier).state = data.docs;
    ref.keepAlive();
    return data;
  },
);
