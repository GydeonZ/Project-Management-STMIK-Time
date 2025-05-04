import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/mode_move_card.dart';
import 'package:projectmanagementstmiktime/model/model_move_task.dart';
import 'package:projectmanagementstmiktime/model/model_tambah_card_tugas.dart';
import 'package:projectmanagementstmiktime/model/model_update_card_tugas.dart';
import '../utils/utils.dart';

class TambahCardTugasService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelTambahCardTugas?> hitTambahCardTugas({
    required String token,
    required String namaCard,
    required String boardId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': namaCard,
        'board_id': boardId,
      });

      final response = await _dio.post(
        Urls.fetchCardList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelTambahCardTugas.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Terjadi kesalahan: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      // ✅ Pastikan error dari API tetap ditampilkan
      if (e.response != null) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.fetchCardList),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelTambahCardTugas?> hitDeleteCardTugas({
    required String token,
    required String cardId,
  }) async {
    try {
      final response = await _dio.delete(
        "${Urls.fetchCardList}/$cardId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelTambahCardTugas.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Terjadi kesalahan: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      // ✅ Pastikan error dari API tetap ditampilkan
      if (e.response != null) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.fetchCardList),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelUpdateCardTugas?> hitUpdateCardTugas({
    required String token,
    required String namaCard,
    required String cardId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': namaCard,
      });

      final response = await _dio.post(
        "${Urls.fetchCardList}/$cardId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelUpdateCardTugas.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Terjadi kesalahan: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      // ✅ Pastikan error dari API tetap ditampilkan
      if (e.response != null) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.fetchCardList),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelMoveTask?> hitUpdateMoveTask({
    required String token,
    required int taskId,
    required int cardId,
    required int position, // Pastikan nilai minimal 1
  }) async {
    try {
      // Validasi position minimal 1
      final validPosition = position < 1 ? 1 : position;

      final response = await _dio.post(
        "${Urls.taskListId}$taskId/move", // Sesuaikan dengan endpoint API
        data: {
          'card_id': cardId,
          'position': validPosition, // Gunakan nilai yang valid
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelMoveTask.fromJson(response.data);
      }
      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<ModelMoveCard?> hitUpdateCardPosition({
    required String token,
    required int cardId,
    required int position,
    required int boardId,
  }) async {
    try {
      // Validasi position minimal 1
      final validPosition = position < 1 ? 1 : position;

      final response = await _dio.post(
        "${Urls.fetchCardList}/$cardId/move", // Sesuaikan dengan endpoint API
        data: {
          'board_id': boardId,
          'position': validPosition,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelMoveCard.fromJson(response.data);
      }
      return null;
    } on DioException {
      rethrow;
    }
  }
}
