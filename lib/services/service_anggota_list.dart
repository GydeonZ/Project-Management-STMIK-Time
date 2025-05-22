// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_add_anggota.dart';
import 'package:projectmanagementstmiktime/model/model_delete_anggota.dart';
import 'package:projectmanagementstmiktime/model/model_edit_anggota_tugas.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_anggota_list.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class AnggotaListService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelAnggotaList?> fetchAnggotaList({
    required String token,
    required String taskId,
  }) async {
    try {
      final response = await _dio.get(
        "${Urls.taskListId}$taskId/members",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelAnggotaList.fromJson(response.data);
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
        requestOptions: RequestOptions(path: "${Urls.taskListId}$taskId/members"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelDeleteAnggota?> deleteAnggota({
    required String token,
    required String taskId,
    required String userId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
      });
      final response = await _dio.post(
        "${Urls.taskListId}$taskId/members/remove",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelDeleteAnggota.fromJson(response.data);
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
        requestOptions: RequestOptions(path: "${Urls.taskListId}$taskId/members/remove"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelAddAnggota?> addAnggotaList({
    required String token,
    required String taskId,
    required String userId,
    required String userLevel,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'level': userLevel,
      });
      final response = await _dio.post(
        "${Urls.taskListId}$taskId/members",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelAddAnggota.fromJson(response.data);
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
        requestOptions: RequestOptions(path: "${Urls.taskListId}$taskId/members"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelEditAnggotaTugas?> editAnggotaList({
    required String token,
    required String taskId,
    required String userId,
    required String userLevel,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'level': userLevel,
      });
      final response = await _dio.post(
        "${Urls.taskListId}$taskId/members/level",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelEditAnggotaTugas.fromJson(response.data);
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
        requestOptions: RequestOptions(path: "${Urls.taskListId}$taskId/members/level"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
