import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final String uid;
  ProfileProvider(this.uid);

  ProfileModel? myProfile;

  Future<void> fetchMyUser() async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    final String name = data['name'];
    final String birth = data['birth'];
    final String profile = data['profile'];
    final String sex = data['sex'];
    final String? imageURL1 = data['imageURL1'];
    final String? imageURL2 = data['imageURL2'];
    final String? imageURL3 = data['imageURL3'];
    myProfile = ProfileModel(
        uid, name, birth, sex, profile, imageURL1, imageURL2, imageURL3);
    notifyListeners();
  }
}
