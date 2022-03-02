import 'package:flutter/material.dart';

class PreviewPageModel extends ChangeNotifier {
  int activePage = 0;
  void setActivePage(page) {
    activePage = page;
    notifyListeners();
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.white : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }
}
