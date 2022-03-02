import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddMessages extends ChangeNotifier {
  final String uid;
  final String partnerUid;
  AddMessages(this.partnerUid, this.uid);

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

    await ref.add({
      'message': message,
      'sentAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'sentBy': uid,
      'message_type': 'sender',
    });
    await partnerRef.add({
      'message': message,
      'sentAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'sentBy': uid,
      'message_type': 'receiver',
    });
    notifyListeners();
  }
}
