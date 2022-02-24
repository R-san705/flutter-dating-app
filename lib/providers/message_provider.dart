import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/models/message_model.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';

class MessageProvider extends ChangeNotifier {
  final UserAttributes userAttributes;
  final String partnerUid;
  List<MessageModel>? messages;
  MessageProvider(this.partnerUid, this.userAttributes) {
    final uid = userAttributes.uid;
    final Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(partnerUid)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
    collectionStream.listen((QuerySnapshot querySnapshot) {
      final List<MessageModel> _messages =
          querySnapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String message = data['message'];
        final String? sentAt = data['sentAt'];
        final String sentBy = data['sentBy'];
        final String messageType = data['message_type'];
        return MessageModel(message, sentAt, sentBy, messageType);
      }).toList();
      messages = _messages;
      notifyListeners();
    });
  }
}
