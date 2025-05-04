import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_add_board.dart';

class AddBoardViewModel with ChangeNotifier {
  final TextEditingController boardName = TextEditingController();
  final TextEditingController selectedVisibility = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool heightContainer = false;
  bool isSukses = false;
  bool isLoading = false;
  final addBoardService = AddBoardListService();
  String? errorMessages;
  String? successMessage;

  Future<int> addBoardList({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await addBoardService.hitAddBoardList(
        token: token,
        name: boardName.text,
        visibility: selectedVisibility.text,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        boardName.text = '';
        notifyListeners();
        return 200;
      } else { 
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan";
      return 500;
    }
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