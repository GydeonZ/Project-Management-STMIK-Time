import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/view/board/board.dart';
import 'package:projectmanagementstmiktime/screen/view/notification/notification_screen.dart';
import 'package:projectmanagementstmiktime/screen/view/profile/profile_screen.dart';

class NavigationProvider extends ChangeNotifier {
  var pageIndex = 0;
  List<Widget> navigationbar = [
    const BoardScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
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
