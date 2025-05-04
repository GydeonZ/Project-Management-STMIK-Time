// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_add_board_member.dart';
import 'package:projectmanagementstmiktime/model/model_delete_board_member.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_member_board.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class BoardAnggotaListService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500;
    },
  ));

  Future<ModelFetchBoardMember?> fetchBoardAnggotaList({
    required String token,
    required String boardId,
  }) async {
    try {
      final response = await _dio.get(
        "${Urls.board}/$boardId/members",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelFetchBoardMember.fromJson(response.data);
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
        requestOptions: RequestOptions(path: "${Urls.board}$boardId/members"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelDeleteBoardMember?> deleteAnggotaBoard({
    required String token,
    required String boardId,
    required String userId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
      });
      final response = await _dio.post(
        "${Urls.board}/$boardId${Urls.delBoardMember}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelDeleteBoardMember.fromJson(response.data);
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
        requestOptions: RequestOptions(path: "${Urls.board}/$boardId${Urls.delBoardMember}"),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelAddBoardMember?> addBoardAnggotaList({
    required String token,
    required String boardId,
    required String userId,
    required String userLevel,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': userId,
        'level': userLevel,
      });
      final response = await _dio.post(
        "${Urls.board}/$boardId/members",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelAddBoardMember.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Terjadi kesalahan",
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      // ✅ Pastikan error dari API tetap ditampilkan
      if (e.response != null && e.response!.statusCode == 400) {
        throw e; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: "${Urls.board}/$boardId/members"),
        message: "Kesalahan jaringan",
        type: DioExceptionType.connectionError,
      );
    }
  }

  // Future<ModelEditAnggotaTugas?> editAnggotaList({
  //   required String token,
  //   required String taskId,
  //   required String userId,
  //   required String userLevel,
  // }) async {
  //   try {
  //     final formData = FormData.fromMap({
  //       'user_id': userId,
  //       'level': userLevel,
  //     });
  //     final response = await _dio.post(
  //       "${Urls.taskListId}$taskId/members/level",
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //       data: formData,
  //     );

  //     if (response.statusCode == 200) {
  //       return ModelEditAnggotaTugas.fromJson(response.data);
  //     } else {
  //       throw DioException(
  //         response: response,
  //         requestOptions: response.requestOptions,
  //         message: "Terjadi kesalahan: ${response.statusMessage}",
  //         type: DioExceptionType.badResponse,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     // ✅ Pastikan error dari API tetap ditampilkan
  //     if (e.response != null && e.response!.statusCode == 400) {
  //       throw e; // Lempar kembali error untuk ditangani di ViewModel
  //     }
  //     throw DioException(
  //       requestOptions: RequestOptions(path: "${Urls.taskListId}$taskId/members/level"),
  //       message: "Kesalahan jaringan: ${e.message}",
  //       type: DioExceptionType.connectionError,
  //     );
  //   }
  // }
}
