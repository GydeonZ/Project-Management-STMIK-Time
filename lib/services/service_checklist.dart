// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_add_checklist.dart';
import 'package:projectmanagementstmiktime/model/model_delete_checklist.dart';
import 'package:projectmanagementstmiktime/model/model_edit_name_checklist.dart';
import 'package:projectmanagementstmiktime/model/model_toggle_checklist.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class ChecklistService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelAddChecklist?> addCheckList({
    required String token,
    required String clName,
    required int taskId,
  }) async {
    final FormData formData = FormData.fromMap({
      'name': clName,
    });

    try {
      final response = await _dio.post(
        "${Urls.taskListId}$taskId/checklist",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelAddChecklist.fromJson(response.data);
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
        throw e; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions:
            RequestOptions(path: "${Urls.taskListId}$taskId/checklist"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelToggleChecklist?> toggleCheckList({
    required String token,
    required int clID,
  }) async {
    try {
      final response = await _dio.post(
        "${Urls.taskListId}checklist/$clID/toggle",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelToggleChecklist.fromJson(response.data);
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
        throw e; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions:
            RequestOptions(path: "${Urls.taskListId}checklist/$clID/toggle"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelUpdateNameChecklist?> updateNameCheckList({
    required String token,
    required int clID,
    required String clName,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        'name': clName,
      });
      final response = await _dio.post(
        "${Urls.taskListId}checklist/$clID/name",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelUpdateNameChecklist.fromJson(response.data);
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
        throw e; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions:
            RequestOptions(path: "${Urls.taskListId}checklist/$clID/name"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelDeleteChecklist?> deleteChecklist({
    required String token,
    required int clID,
  }) async {
    try {
      final response = await _dio.delete(
        "${Urls.taskListId}checklist/$clID",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelDeleteChecklist.fromJson(response.data);
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
        throw e; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions:
            RequestOptions(path: "${Urls.taskListId}checklist/$clID"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
