import 'package:flutter/material.dart';
import 'package:newtype_chatapp/screens/discovery/discovery_ui.dart';
import 'package:newtype_chatapp/screens/swipe/swiper_ui.dart';
import 'package:newtype_chatapp/screens/talk/chat_ui.dart';

class LoggedInPageModel extends ChangeNotifier {
  final String uid;
  LoggedInPageModel(this.uid) {
    widgetOptions = <Widget>[
      Swiper(),
      ChatUi(uid: uid),
      const Discovery(),
    ];
  }

  late List<Widget> widgetOptions;

  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
