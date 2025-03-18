// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_board.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class BoardService {
  final Dio _dio = Dio();

  Future<ModelBoard> fetchBoard({
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        Urls.baseUrls + Urls.board,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print("API Response: ${response.data}"); // Debugging output
      return ModelBoard.fromJson(response.data);
    } on DioException catch (_) {
      rethrow;
    }
  }
}
