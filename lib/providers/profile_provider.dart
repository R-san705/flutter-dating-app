import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';

import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final UserAttributes userAttributes;
  ProfileProvider(this.userAttributes);

  ProfileModel? userProfile;

  Future<void> fetchMyUser() async {
    final uid = userAttributes.uid;
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
    userProfile = ProfileModel(
        uid, name, birth, sex, profile, imageURL1, imageURL2, imageURL3);
    notifyListeners();
  }
}
