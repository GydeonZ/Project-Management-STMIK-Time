import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:projectmanagementstmiktime/model/model_board.dart';
import 'package:projectmanagementstmiktime/services/sevices_board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardViewModel with ChangeNotifier {
  ModelBoard? modelBoard;
  final services = BoardService();
  String _tanggalTerformat = '';
  bool isLoading = false;
  String userName = "";
  String nameSharedPreference = '';

  String get tanggalTerformat => _tanggalTerformat;

  BoardViewModel() {
    _loadUserName();
    _perbaruiTanggal();
  }

  /// 🔹 Ambil Username dari SharedPreferences
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedFullName = prefs.getString('name')  ?? "User";
    nameSharedPreference = storedFullName;
    notifyListeners();
  }

  /// 🔹 Fetch Board List (dengan token)
  Future<void> getBoardList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      modelBoard = await services.fetchBoard(token: token);
      print(
          "Board count: ${modelBoard?.data.length}"); // Debugging jumlah board

      isLoading = false;
    } catch (e) {
      print("Error fetching boards: $e");
      isLoading = false;
    }
    notifyListeners();
  }

  /// 🔹 Perbarui Tanggal
  Future<void> _perbaruiTanggal() async {
    await initializeDateFormatting('id_ID', null);
    _tanggalTerformat =
        DateFormat('EEEE, d MMMM', 'id_ID').format(DateTime.now());
    notifyListeners();
  }
}
