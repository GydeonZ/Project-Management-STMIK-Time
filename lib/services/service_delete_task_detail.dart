// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_delete_detail_task.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart'; 

class DeleteDetailTaskService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelDeleteDetailTask?> hitDeleteDetailTask({
    required String token,
    required String taskId,
  }) async {
    try {
      final response = await _dio.delete(
        "${Urls.apiTugas}/$taskId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Sertakan token
          },
        ),
      );

      // Periksa status response
      if (response.statusCode == 200) {
        return ModelDeleteDetailTask.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Gagal menambahkan tugas: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
