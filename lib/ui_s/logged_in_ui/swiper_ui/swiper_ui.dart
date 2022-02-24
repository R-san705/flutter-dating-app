import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Swiper extends StatefulWidget {
  Swiper({Key? key}) : super(key: key);
  String userEmail = 'ゲストさんのemail';

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: currentUser != null
              ? Text(currentUser.toString())
              : Text('ゲストさんのemail'),
        ),
      ),
    );
  }
}
