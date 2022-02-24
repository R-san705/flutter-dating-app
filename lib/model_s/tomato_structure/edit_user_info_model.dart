import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newtype_chatapp/models/profile_model.dart';

class EditUserInfoModel extends ChangeNotifier {
  final ProfileModel myUser;
  EditUserInfoModel(this.myUser) {
    nameController.text = myUser.name;
    birthController.text = myUser.birth;
    profileController.text = myUser.profile;
    chosenValue = myUser.sex;
    imageURL1 = myUser.imageURL1;
    imageURL2 = myUser.imageURL2;
    imageURL3 = myUser.imageURL3;
  }

  final nameController = TextEditingController();
  final birthController = TextEditingController();
  final profileController = TextEditingController();
  late String chosenValue;
  late String? imageURL1;
  late String? imageURL2;
  late String? imageURL3;

  String? name;
  String? birth;
  String? profile;
  String? sex;
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  bool isLoading = false;

  final picker = ImagePicker();

  bool isUpdated() {
    return name != null || birth != null || profile != null || sex != null;
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setBirth(String value) {
    birth = value;
    notifyListeners();
  }

  void setSex(String value) {
    sex = value;
    notifyListeners();
  }

  void setProfile(String value) {
    profile = value;
    notifyListeners();
  }

  void setChosenValue(String value) {
    chosenValue = value;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future updateUserInfo() async {
    name = nameController.text;
    birth = birthController.text;
    profile = profileController.text;
    sex = chosenValue;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc(uid);
    List<String?> preImageURLs = [imageURL1, imageURL2, imageURL3];
    List<File?> imageFiles = [imageFile1, imageFile2, imageFile3];

    try {
      for (int i = 0; i < preImageURLs.length; i++) {
        if (preImageURLs[i] != null && imageFiles[i] != null) {
          final ref = firebase_storage.FirebaseStorage.instance
              .ref('users/$uid/image_file$i');
          await ref.delete();
          final task = await firebase_storage.FirebaseStorage.instance
              .ref('users/$uid/image_file$i')
              .putFile(imageFiles[i]!);
          String url = await task.ref.getDownloadURL();
          await doc.update({'imageURL${i + 1}': url});
        } else if (preImageURLs[i] == null && imageFiles[i] != null) {
          final task = await firebase_storage.FirebaseStorage.instance
              .ref('users/$uid/image_file$i')
              .putFile(imageFiles[i]!);
          String url = await task.ref.getDownloadURL();
          await doc.update({'imageURL${i + 1}': url});
        }
      }
    } catch (e) {
      throw e;
    }

    await doc.update({
      'name': name,
      'birth': birth,
      'profile': profile,
      'sex': sex,
    });
    notifyListeners();
  }

  Future pickImage1() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      imageFile1 = File(pickedFile.path);
    } on PlatformException catch (e) {
      print("失敗しました:$e");
    }
    notifyListeners();
  }

  Future pickImage2() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      imageFile2 = File(pickedFile.path);
    } on PlatformException catch (e) {
      print('失敗しました:$e');
    }
    notifyListeners();
  }

  Future pickImage3() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      imageFile3 = File(pickedFile.path);
    } on PlatformException catch (e) {
      print('失敗しました:$e');
    }
    notifyListeners();
  }
}
