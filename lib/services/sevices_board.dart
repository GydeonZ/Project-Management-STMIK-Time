import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_board.dart';
import 'package:projectmanagementstmiktime/model/model_delete_board.dart';
import 'package:projectmanagementstmiktime/model/model_duplicate_board.dart';
import 'package:projectmanagementstmiktime/model/model_edit_board.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class BoardService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelBoard?> fetchBoard({
    required String? token,
  }) async {
    try {
      final response = await _dio.get(
        Urls.baseUrls + Urls.board,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ModelBoard.fromJson(response.data);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<ModelUpdateBoard?> updateBoard(
      {required String? token,
      required String encryptId,
      required String boardName,
      required String visibility}) async {
    try {
      final FormData formData = FormData.fromMap({
        'name': boardName,
        'visibility': visibility,
      });
      final response = await _dio.post(
        "${Urls.board}/$encryptId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelUpdateBoard.fromJson(response.data);
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
      if (e.response != null && e.response!.statusCode == 400) {
        rethrow;
      }
      throw DioException(
        requestOptions: RequestOptions(path: "${Urls.board}/$encryptId"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelDeleteBoard?> deleteBoard({
    required String? token,
    required String encryptId,
  }) async {
    try {
      final response = await _dio.delete(
        "${Urls.board}/$encryptId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelDeleteBoard.fromJson(response.data);
      } else {
        // Dapatkan pesan error dari respons API
        String errorMessage = "Terjadi kesalahan";
        if (response.data != null && response.data is Map) {
          errorMessage = response.data['message'] ?? errorMessage;
        }

        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: errorMessage, // Gunakan pesan dari API
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Ekstrak pesan error dari respons API
        String apiErrorMessage = "Terjadi kesalahan";
        if (e.response!.data != null && e.response!.data is Map) {
          apiErrorMessage = e.response!.data['message'] ?? apiErrorMessage;
        }

        throw DioException(
          response: e.response,
          requestOptions: e.requestOptions,
          message: apiErrorMessage, // Gunakan pesan dari API
          type: e.type,
        );
      }
      rethrow; // Re-throw jika tidak ada respons
    }
  }

  Future<ModelDuplicateBoard?> hitDuplicateBord({
    required String? token,
    required String encryptedId,
  }) async {
    try {
      final response = await _dio.post(
        '${Urls.board}/$encryptedId${Urls.dupeBoard}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelDuplicateBoard.fromJson(response.data);
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
      if (e.response != null && e.response!.statusCode == 400) {
        rethrow;
      }
      throw DioException(
        requestOptions:
            RequestOptions(path: "${Urls.board}/$encryptedId${Urls.dupeBoard}"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
