import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';

class AddMessages extends ChangeNotifier {
  final UserAttributes userAttributes;
  final String partnerUid;
  AddMessages(this.partnerUid, this.userAttributes);
  String message = '';

  void setMessage(String value) {
    message = value;
    notifyListeners();
  }

  final TextEditingController msgController = TextEditingController();

  Future<void> addMessages() async {
    message = msgController.text;

    final uid = userAttributes.uid;
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

    msgController.clear();
    notifyListeners();
  }
}
