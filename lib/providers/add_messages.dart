import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AddMessages extends ChangeNotifier {
  final String uid;
  final String partnerUid;
  AddMessages(this.partnerUid, this.uid);

  DateFormat outputFormat = DateFormat('HH:mm');
  DateTime t = DateTime.now();

  Future<void> addMessages(String message) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(partnerUid)
        .collection('messages');
    CollectionReference partnerRef = FirebaseFirestore.instance
        .collection('users')
        .doc(partnerUid)
        .collection('friends')
        .doc(uid)
        .collection('messages');
    DocumentReference myRecentMessageRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(partnerUid);
    DocumentReference partnerRecentMessageRef = FirebaseFirestore.instance
        .collection('users')
        .doc(partnerUid)
        .collection('friends')
        .doc(uid);

    await ref.add({
      'message': message,
      'sentAt': t.millisecondsSinceEpoch.toString(),
      'sentBy': uid,
      'message_type': 'sender',
    });
    await partnerRef.add({
      'message': message,
      'sentAt': t.millisecondsSinceEpoch.toString(),
      'sentBy': uid,
      'message_type': 'receiver',
    });
    await myRecentMessageRef.set({
      'recent_message': message,
      'sentAt': t.millisecondsSinceEpoch.toString(),
      'sentAt2': outputFormat.format(t),
      'sentBy': uid,
      'friendUid': partnerUid,
    });
    await partnerRecentMessageRef.set({
      'recent_message': message,
      'sentAt': t.millisecondsSinceEpoch.toString(),
      'sentAt2': outputFormat.format(t),
      'sentBy': uid,
      'friendUid': uid,
    });
    notifyListeners();
  }
}
