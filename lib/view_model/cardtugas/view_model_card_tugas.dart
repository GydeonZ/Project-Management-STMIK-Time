import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_add_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_card_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_tambah_card_tugas.dart';

class CardTugasViewModel with ChangeNotifier {
  ModelFetchCardTugas? modelFetchCardTugas;
  TextEditingController namaCard = TextEditingController();
  TextEditingController namaTugas = TextEditingController();
  final services = CardTugasService();
  final service = TambahCardTugasService();
  final taskService = TambahTugasService();
  bool isLoading = false;
  bool isSukses = false;
  bool heightContainer = false;
  String savedBoardId = "";
  String cardId = "";
  String? successMessage;
  String? errorMessages;
  final formKey = GlobalKey<FormState>();

  /// 🔹 Fetch Board List (dengan token)
  Future<int> getCardTugasList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();
      modelFetchCardTugas = await services.fetchCardTugas(token: token);
      isLoading = false;
      if (modelFetchCardTugas != null) {
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
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
      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    } finally {
      isLoading = false; // Pastikan loading diatur ke false setelah selesai
      notifyListeners();
    }
  }

  Future<bool> refreshCardTugasData({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await services.fetchCardTugas(token: token);

      if (result != null) {
        modelFetchCardTugas = result;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        errorMessages = '';
        return true;
      } else {
        isSukses = false;
        errorMessages = 'Data tidak ditemukan';
        return false;
      }
    } on DioException catch (e) {
      errorMessages = "Terjadi kesalahan: ${e.message}";
      return false;
    } catch (e) {
      errorMessages = "Error tidak terduga: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  String? validateNamaCard(String value) {
    if (value.trim().isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Nama tugas tidak boleh kosong';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  void setBoardId(String boardId) {
    savedBoardId = boardId;
    notifyListeners(); // Memastikan UI diperbarui jika diperlukan
  }

  Future<int> tambahTugasCard({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitTambahCardTugas(
        token: token,
        namaCard: namaCard.text,
        boardId: savedBoardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
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

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> deleteTugasCard({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitDeleteCardTugas(
        token: token,
        cardId: cardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
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

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }
  
  Future<int> updateTugasCard({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitUpdateCardTugas(
        token: token,
        namaCard: namaCard.text,
        cardId: cardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
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

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> tambahTugas({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await taskService.hitTambahTugas(
        token: token,
        namaCard: namaTugas.text,
        cardId: cardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaTugas.clear();
        heightContainer = false;
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

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }
}
