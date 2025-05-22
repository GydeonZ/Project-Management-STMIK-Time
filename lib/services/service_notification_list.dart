// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_notifikasi.dart';
import 'package:projectmanagementstmiktime/model/model_mark_notification.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class NotificationListService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelFetchNotifikasi?> fetchNotificationList({
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        Urls.notificationList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelFetchNotifikasi.fromJson(response.data);
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
        requestOptions: RequestOptions(path: Urls.notificationList),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelMarkNotification?> markNotifcation({
    required String token,
    required int notifId,
  }) async {
    try {
      final response = await _dio.post(
        "${Urls.markNotif}$notifId/mark-as-read",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelMarkNotification.fromJson(response.data);
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
        requestOptions: RequestOptions(path: "${Urls.markNotif}$notifId/mark-as-read"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<bool> markNotifcationAll({
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        "${Urls.markNotif}mark-all-as-read",
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

  Future<bool> deleteNotif({
    required String token,
  }) async {
    try {
      final response = await _dio.delete(
        Urls.deleteNotif,
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
