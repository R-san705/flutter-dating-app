import 'package:flutter/material.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/chat_ui/chat_ui.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/discovery_ui/discovery_ui.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/swiper_ui/swiper_ui.dart';

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
