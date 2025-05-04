// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_delete_file.dart';
import 'package:projectmanagementstmiktime/model/model_upload_file.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class UploadFileService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelUploadFile?> uploadFileToServer({
    required File file,
    required String token,
    required int taskId,
  }) async {
    try {
      String filename = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: filename,
        ),
      });

      // Replace with your actual API endpoint
      final response = await _dio.post(
        "${Urls.taskListId}$taskId/${Urls.fileUrls}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelUploadFile.fromJson(response.data);
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
        requestOptions:
            RequestOptions(path: "${Urls.taskListId}$taskId/${Urls.fileUrls}"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelDeleteFiles?> deleteChecklist({
    required String token,
    required int fileId,
  }) async {
    try {
      final response = await _dio.delete(
        "${Urls.taskListId}${Urls.fileUrls}/$fileId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelDeleteFiles.fromJson(response.data);
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
            RequestOptions(path: "${Urls.taskListId}${Urls.fileUrls}/$fileId"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
