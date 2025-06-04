// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_comment.dart';

import 'package:projectmanagementstmiktime/utils/utils.dart';

class CommentService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelKomentar?> hitPostComment({
    required String token,
    required String comment,
    required int taskId,
  }) async {
    final FormData formData = FormData.fromMap({
      'comment': comment,
    });

    try {
      final response = await _dio.post(
        "${Urls.taskListId}$taskId/comments",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelKomentar.fromJson(response.data);
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
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions:
            RequestOptions(path: "${Urls.taskListId}$taskId/comments"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelKomentar?> hitEditComment({
    required String token,
    required String comment,
    required String commentId,
  }) async {
    final FormData formData = FormData.fromMap({
      'comment': comment,
    });

    try {
      final response = await _dio.post(
        "${Urls.editComment}/$commentId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelKomentar.fromJson(response.data);
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
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions:
            RequestOptions(path: "${Urls.editComment}/$commentId",
        ),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<bool> deleteComment({
    required String token,
    required String commentId,
  }) async {
    try {
      final response = await _dio.delete(
        "${Urls.deleteComment}/$commentId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response.statusCode);
      return response.statusCode == 200;
    } on DioException catch (_) {
      rethrow;
    }
  }
}
