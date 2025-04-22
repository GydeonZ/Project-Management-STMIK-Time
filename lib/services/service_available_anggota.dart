import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_available_anggota_list.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class AvailableAnggotaListService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  // In service_anggota_list.dart
  Future<ModelAvailableAnggotaList?> fetchAvailableAnggotaList({
    required String token,
    required String taskId,
  }) async {
    try {
      final response = await _dio.get(
        "${Urls.availableMember}$taskId/available-members",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // For debugging
      print("Response status code: ${response.statusCode}");
      print("Response type: ${response.data.runtimeType}");

      if (response.statusCode == 200) {
        try {
          // Check if response.data is already a Map
          if (response.data is Map<String, dynamic>) {
            return ModelAvailableAnggotaList.fromJson(response.data);
          }

          // If it's a string, parse it as JSON
          else if (response.data is String) {
            Map<String, dynamic> jsonData = json.decode(response.data);
            return ModelAvailableAnggotaList.fromJson(jsonData);
          }

          // If it's some other type, convert it safely
          else {
            Map<String, dynamic> jsonData =
                json.decode(json.encode(response.data));
            return ModelAvailableAnggotaList.fromJson(jsonData);
          }
        } catch (e) {
          print("Error parsing response data: $e");
          print("Raw response: ${response.data}");
          throw Exception("Failed to parse API response: $e");
        }
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Terjadi kesalahan: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      if (e.response != null) {
        print("Response data: ${e.response!.data}");
      }
      throw e;
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
