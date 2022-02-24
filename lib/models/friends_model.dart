import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';

class FriendsModel extends ChangeNotifier {
  final UserAttributes userAttributes;
  FriendsModel(this.userAttributes);

  List<String>? friendsUid;

  Future<void> fetchMyFriend() async {
    final uid = userAttributes.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .get();
    final List<String> _friendsUid =
        querySnapshot.docs.map((DocumentSnapshot document) {
      return document.id;
    }).toList();
    friendsUid = _friendsUid;
    notifyListeners();
  }
}
