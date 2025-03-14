import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/view/board/board.dart';

class NavigationProvider extends ChangeNotifier {
  var pageIndex = 0;
  List<Widget> navigationbar = [
    const BoardScreen(),
    // const ChatbotScreen(),
    // const Riwayat(),
    // const SettingScreen(),
  ];

  void updateIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  void out() {
    pageIndex = 0;
    notifyListeners();
  }
}
