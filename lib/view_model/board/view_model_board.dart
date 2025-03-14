import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BoardViewModel with ChangeNotifier {
  String _tanggalTerformat = '';

  BoardViewModel() {
    _perbaruiTanggal();
  }

  String get tanggalTerformat => _tanggalTerformat;

  void _perbaruiTanggal() {
    initializeDateFormatting('id_ID', null).then((_) {
      _tanggalTerformat =
          DateFormat('EEEE, d MMMM', 'id_ID').format(DateTime.now());
      notifyListeners(); // Memperbarui tampilan
    });
  }
}
