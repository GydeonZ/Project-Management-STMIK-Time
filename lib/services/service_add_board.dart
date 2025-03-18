// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class AddBoardListService {
  final Dio _dio = Dio();

  Future<void> hitAddBoardList({
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

      print("API Response: ${response.data}");
    } catch (e) {
      print("Unexpected error: $e");
      rethrow;
    }
  }
}
