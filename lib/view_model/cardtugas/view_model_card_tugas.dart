import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_card_tugas.dart';

class CardTugasViewModel with ChangeNotifier {
  ModelFetchCardTugas? modelFetchCardTugas;
  final services = CardTugasService();
  bool isLoading = false;

  /// 🔹 Fetch Board List (dengan token)
  Future<void> getCardTugasList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();
      modelFetchCardTugas = await services.fetchCardTugas(token: token);
      print("Board count: ${modelFetchCardTugas?.boards.length}");
      isLoading = false;
    } catch (e) {
      print("Error fetching boards: $e");
      isLoading = false;
    }
    notifyListeners();
  }
}
