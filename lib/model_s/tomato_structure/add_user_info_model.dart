import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddUserInfoModel extends ChangeNotifier {
  String? name;
  String? birth;
  String? profile;
  String? sex;
  String chosenValue = '選んでください';
  String infoText = '';
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  bool nameOk = false;
  bool sexOk = false;
  bool profileOk = false;
  bool isLoading = false;

  final picker = ImagePicker();

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

  void setInfoText(String value) {
    infoText = value;
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

  Future addUserInfo() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final email = FirebaseAuth.instance.currentUser!.email;
    DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc(uid);
    List<File?> imageFiles = [imageFile1, imageFile2, imageFile3];
    List<String?>? imageURLs = [];
    try {
      for (int i = 0; i < imageFiles.length; i++) {
        if (imageFiles[i] != null) {
          final task = await firebase_storage.FirebaseStorage.instance
              .ref('users/$uid/image_file$i')
              .putFile(imageFiles[i]!);
          String url = await task.ref.getDownloadURL();
          imageURLs.add(url);
        } else {
          imageURLs.add('');
        }
      }
      await doc.set({
        'uid': uid,
        'email': email,
        'name': name,
        'birth': birth,
        'profile': profile,
        'sex': sex,
        'imageURL1': imageURLs[0],
        'imageURL2': imageURLs[1],
        'imageURL3': imageURLs[2],
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future pickImage1() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      imageFile1 = File(pickedFile.path);
    } on PlatformException catch (e) {
      print('失敗しました:$e');
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
