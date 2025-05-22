// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class CardTugasService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // ✅ Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelFetchCardTugas?> fetchCardTugas({
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        Urls.fetchCardList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ModelFetchCardTugas.fromJson(response.data);
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
        requestOptions: RequestOptions(path: Urls.fetchCardList),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
  
  // Future<ModelTambahCardTugas?> hitTambahTugasCard({
  //   required String token,    
  //   required String namaCard,    
  //   required String boardId,    

  // }) async {
  //   try {
  //     final formData = FormData.fromMap({
  //       'name': namaCard,
  //       'board_id': boardId,
  //     });

  //     final response = await _dio.post(
  //       Urls.fetchCardList,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //         data: formData,
  //     );

  //     if (response.statusCode == 200) {
  //       return ModelTambahCardTugas.fromJson(response.data);
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
  //     if (e.response != null) {
  //       throw e; // Lempar kembali error untuk ditangani di ViewModel
  //     }
  //     throw DioException(
  //       requestOptions: RequestOptions(path: Urls.fetchCardList),
  //       message: "Kesalahan jaringan: ${e.message}",
  //       type: DioExceptionType.connectionError,
  //     );
  //   }
  // }
}