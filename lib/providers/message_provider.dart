import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/models/message_model.dart';

class MessageProvider extends ChangeNotifier {
  final String uid;
  final String partnerUid;
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  StreamSubscription<QuerySnapshot>? _messageSubscription;

  MessageProvider({required this.partnerUid, required this.uid}) {
    init();
  }

  Future<void> init() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(partnerUid)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _messages = [];
      for (final document in snapshot.docs) {
        _messages.add(
          MessageModel(
            message: document.data()['message'] as String,
            sentAt: document.data()['sentAt'] as String,
            sentBy: document.data()['sentBy'] as String,
            messageType: document.data()['message_type'] as String,
          ),
        );
      }
      notifyListeners();
    });
  }
}
