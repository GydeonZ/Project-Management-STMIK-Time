// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_edit_deskripsi_task.dart';
import 'package:projectmanagementstmiktime/model/model_edit_end_time.dart';
import 'package:projectmanagementstmiktime/model/model_edit_judul_detail_task.dart';
import 'package:projectmanagementstmiktime/model/model_edit_start_time.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class EditDetailTaskService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelEditDeskripsiTask?> editDetailTaskDeskripsi({
    required String token,
    required String taskId,
    required String? deskripsiTugas,
  }) async {
    try {
      // Buat body sesuai format yang diharapkan
      final formData = FormData.fromMap({
        'description': deskripsiTugas,
      });

      // Kirim request POST ke API
      final response = await _dio.post(
        "${Urls.apiTugas}/$taskId/description",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Sertakan token
          },
        ),
      );

      // Periksa status response
      if (response.statusCode == 200) {
        return ModelEditDeskripsiTask.fromJson(response.data);
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

  Future<ModelEditStartTime?> editStartTime({
    required String token,
    required String taskId,
    required DateTime startDate,
  }) async {
    try {
      String formattedStartDate = "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')} ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}:${startDate.second.toString().padLeft(2, '0')}";
      final formData = FormData.fromMap({
        'start_time': formattedStartDate,
      });

      // Kirim request POST ke API
      final response = await _dio.post(
        "${Urls.apiTugas}/$taskId/start-time",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Sertakan token
          },
        ),
      );

      // Periksa status response
      if (response.statusCode == 200) {
        return ModelEditStartTime.fromJson(response.data);
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

  Future<ModelEditEndTime?> editEndTime({
    required String token,
    required String taskId,
    required DateTime endDate,
  }) async {
    try {
            String formattedEndDate =
          "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}:${endDate.second.toString().padLeft(2, '0')}";
      final formData = FormData.fromMap({
        'end_time': formattedEndDate,
      });

      // Kirim request POST ke API
      final response = await _dio.post(
        "${Urls.apiTugas}/$taskId/end-time",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Sertakan token
          },
        ),
      );

      // Periksa status response
      if (response.statusCode == 200) {
        return ModelEditEndTime.fromJson(response.data);
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

  Future<ModelEditJudulDetailTask?> hitUpdateJudulTugas({
    required String token,
    required String taskId,
    required String judulDetailTask,
  }) async {
    try {
      // Buat body sesuai format yang diharapkan
      final formData = FormData.fromMap({
        'name': judulDetailTask,
      });

      // Kirim request POST ke API
      final response = await _dio.post(
        "${Urls.apiTugas}/$taskId/name",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Sertakan token
          },
        ),
      );

      // Periksa status response
      if (response.statusCode == 200) {
        return ModelEditJudulDetailTask.fromJson(response.data);
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
