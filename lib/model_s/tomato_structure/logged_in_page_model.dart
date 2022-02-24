import 'package:flutter/material.dart';
import 'package:newtype_chatapp/models/user_attributes_model.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/chat_ui/chat_ui.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/discovery_ui/discovery_ui.dart';
import 'package:newtype_chatapp/ui_s/logged_in_ui/swiper_ui/swiper_ui.dart';

class LoggedInPageModel extends ChangeNotifier {
  final UserAttributes userAttributes;
  LoggedInPageModel(this.userAttributes) {
    widgetOptions = <Widget>[
      Swiper(),
      ChatUi(userAttributes: userAttributes),
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
