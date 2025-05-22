// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_add_board.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class AddBoardListService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelAddBoard?> hitAddBoardList({
    required String token,
    required String name,
    required String visibility,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'visibility': visibility,
      });

      final response = await _dio.post(
        Urls.baseUrls + Urls.board,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelAddBoard.fromJson(response.data);
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
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.baseUrls + Urls.board),
        message: "Kesalahan jaringan",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
