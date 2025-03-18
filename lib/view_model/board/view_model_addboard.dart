import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_add_board.dart';

class AddBoardViewModel with ChangeNotifier {
  final TextEditingController boardName = TextEditingController();
  final TextEditingController selectedVisibility = TextEditingController();
  bool heightContainer = false;
  bool isSukses = true;
  final addBoardService = AddBoardListService();

  Future addBoardList({
    required String token,
  }) async {
    try {
      isSukses = false;
      await addBoardService.hitAddBoardList(
        token: token,
        name: boardName.text,
        visibility: selectedVisibility.text,
      );
      isSukses = true;
    } catch (e) {
      // ignore: deprecated_member_use
      if (e is DioError) {
        e.response!.statusCode;
      }
    }
    notifyListeners();
  }

  String? validateBoardName(String value) {
    if (value.isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Nama Dashboard Tidak Boleh Kosong';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  void clearAll() {
    boardName.clear();
    selectedVisibility.clear();
  }
}