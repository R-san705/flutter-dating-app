import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendsModel extends ChangeNotifier {
  final String uid;
  FriendsModel(this.uid);

  List<String>? friendsUid;

  Future<void> fetchMyFriend() async {
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
